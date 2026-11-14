import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;
  final String title;
  final String content;

  const AppAlertDialog({
    super.key,
    required this.onYesPressed,
    required this.onNoPressed,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: onNoPressed,
          child: Text(
            'No',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        TextButton(
          onPressed: onYesPressed,
          child: Text(
            'Yes',
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
      title: Text(title),
      content: Text(content),
    );
  }
}