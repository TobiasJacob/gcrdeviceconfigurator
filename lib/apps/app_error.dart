import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final String errorMsg;

  final void Function() resetToFactory;

  const AppError(
      {super.key, required this.errorMsg, required this.resetToFactory});

  @override
  Widget build(BuildContext context) {
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
                      onPressed: resetToFactory,
                      child: const Text(
                          "Reset to Factory (this will delete all profiles and calibration data)")),
                ],
              ))),
        ));
  }
}
