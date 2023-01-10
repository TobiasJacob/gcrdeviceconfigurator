import 'dart:ffi';

import 'package:dartusbhid/open_device.dart';
import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';

void readConfig(OpenUSBDevice device, AppSettings appSettings, Database database) {
  // Read buffer from device
  device.readReport(0);

  final buffer = WriteBuffer();
  // Report ID
  buffer.putUint8(0);
  
  // Channel Data for 10 channels
  for (var channel in appSettings.channelSettings) {
    // 0: Usage.gas, 1: Usage.brake, 2: Usage.clutch, 3: Usage.handbrake
    buffer.putUint32(channel.usage.index);
    buffer.putInt32(channel.maxValue);
    buffer.putInt32(channel.minValue);
  }
  
  // Axis Data for each usage implemented on pcb
  final usagesOnPCB = [Usage.gas, Usage.brake, Usage.clutch, Usage.handbrake];
  for (final usage in usagesOnPCB) {
    final axis = database.activeProfile.axes[usage]!;
    buffer.putUint32(axis.dataPoints.length);
    for (final dataPoint in axis.dataPoints) {
      buffer.putUint32((dataPoint.x * 4294967295).round());
      buffer.putUint32((dataPoint.y * 4294967295).round());
    }
  }
}