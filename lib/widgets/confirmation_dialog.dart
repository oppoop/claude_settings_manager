import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

/// Show a confirmation dialog with custom title, message and actions
Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  bool isDestructive = false,
}) async {
  final result = await showMacosAlertDialog<bool>(
    context: context,
    builder: (context) => MacosAlertDialog(
      appIcon: const FlutterLogo(size: 56),
      title: Text(title),
      message: Text(message),
      primaryButton: PushButton(
        controlSize: ControlSize.large,
        color: isDestructive ? Colors.red : null,
        onPressed: () {
          Navigator.of(context).pop(true);
        },
        child: Text(confirmText),
      ),
      secondaryButton: PushButton(
        controlSize: ControlSize.large,
        secondary: true,
        onPressed: () {
          Navigator.of(context).pop(false);
        },
        child: Text(cancelText),
      ),
    ),
  );

  return result ?? false;
}

/// Show a delete confirmation dialog
Future<bool> showDeleteConfirmation({
  required BuildContext context,
  required String itemName,
  required String itemType,
}) {
  return showConfirmationDialog(
    context: context,
    title: 'Delete $itemType?',
    message: 'Are you sure you want to delete "$itemName"? This action cannot be undone.',
    confirmText: 'Delete',
    cancelText: 'Cancel',
    isDestructive: true,
  );
}
