
import 'dart:typed_data';

/// Calculates the crc32 checksum of a message buffer.
crc32(Uint8List messageBuffer) {
  var crc = 0xffffffff;
  for (var i = 0; i < messageBuffer.length; i++) {
    crc = crc ^ messageBuffer[i];
    for (var j = 0; j < 8; j++) {
      if ((crc & 1) == 1) {
        crc = (crc >> 1) ^ 0xedb88320;
      } else {
        crc = crc >> 1;
      }
    }
  }
  return crc;
}
