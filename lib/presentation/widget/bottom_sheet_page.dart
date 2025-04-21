import 'package:flutter/material.dart';

class BottomSheetPage extends Page {
  final String title;
  final Widget content;
  final Function() onCancel;
  const BottomSheetPage(
      {required this.title,
      required this.content,
      required this.onCancel,
      super.key});

  @override
  Route createRoute(BuildContext context) {
    return ModalBottomSheetRoute(
      isDismissible: false,
      settings: this,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    onCancel();
                  },
                ),
              ),
              const SizedBox(height: 8),
              content,
            ],
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}
