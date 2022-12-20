import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final String errorMsg;

  const AppError({super.key, required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    const title = "Get Closer Racing Configurator";
    return MaterialApp(
        title: title,
        home: Scaffold(
          appBar: AppBar(
            title: const Text("Error"),
          ),
          body: Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                  child: Text(
                errorMsg,
                textAlign: TextAlign.center,
              ))),
        ));
  }
}
