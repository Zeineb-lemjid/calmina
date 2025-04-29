import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
        if (onRetry != null)
          ElevatedButton(
            onPressed: () {
              Get.back();
              onRetry!();
            },
            child: const Text('Retry'),
          ),
      ],
    );
  }

  static void show({
    String title = 'Error',
    required String message,
    VoidCallback? onRetry,
  }) {
    Get.dialog(
      ErrorDialog(
        title: title,
        message: message,
        onRetry: onRetry,
      ),
    );
  }
}
