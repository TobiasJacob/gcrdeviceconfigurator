import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gcrdeviceconfigurator/data/profile_axis.dart';

import 'app_settings.dart';

part 'button.freezed.dart';
part 'button.g.dart';

@freezed
class Button with _$Button {
  const Button._();

  @Assert('lowerThreshold >= 0')
  @Assert('lowerThreshold < 4096')
  @Assert('upperThreshold >= 0')
  @Assert('upperThreshold < 4096')
  @Assert('lowerThreshold < upperThreshold')
  factory Button({
    required ButtonUsage usage,
    required int lowerThreshold,
    required int upperThreshold,
    required bool inverted
  }) = _Button;

  factory Button.empty() => Button(usage: ButtonUsage.none, lowerThreshold: 1536, upperThreshold: 2560, inverted: false);

  factory Button.fromJson(Map<String, Object?> json)
      => _$ButtonFromJson(json);

  Button updateButtonUsage(ButtonUsage usage) {
    return copyWith(usage: usage);
  }

  Button updateLowerThreshold(int lowerThreshold) {
    return copyWith(lowerThreshold: lowerThreshold);
  }

  Button updateUpperThreshold(int upperThreshold) {
    return copyWith(upperThreshold: upperThreshold);
  }

  Button updateBothThreshold(int lowerThreshold, int upperThreshold) {
    return copyWith(lowerThreshold: lowerThreshold, upperThreshold: upperThreshold);
  }

  Button updateInverted(bool inverted) {
    return copyWith(inverted: inverted);
  }
}
