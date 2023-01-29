import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'app_settings.dart';

part 'channel.freezed.dart';
part 'channel.g.dart';

@freezed
class Channel with _$Channel {
  const Channel._();

  @Assert('minValue >= 0')
  @Assert('minValue < 4096')
  @Assert('maxValue >= 0')
  @Assert('maxValue < 4096')
  @Assert('minValue < maxValue')
  factory Channel({
    required Usage usage,
    required int minValue,
    required int maxValue
  }) = _Channel;

  factory Channel.empty() => Channel(usage: Usage.none, minValue: 0, maxValue: 4095);

  factory Channel.fromJson(Map<String, Object?> json)
      => _$ChannelFromJson(json);

  Channel updateChannelUsage(Usage usage) {
    return copyWith(usage: usage);
  }

  Channel updateMinValue(int minValue) {
    return copyWith(minValue: minValue);
  }

  Channel updateMaxValue(int maxValue) {
    return copyWith(maxValue: maxValue);
  }

  Channel updateMinMaxValue(int minValue, int maxValue) {
    return copyWith(minValue: minValue, maxValue: maxValue);
  }
}
