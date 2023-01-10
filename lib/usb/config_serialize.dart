import 'dart:ffi';

import 'package:dartusbhid/open_device.dart';
import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';

import 'crc32.dart';

/// Serializes the current configuration of the device into a buffer.
Uint8List serializeConfig(AppSettings appSettings, Database database) {
  final buffer = WriteBuffer();
  // Report ID
  buffer.putUint8(2);
  
  // Channel Data for 10 channels (10 * 3 * 4 = 120 bytes)
  for (var channel in appSettings.channelSettings) {
    // 0: Usage.gas, 1: Usage.brake, 2: Usage.clutch, 3: Usage.handbrake
    buffer.putUint32(channel.usage.index);
    buffer.putInt32(channel.maxValue);
    buffer.putInt32(channel.minValue);
  }
  
  // Axis Data for each usage implemented on pcb (4 * (1 + n * 2) * 4 bytes)
  final usagesOnPCB = [Usage.gas, Usage.brake, Usage.clutch, Usage.handbrake];
  for (final usage in usagesOnPCB) {
    final axis = database.activeProfile.axes[usage]!;
    buffer.putUint32(axis.dataPoints.length);
    for (final dataPoint in axis.dataPoints) {
      buffer.putUint32((dataPoint.x * 4294967295).round());
      buffer.putUint32((dataPoint.y * 4294967295).round());
    }
  }

  // Write to device
  final messageBufferBytes = buffer.done();
  final messageBuffer = messageBufferBytes.buffer.asUint8List(messageBufferBytes.offsetInBytes, messageBufferBytes.lengthInBytes);
  return messageBuffer;
  // Calculate crc checksum
  final crc = crc32(messageBuffer);
  // Append crc checksum to message buffer
  final buffer2 = WriteBuffer();
  buffer2.putInt32(messageBuffer.length);
  buffer2.putUint8List(messageBuffer);
  buffer2.putUint32(crc);
  // Return message buffer
  var finalBuffer = buffer2.done();
  final finalBufferResult = finalBuffer.buffer.asUint8List(finalBuffer.offsetInBytes, finalBuffer.lengthInBytes);
  assert(crc32(finalBufferResult) == 0);
  return finalBufferResult;
}

// import 'dart:ffi';

// import 'package:dartusbhid/open_device.dart';
// import 'package:flutter/foundation.dart';
// import 'package:gcrdeviceconfigurator/data/app_settings.dart';
// import 'package:gcrdeviceconfigurator/data/database.dart';

// /// Serializes the current configuration of the device into a buffer. Buffer size should be 157 bytes.
// Uint8List serializeConfig(AppSettings appSettings, Database database) {
//   final buffer = ByteData(169);
//   var cursor = 0;
//   // Report ID
//   buffer.setUint8(cursor, 0);
//   cursor += 1;
  
//   // Channel Data for 10 channels (10 * 3 * 4 = 120 bytes)
//   for (var channel in appSettings.channelSettings) {
//     // 0: Usage.gas, 1: Usage.brake, 2: Usage.clutch, 3: Usage.handbrake
//     buffer.setUint32(cursor, channel.usage.index);
//     cursor += 4;
//     buffer.setUint32(cursor, channel.maxValue);
//     cursor += 4;
//     buffer.setUint32(cursor, channel.minValue);
//     cursor += 4;
//   }
  
//   // Axis Data for each usage implemented on pcb (4 * 3 * 4 = 48 bytes)
//   final usagesOnPCB = [Usage.gas, Usage.brake, Usage.clutch, Usage.handbrake];
//   for (final usage in usagesOnPCB) {
//     final axis = database.activeProfile.axes[usage]!;
//     buffer.setUint32(cursor, axis.dataPoints.length);
//     cursor += 4;
//     for (final dataPoint in axis.dataPoints) {
//       buffer.setUint32(cursor, (dataPoint.x * 4294967295).round());
//       cursor += 4;
//       buffer.setUint32(cursor, (dataPoint.y * 4294967295).round());
//       cursor += 4;
//     }
//   }

//   assert(cursor == buffer.lengthInBytes);

//   // Write to device
//   return buffer.buffer.asUint8List();
// }