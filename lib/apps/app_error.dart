import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppError extends ConsumerWidget {
  final String errorMsg;
  
  final void Function() onResetToFactory;

  const AppError({super.key, required this.errorMsg, required this.onResetToFactory});

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
                      onPressed: onResetToFactory,
                      child: const Text(
                          "Reset to Factory (this will delete all profiles and calibration data)")),
                ],
              ))),
        ));
  }
}
