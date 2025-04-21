import 'package:flutter/material.dart';

class DialogPage extends Page {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final Function() onConfirm;
  final Function() onCancel;
  const DialogPage({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
    required this.confirmText,
    required this.cancelText,
    super.key
  });

  @override
  Route createRoute(BuildContext context) {
    return DialogRoute(
      settings: this,
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => onCancel(),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => onConfirm(),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
