import 'dart:io';

import 'package:dartusbhid/enumerate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gcrdeviceconfigurator/data/app_settings.dart';
import 'package:gcrdeviceconfigurator/data/axis.dart';
import 'package:gcrdeviceconfigurator/data/data_point.dart';
import 'package:gcrdeviceconfigurator/data/database.dart';
import 'package:gcrdeviceconfigurator/data/profile.dart';
import 'package:gcrdeviceconfigurator/usb/config_serialize.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  test('Export profile', () async {
    final database = Database();
    final appSettings = AppSettings();
    final buffer = serializeConfig(appSettings, database);

    expect(buffer.length, 201);
  });
}
