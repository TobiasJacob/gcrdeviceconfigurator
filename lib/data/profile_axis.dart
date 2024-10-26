import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import 'data_point.dart';

part 'profile_axis.freezed.dart';
part 'profile_axis.g.dart';

// Parabola function
double parabola(double x) {
  return 4 * x * (1 - x);
}

@freezed
class ProfileAxis with _$ProfileAxis {
  const ProfileAxis._();

  @Assert('dataPoints.isNotEmpty')
  factory ProfileAxis({required List<DataPoint> dataPoints}) = _ProfileAxis;

  factory ProfileAxis.empty() => ProfileAxis(
      dataPoints: const [DataPoint(x: 0.0, y: 0.0), DataPoint(x: 1.0, y: 1.0)]);

  factory ProfileAxis.fromJson(Map<String, Object?> json) =>
      _$ProfileAxisFromJson(json);

  factory ProfileAxis.preset(int index) {
    switch (index) {
      case 1:
      // for loop with parabola
        return ProfileAxis(dataPoints: [
          for (var i = 0; i <= 10; i++)
            DataPoint(x: i / 10, y: parabola(i / 10))
        ]);
      case 2:
        return ProfileAxis(dataPoints: [
          DataPoint(x: 0.0, y: 0.0),
          DataPoint(x: 0.33, y: 0.33),
          DataPoint(x: 0.66, y: 0.66),
          DataPoint(x: 1.0, y: 1.0)
        ]);
      case 3:
        return ProfileAxis(dataPoints: [
          DataPoint(x: 0.0, y: 0.0),
          DataPoint(x: 0.5, y: 0.5),
          DataPoint(x: 0.5, y: 0.5),
          DataPoint(x: 1.0, y: 1.0)
        ]);
      case 4:
        return ProfileAxis(dataPoints: [
          DataPoint(x: 0.0, y: 0.0),
          DataPoint(x: 0.5, y: 0.5),
          DataPoint(x: 0.5, y: 0.5),
          DataPoint(x: 1.0, y: 1.0)
        ]);
      case 5:
        return ProfileAxis(dataPoints: [
          DataPoint(x: 0.0, y: 0.0),
          DataPoint(x: 0.5, y: 0.5),
          DataPoint(x: 0.5, y: 0.5),
          DataPoint(x: 1.0, y: 1.0)
        ]);
      case 6:
        return ProfileAxis(dataPoints: [
          DataPoint(x: 0.0, y: 0.0),
          DataPoint(x: 0.5, y: 0.5),
          DataPoint(x: 0.5, y: 0.5),
          DataPoint(x: 1.0, y: 1.0)
        ]);
      default:
        return ProfileAxis(dataPoints: [
          const DataPoint(x: 0.0, y: 0.0),
          const DataPoint(x: 1.0, y: 1.0)
        ]);
    }
  }

  double getY(double x) {
    if (x < dataPoints[0].x) {
      return dataPoints[0].y;
    }

    for (var i = 1; i < dataPoints.length; i++) {
      if (x < dataPoints[i].x) {
        // Linear interpolation
        return dataPoints[i - 1].y +
            (dataPoints[i].y - dataPoints[i - 1].y) *
                (x - dataPoints[i - 1].x) /
                (dataPoints[i].x - dataPoints[i - 1].x);
      }
    }

    return dataPoints[dataPoints.length - 1].y;
  }

  ProfileAxis updateChartDataPoint(int i, DataPoint point) {
    var x = point.x;
    var y = point.y;
    if (i > 0) {
      x = max(x, dataPoints[i - 1].x);
    } else {
      x = max(x, 0);
    }
    if (i < dataPoints.length - 1) {
      x = min(x, dataPoints[i + 1].x);
    } else {
      x = min(x, 1);
    }
    y = max(y, 0);
    y = min(y, 1);
    return copyWith(
        dataPoints: List.of(dataPoints)..[i] = DataPoint(x: x, y: y));
  }

  ProfileAxis deleteChartDataPointIfMoreThanTwo(int i) {
    if (dataPoints.length > 2) {
      return copyWith(dataPoints: List.of(dataPoints)..removeAt(i));
    } else {
      return this;
    }
  }

  ProfileAxis addChartDataPointAfter(int i) {
    return copyWith(
        dataPoints: List.of(dataPoints)
          ..insert(
              i + 1,
              DataPoint(
                x: (dataPoints[i].x + dataPoints[i + 1].x) / 2,
                y: (dataPoints[i].y + dataPoints[i + 1].y) / 2,
              )));
  }
}
