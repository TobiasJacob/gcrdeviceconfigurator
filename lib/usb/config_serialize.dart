import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';

import '../data/profile.dart';

/// Serializes the current configuration of the device into a buffer.
Uint8List serializeConfig(AppSettings appSettings, Profile activeProfile) {
  final buffer = WriteBuffer();
  // Axis Data for each usage implemented on pcb (4 * (1 + n * 2) * 4 bytes)
  final usagesOnPCB = [Usage.gas, Usage.brake, Usage.clutch, Usage.handbrake];
  for (final usage in usagesOnPCB) {
    final axis = activeProfile.axes[usage]!;
    var channelIndex = -1;
    for (var i = 0; i < appSettings.channelSettings.length; i++) {
      if (appSettings.channelSettings[i].usage == usage) {
        channelIndex = i;
        break;
      }
    }
    buffer.putUint8(channelIndex);
    if (channelIndex == -1) {
      buffer.putUint16(0);
      buffer.putUint16(4095);
    } else {
      buffer.putUint16(appSettings.channelSettings[channelIndex].minValue);
      buffer.putUint16(appSettings.channelSettings[channelIndex].maxValue);
    }
    for (final dataPoint in axis.dataPoints) {
      buffer.putUint16((dataPoint.x * 4096).round().clamp(0, 4095));
      buffer.putUint16((dataPoint.y * 4096).round().clamp(0, 4095));
    }
    for (var i = 0; i < 20 - axis.dataPoints.length; i++) {
      buffer.putUint16(4095);
      buffer.putUint16(4095);
    }
  }

  // Write to device
  final messageBufferBytes = buffer.done();
  final messageBuffer = messageBufferBytes.buffer.asUint8List(messageBufferBytes.offsetInBytes, messageBufferBytes.lengthInBytes);
  return messageBuffer;
}
