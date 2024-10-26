import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';

/// Serializes the current configuration of the device into a buffer.
Uint8List serializeConfig(AppSettings appSettings) {
  final buffer = WriteBuffer();
  // Axis Data for each usage implemented on pcb (4 * (1 + n * 2) * 4 bytes)
  buffer.putUint32(0xdeadbeef); // Magic number
  for (int i = 0; i < 10; i++) {
    final usage = appSettings.channelSettings[i].usage;
    var channelDisabled = usage == Usage.none;
    // // If brake1 and brake2 are both enabled, disable brake2 and use sensor data fusion instead
    // if (usage == Usage.brake2 && appSettings.numOfChannelsWithUsage(Usage.brake1) == 1) {
    //   channelDisabled = true;
    // }
    // // If gas1 and gas2 are both enabled, disable gas2 and use sensor data fusion instead
    // if (usage == Usage.gas2 && appSettings.numOfChannelsWithUsage(Usage.gas1) == 1) {
    //   channelDisabled = true;
    // }

    final inverted = appSettings.channelSettings[i].inverted;

    final profileAxis = appSettings.channelSettings[i].profileAxis;

    if (channelDisabled) {
      buffer.putUint8(0); // Axis not used
    } else {
      buffer.putUint8(1); // Axis used
    }
    buffer.putUint16(appSettings.channelSettings[i].minValue); // Min value
    buffer.putUint16(appSettings.channelSettings[i].maxValue); // Max value

    var channelForSensorDataFusion = -1;
    // Sensor data fusion is disabled now
    // if (usage == Usage.brake1) {
    //   // If brake1 is used, brake2 might be used for sensor data fusion if it is found, meaning channelWithUsage does not return -1. If -1 is returned, sensor data fusion is not used.
    //   channelForSensorDataFusion = appSettings.channelWithUsage(Usage.brake2);
    // }
    // if (usage == Usage.gas1) {
    //   // If gas1 is used, gas2 might be used for sensor data fusion if it is found, meaning channelWithUsage does not return -1. If -1 is returned, sensor data fusion is not used.
    //   channelForSensorDataFusion = appSettings.channelWithUsage(Usage.gas2);
    // }
    if (channelForSensorDataFusion == -1) {
      buffer.putUint8(0xFF); // Channel for sensor data fusion hardcoded to 0xFF
    } else {
      buffer.putUint8(channelForSensorDataFusion);
    }

    for (final dataPoint in profileAxis.dataPoints) {
      if (inverted) {
        buffer.putUint16((dataPoint.x * 4096).round().clamp(0, 4095));
        buffer.putUint16((4095 - dataPoint.y * 4096).round().clamp(0, 4095));
      } else {
        buffer.putUint16((dataPoint.x * 4096).round().clamp(0, 4095));
        buffer.putUint16((dataPoint.y * 4096).round().clamp(0, 4095));
      }
    }
    for (var i = 0; i < 20 - profileAxis.dataPoints.length; i++) {
      if (inverted) {
        buffer.putUint16(4095);
        buffer.putUint16(0);
      } else {
        buffer.putUint16(4095);
        buffer.putUint16(4095);
      }
    }
  }

  // Write to device
  final messageBufferBytes = buffer.done();
  final messageBuffer = messageBufferBytes.buffer.asUint8List(
      messageBufferBytes.offsetInBytes, messageBufferBytes.lengthInBytes);
  debugPrint("Message buffer: $messageBuffer");
  return messageBuffer;
}
