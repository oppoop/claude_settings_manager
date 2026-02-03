import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

/// Dialog result containing plugin name and enabled state
class PluginDialogResult {
  final String name;
  final bool enabled;

  PluginDialogResult({
    required this.name,
    required this.enabled,
  });
}

/// Dialog for adding a new plugin
class AddPluginDialog extends StatefulWidget {
  const AddPluginDialog({super.key});

  @override
  State<AddPluginDialog> createState() => _AddPluginDialogState();
}

class _AddPluginDialogState extends State<AddPluginDialog> {
  late TextEditingController _nameController;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      showMacosAlertDialog(
        context: context,
        builder: (context) => MacosAlertDialog(
          appIcon: const FlutterLogo(size: 56),
          title: const Text('No Plugin Name'),
          message: const Text('Please enter a plugin name.'),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pop(PluginDialogResult(
      name: name,
      enabled: _enabled,
    ));
  }

  void _handleCancel() {
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    return MacosSheet(
      child: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                      Icons.extension,
                      color: MacosTheme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add Plugin',
                    style: MacosTheme.of(context).typography.largeTitle,
                  ),
                  const Spacer(),
                  MacosIconButton(
                    icon: const MacosIcon(Icons.close),
                    onPressed: _handleCancel,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Plugin name
              Text(
                'Plugin Name',
                style: MacosTheme.of(context).typography.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              MacosTextField(
                controller: _nameController,
                placeholder: 'e.g., my-plugin',
                autofocus: true,
              ),
              const SizedBox(height: 24),

              // Enabled state
              Text(
                'Initial State',
                style: MacosTheme.of(context).typography.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  MacosSwitch(
                    value: _enabled,
                    onChanged: (value) => setState(() => _enabled = value),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _enabled ? 'Enabled' : 'Disabled',
                    style: MacosTheme.of(context).typography.body.copyWith(
                          color: _enabled ? Colors.green : Colors.grey,
                        ),
                  ),
                ],
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
                    child: const Text('Add Plugin'),
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
