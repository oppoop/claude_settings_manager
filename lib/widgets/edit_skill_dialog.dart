import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import '../models/skill_model.dart';

/// Dialog for editing skill name, description, and content
class EditSkillDialog extends StatefulWidget {
  final SkillModel skill;

  const EditSkillDialog({
    super.key,
    required this.skill,
  });

  @override
  State<EditSkillDialog> createState() => _EditSkillDialogState();
}

class _EditSkillDialogState extends State<EditSkillDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.skill.name);
    _descriptionController = TextEditingController(text: widget.skill.description);
    _contentController = TextEditingController(text: widget.skill.contentWithoutFrontmatter);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final updatedSkill = widget.skill.copyWith(
      name: _nameController.text,
      description: _descriptionController.text,
      contentWithoutFrontmatter: _contentController.text,
    );

    Navigator.of(context).pop(updatedSkill);
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
                      Icons.edit,
                      color: MacosTheme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Edit Skill',
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

              // Name field
              Text(
                'Name',
                style: MacosTheme.of(context).typography.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              MacosTextField(
                controller: _nameController,
                placeholder: 'Skill name',
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
                placeholder: 'Skill description',
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
