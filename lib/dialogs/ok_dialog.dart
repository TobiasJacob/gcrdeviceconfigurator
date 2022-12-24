import 'package:flutter/material.dart';

Future<bool?> showOkDialog(
    BuildContext context, String title, String content) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        ElevatedButton(
          onPressed: () {
            return Navigator.of(context).pop(false);
          },
          //return false when click on "NO"
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () {
            return Navigator.of(context).pop(true);
          },
          //return true when click on "Yes"
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}
