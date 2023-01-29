import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';

import '../data/profile.dart';

/// Serializes the current configuration of the device into a buffer.
Uint8List serializeConfig(AppSettings appSettings, Profile activeProfile) {
  final buffer = WriteBuffer();
  // Axis Data for each usage implemented on pcb (4 * (1 + n * 2) * 4 bytes)
  buffer.putUint32(0xdeadbeef); // Magic number
  for (int i = 0; i < 10; i++) {
    final usage = appSettings.channelSettings[i].usage;
    final axis = activeProfile.axes[usage];
    if (axis == null) {
      buffer.putUint8(0); // Axis not used
      buffer.putUint16(0);
      buffer.putUint16(4095);
      buffer.putUint16(0);
      buffer.putUint16(0);
      for (var i = 1; i < 20; i++) {
        buffer.putUint16(4095);
        buffer.putUint16(4095);
      }
    } else {
      buffer.putUint8(1); // Axis used
      buffer.putUint16(appSettings.channelSettings[i].minValue);
      buffer.putUint16(appSettings.channelSettings[i].maxValue);
      for (final dataPoint in axis.dataPoints) {
        buffer.putUint16((dataPoint.x * 4096).round().clamp(0, 4095));
        buffer.putUint16((dataPoint.y * 4096).round().clamp(0, 4095));
      }
      for (var i = 0; i < 20 - axis.dataPoints.length; i++) {
        buffer.putUint16(4095);
        buffer.putUint16(4095);
      }
    }
  }

  // Write to device
  final messageBufferBytes = buffer.done();
  final messageBuffer = messageBufferBytes.buffer.asUint8List(messageBufferBytes.offsetInBytes, messageBufferBytes.lengthInBytes);
  return messageBuffer;
}
