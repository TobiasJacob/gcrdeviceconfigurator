import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';

import 'gcr_device.dart';

part 'usb_data.freezed.dart';

@freezed
class UsbData with _$UsbData {
  @Assert('currentValues.length == 10')
  factory UsbData.connected({
    required List<int> currentValues,
    required GcrUsbHidDevice device,
  }) = _UsbConnected;

  const factory UsbData.disconnected() = _UsbDisconnected;
  const factory UsbData.uninitialized() = _UsbUninitialized;
}

double parseValue(AppSettings appSettings, List<int> rawValues, ProfileAxisType profileAxisType) {
  var result = 0.0;
  var count = 0.0;
  for (var i = 0; i < 10; i++) {
    final channel = appSettings.channelSettings[i];
    final currentProfileAxisType = getProfileAxisForUsage(channel.usage);
    final val = rawValues[i].toDouble();
    final calibratedVal = (val - channel.minValue) / (channel.maxValue - channel.minValue);
    if (currentProfileAxisType == profileAxisType) {
      result += calibratedVal;
      count++;
    }
  }
  return result / count;
}