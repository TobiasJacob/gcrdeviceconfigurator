import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/apps/app_loading.dart';
import 'package:gcrdeviceconfigurator/root_widget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: RootWidget()));
}
