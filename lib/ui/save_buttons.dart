import 'package:flutter/material.dart';

class SaveOrResetButtons extends StatelessWidget {
  final Function() onSave;
  final Function() onDiscard;

  const SaveOrResetButtons(
      {super.key, required this.onSave, required this.onDiscard});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: onSave,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Save",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          ElevatedButton(
            onPressed: onDiscard,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Discard",
                style: TextStyle(fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }
}
