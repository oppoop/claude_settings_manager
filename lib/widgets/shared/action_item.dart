import 'package:flutter/widgets.dart';

/// Helper class to hold action controllers for hook editing
class ActionItem {
  final TextEditingController typeController;
  final TextEditingController commandController;

  ActionItem({
    required this.typeController,
    required this.commandController,
  });

  void dispose() {
    typeController.dispose();
    commandController.dispose();
  }
}
