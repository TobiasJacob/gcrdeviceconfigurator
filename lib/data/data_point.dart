import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'data_point.freezed.dart';
part 'data_point.g.dart';

@freezed
class DataPoint with _$DataPoint {
  @Assert('x >= 0')
  @Assert('x <= 1.0')
  @Assert('x >= 0')
  @Assert('x <= 1.0')
  const factory DataPoint({
    required double x,
    required double y
  }) = _DataPoint;

  factory DataPoint.fromJson(Map<String, Object?> json)
      => _$DataPointFromJson(json);
}