import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

/// Common permission presets
const List<String> commonPermissions = [
  'Bash(*)',
  'Bash(git:*)',
  'Read(*)',
  'Write(*)',
  'Edit(*)',
  'WebFetch(*)',
  'WebSearch(*)',
  'mcp__*',
];

/// Dialog result containing permission and target list
class PermissionDialogResult {
  final String permission;
  final bool isAllowList;

  PermissionDialogResult({
    required this.permission,
    required this.isAllowList,
  });
}

/// Dialog for adding a new permission
class AddPermissionDialog extends StatefulWidget {
  const AddPermissionDialog({super.key});

  @override
  State<AddPermissionDialog> createState() => _AddPermissionDialogState();
}

class _AddPermissionDialogState extends State<AddPermissionDialog> {
  late TextEditingController _customController;
  String? _selectedPreset;
  bool _isAllowList = true;

  @override
  void initState() {
    super.initState();
    _customController = TextEditingController();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  String get _currentPermission {
    if (_customController.text.isNotEmpty) {
      return _customController.text;
    }
    return _selectedPreset ?? '';
  }

  void _handlePresetSelect(String preset) {
    setState(() {
      _selectedPreset = preset;
      _customController.clear();
    });
  }

  void _handleCustomInput() {
    setState(() {
      _selectedPreset = null;
    });
  }

  void _handleSave() {
    final permission = _currentPermission.trim();
    if (permission.isEmpty) {
      showMacosAlertDialog(
        context: context,
        builder: (context) => MacosAlertDialog(
          appIcon: const FlutterLogo(size: 56),
          title: const Text('No Permission'),
          message: const Text('Please select a preset or enter a custom permission.'),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pop(PermissionDialogResult(
      permission: permission,
      isAllowList: _isAllowList,
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
          width: 500,
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
                      Icons.security,
                      color: MacosTheme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add Permission',
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

              // Target list selection
              Text(
                'Add to',
                style: MacosTheme.of(context).typography.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  MacosRadioButton<bool>(
                    groupValue: _isAllowList,
                    value: true,
                    onChanged: (value) => setState(() => _isAllowList = value!),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isAllowList = true),
                    child: Row(
                      children: [
                        const MacosIcon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text('Allow List', style: MacosTheme.of(context).typography.body),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  MacosRadioButton<bool>(
                    groupValue: _isAllowList,
                    value: false,
                    onChanged: (value) => setState(() => _isAllowList = value!),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isAllowList = false),
                    child: Row(
                      children: [
                        const MacosIcon(Icons.cancel, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text('Deny List', style: MacosTheme.of(context).typography.body),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Preset permissions
              Text(
                'Common Permissions',
                style: MacosTheme.of(context).typography.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: commonPermissions.map((preset) {
                  final isSelected = _selectedPreset == preset && _customController.text.isEmpty;
                  return GestureDetector(
                    onTap: () => _handlePresetSelect(preset),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? MacosTheme.of(context).primaryColor
                            : MacosTheme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? MacosTheme.of(context).primaryColor
                              : MacosTheme.of(context).dividerColor,
                        ),
                      ),
                      child: Text(
                        preset,
                        style: MacosTheme.of(context).typography.caption1.copyWith(
                              color: isSelected ? Colors.white : null,
                              fontFamily: 'monospace',
                            ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Custom permission
              Text(
                'Or Custom Permission',
                style: MacosTheme.of(context).typography.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              MacosTextField(
                controller: _customController,
                placeholder: 'e.g., Bash(npm:*)',
                style: const TextStyle(fontFamily: 'monospace'),
                onChanged: (_) => _handleCustomInput(),
              ),
              const SizedBox(height: 8),
              Text(
                'Current: ${_currentPermission.isEmpty ? "(none)" : _currentPermission}',
                style: MacosTheme.of(context).typography.caption1.copyWith(
                      color: MacosTheme.of(context).primaryColor,
                      fontFamily: 'monospace',
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
                    child: const Text('Add Permission'),
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
