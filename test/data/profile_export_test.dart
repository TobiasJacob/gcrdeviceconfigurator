import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  test('Export profile', () async {
    final profile = Profile.empty(name: "Test profile");
    profile.axes[Usage.brake]!.updateChartDataPoint(0, const DataPoint(x: 0.1, y: 0.1));
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = "${tempDir.path}/testfile.txt";
    final file = File(tempPath);
    await profile.export(file);
    assert(await file.exists());
    await file.delete();
    assert(!await file.exists());
  });
}
