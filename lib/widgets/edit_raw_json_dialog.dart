import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import '../services/settings_service.dart';

/// Dialog for editing raw JSON settings
class EditRawJsonDialog extends StatefulWidget {
  final String initialJson;

  const EditRawJsonDialog({
    super.key,
    required this.initialJson,
  });

  @override
  State<EditRawJsonDialog> createState() => _EditRawJsonDialogState();
}

class _EditRawJsonDialogState extends State<EditRawJsonDialog> {
  late TextEditingController _jsonController;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _jsonController = TextEditingController(text: widget.initialJson);
    _jsonController.addListener(_validateJson);
  }

  @override
  void dispose() {
    _jsonController.removeListener(_validateJson);
    _jsonController.dispose();
    super.dispose();
  }

  void _validateJson() {
    final text = _jsonController.text;
    if (text.trim().isEmpty) {
      setState(() => _validationError = null);
      return;
    }

    try {
      jsonDecode(text);
      setState(() => _validationError = null);
    } catch (e) {
      setState(() => _validationError = e.toString());
    }
  }

  void _handleFormat() {
    if (_validationError != null) {
      showMacosAlertDialog(
        context: context,
        builder: (context) => MacosAlertDialog(
          appIcon: const FlutterLogo(size: 56),
          title: const Text('Cannot Format'),
          message: const Text('Please fix JSON syntax errors before formatting.'),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ),
      );
      return;
    }

    try {
      final formatted = SettingsService.formatJson(_jsonController.text);
      _jsonController.text = formatted;
    } catch (e) {
      // Should not happen if validation passed
    }
  }

  void _handleSave() {
    if (_validationError != null) {
      showMacosAlertDialog(
        context: context,
        builder: (context) => MacosAlertDialog(
          appIcon: const FlutterLogo(size: 56),
          title: const Text('Invalid JSON'),
          message: Text('Please fix syntax errors before saving:\n\n$_validationError'),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pop(_jsonController.text);
  }

  void _handleCancel() {
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    return MacosSheet(
      child: Center(
        child: Container(
          width: 800,
          height: 700,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: MacosTheme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: MacosIcon(
                      Icons.code,
                      color: MacosTheme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit settings.json',
                          style: MacosTheme.of(context).typography.largeTitle,
                        ),
                        Text(
                          'Advanced JSON editor',
                          style: MacosTheme.of(context).typography.caption1,
                        ),
                      ],
                    ),
                  ),
                  PushButton(
                    controlSize: ControlSize.regular,
                    secondary: true,
                    onPressed: _handleFormat,
                    child: const Text('Format'),
                  ),
                  const SizedBox(width: 8),
                  MacosIconButton(
                    icon: const MacosIcon(Icons.close),
                    onPressed: _handleCancel,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Validation error display
              if (_validationError != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const MacosIcon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _validationError!,
                          style: MacosTheme.of(context).typography.caption1.copyWith(
                                color: Colors.red,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

              // JSON editor
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _validationError != null
                          ? Colors.red.withOpacity(0.5)
                          : MacosTheme.of(context).dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: MacosTextField(
                    controller: _jsonController,
                    placeholder: '{\n  "key": "value"\n}',
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PushButton(
                    controlSize: ControlSize.large,
                    secondary: true,
                    onPressed: _handleCancel,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  PushButton(
                    controlSize: ControlSize.large,
                    onPressed: _handleSave,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
