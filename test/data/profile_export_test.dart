import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';

void main() {
  test('Export profile', () async {
    final profile = Profile.empty("Test profile");
    profile.axes[Usage.brake]!.updateChartDataPoint(0, DataPoint(0.1, 0.1));
    final file = File.fromRawPath(Uint8List.fromList(
        "C:\\Users\\tobia\\OneDrive\\Desktop\\testfile.txt".codeUnits));
    await profile.export(file);
    assert(await file.exists());
    file.delete();
    assert(!await file.exists());
  });
}
