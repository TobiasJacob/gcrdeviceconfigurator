import 'package:flutter/material.dart';
import 'package:gcrdeviceconfigurator/data/settings_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppError extends ConsumerWidget {
  final String errorMsg;

  const AppError({super.key, required this.errorMsg});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const title = "Pedal Config";
    return MaterialApp(
        title: title,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Error"),
          ),
          body: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                  child: Column(
                children: [
                  Text(
                    errorMsg,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        ref.read(settingsProvider.notifier).resetToFactory();
                      },
                      child: const Text(
                          "Reset to Factory (this will delete all profiles and calibration data)")),
                ],
              ))),
        ));
  }
}
