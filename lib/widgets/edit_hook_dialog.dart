import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import '../models/settings_model.dart';
import 'shared/action_item.dart';

/// Dialog for editing a hook configuration
class EditHookDialog extends StatefulWidget {
  final String hookType;
  final int configIndex;
  final HookConfig config;

  const EditHookDialog({
    super.key,
    required this.hookType,
    required this.configIndex,
    required this.config,
  });

  @override
  State<EditHookDialog> createState() => _EditHookDialogState();
}

class _EditHookDialogState extends State<EditHookDialog> {
  late TextEditingController _matcherController;
  late List<ActionItem> _actions;

  @override
  void initState() {
    super.initState();
    _matcherController = TextEditingController(text: widget.config.matcher ?? '');
    _actions = (widget.config.hooks ?? []).map((action) {
      return ActionItem(
        typeController: TextEditingController(text: action.type),
        commandController: TextEditingController(text: action.command ?? ''),
      );
    }).toList();

    // Ensure at least one action exists
    if (_actions.isEmpty) {
      _actions.add(ActionItem(
        typeController: TextEditingController(text: 'command'),
        commandController: TextEditingController(),
      ));
    }
  }

  @override
  void dispose() {
    _matcherController.dispose();
    for (final action in _actions) {
      action.dispose();
    }
    super.dispose();
  }

  void _addAction() {
    setState(() {
      _actions.add(ActionItem(
        typeController: TextEditingController(text: 'command'),
        commandController: TextEditingController(),
      ));
    });
  }

  void _removeAction(int index) {
    if (_actions.length > 1) {
      setState(() {
        final action = _actions.removeAt(index);
        action.dispose();
      });
    }
  }

  bool _validateMatcher(String pattern) {
    if (pattern.isEmpty) return true;
    try {
      RegExp(pattern);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _handleSave() {
    // Validate regex pattern
    if (!_validateMatcher(_matcherController.text)) {
      showMacosAlertDialog(
        context: context,
        builder: (context) => MacosAlertDialog(
          appIcon: const FlutterLogo(size: 56),
          title: const Text('Invalid Regex'),
          message: const Text('The matcher pattern is not a valid regular expression.'),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ),
      );
      return;
    }

    final actions = _actions.map((item) {
      return HookAction(
        type: item.typeController.text.trim().isEmpty ? 'command' : item.typeController.text.trim(),
        command: item.commandController.text.isEmpty ? null : item.commandController.text,
      );
    }).toList();

    final updatedConfig = HookConfig(
      matcher: _matcherController.text.isEmpty ? null : _matcherController.text,
      hooks: actions,
    );

    Navigator.of(context).pop(updatedConfig);
  }

  void _handleCancel() {
    Navigator.of(context).pop(null);
  }

  @override
  Widget build(BuildContext context) {
    return MacosSheet(
      child: Center(
        child: Container(
          width: 700,
          height: 600,
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
                      Icons.edit,
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
                          'Edit Hook Configuration',
                          style: MacosTheme.of(context).typography.largeTitle,
                        ),
                        Text(
                          widget.hookType,
                          style: MacosTheme.of(context).typography.caption1.copyWith(
                                fontFamily: 'monospace',
                              ),
                        ),
                      ],
                    ),
                  ),
                  MacosIconButton(
                    icon: const MacosIcon(Icons.close),
                    onPressed: _handleCancel,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Matcher field
              Text(
                'Matcher Pattern (optional)',
                style: MacosTheme.of(context).typography.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Regex pattern to match tool names or other hook-specific criteria',
                style: MacosTheme.of(context).typography.caption1,
              ),
              const SizedBox(height: 8),
              MacosTextField(
                controller: _matcherController,
                placeholder: 'e.g., Bash|Read|Write',
                style: const TextStyle(fontFamily: 'monospace'),
              ),
              const SizedBox(height: 20),

              // Actions
              Row(
                children: [
                  Text(
                    'Actions',
                    style: MacosTheme.of(context).typography.headline.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const Spacer(),
                  MacosIconButton(
                    icon: MacosIcon(
                      Icons.add,
                      color: MacosTheme.of(context).primaryColor,
                    ),
                    onPressed: _addAction,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Actions list
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MacosTheme.of(context).dividerColor,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _actions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _buildActionItem(index),
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

  Widget _buildActionItem(int index) {
    final action = _actions[index];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MacosTheme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: MacosTheme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Action ${index + 1}',
                style: MacosTheme.of(context).typography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              if (_actions.length > 1)
                MacosIconButton(
                  icon: const MacosIcon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                    size: 18,
                  ),
                  onPressed: () => _removeAction(index),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Type',
                      style: MacosTheme.of(context).typography.caption1,
                    ),
                    const SizedBox(height: 4),
                    MacosPopupButton<String>(
                      value: action.typeController.text.isEmpty
                          ? 'command'
                          : action.typeController.text,
                      items: const [
                        MacosPopupMenuItem(
                          value: 'command',
                          child: Text('command'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            action.typeController.text = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Command',
                      style: MacosTheme.of(context).typography.caption1,
                    ),
                    const SizedBox(height: 4),
                    MacosTextField(
                      controller: action.commandController,
                      placeholder: 'e.g., /path/to/script.sh',
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
