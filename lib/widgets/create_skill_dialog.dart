import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

/// Dialog for creating a new skill
class CreateSkillDialog extends StatefulWidget {
  const CreateSkillDialog({super.key});

  @override
  State<CreateSkillDialog> createState() => _CreateSkillDialogState();
}

class _CreateSkillDialogState extends State<CreateSkillDialog> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default content template
    _contentController.text = '''
# Skill Instructions

Describe what this skill does and how it should be used.

## Example Usage

Provide examples of how to use this skill.

## Notes

Add any additional notes or considerations.
''';
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleCreate() {
    if (_formKey.currentState?.validate() ?? false) {
      final result = {
        'id': _idController.text.trim(),
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'content': _contentController.text,
      };

      Navigator.of(context).pop(result);
    }
  }

  void _handleCancel() {
    Navigator.of(context).pop(null);
  }

  String? _validateId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Skill ID is required';
    }

    // Check if ID contains only valid characters (alphanumeric, dash, underscore)
    final idRegex = RegExp(r'^[a-z0-9_-]+$');
    if (!idRegex.hasMatch(value.trim())) {
      return 'ID can only contain lowercase letters, numbers, dashes, and underscores';
    }

    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MacosSheet(
      child: Center(
        child: Container(
          width: 800,
          height: 700,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
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
                        Icons.add,
                        color: MacosTheme.of(context).primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Create New Skill',
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

                // Skill ID field
                Text(
                  'Skill ID (directory name)',
                  style: MacosTheme.of(context).typography.headline.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                MacosTextField(
                  controller: _idController,
                  placeholder: 'e.g., my-custom-skill',
                ),
                if (_idController.text.isNotEmpty && _validateId(_idController.text) != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      _validateId(_idController.text)!,
                      style: MacosTheme.of(context).typography.caption1.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Name field
                Text(
                  'Skill Name',
                  style: MacosTheme.of(context).typography.headline.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                MacosTextField(
                  controller: _nameController,
                  placeholder: 'e.g., My Custom Skill',
                ),
                const SizedBox(height: 16),

                // Description field
                Text(
                  'Description',
                  style: MacosTheme.of(context).typography.headline.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                MacosTextField(
                  controller: _descriptionController,
                  placeholder: 'Brief description of what this skill does',
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Content field
                Text(
                  'Content (Markdown)',
                  style: MacosTheme.of(context).typography.headline.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: MacosTheme.of(context).dividerColor,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: MacosTextField(
                      controller: _contentController,
                      placeholder: 'Skill content in markdown format',
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
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
                      onPressed: _handleCreate,
                      child: const Text('Create Skill'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
