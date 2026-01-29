import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import '../models/agent_model.dart';

/// Dialog for editing agent metadata and content
class EditAgentDialog extends StatefulWidget {
  final AgentModel agent;

  const EditAgentDialog({
    super.key,
    required this.agent,
  });

  @override
  State<EditAgentDialog> createState() => _EditAgentDialogState();
}

class _EditAgentDialogState extends State<EditAgentDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _toolsController;
  late TextEditingController _contentController;
  String? _selectedModel;

  final List<String> _availableModels = ['opus', 'sonnet', 'haiku'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.agent.name);
    _descriptionController = TextEditingController(text: widget.agent.description);
    _toolsController = TextEditingController(
      text: widget.agent.tools?.join(', ') ?? '',
    );
    _contentController = TextEditingController(
      text: widget.agent.contentWithoutFrontmatter,
    );
    _selectedModel = widget.agent.model;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _toolsController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handleSave() {
    // Parse tools from comma-separated string
    final tools = _toolsController.text.isEmpty
        ? null
        : _toolsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    final updatedAgent = widget.agent.copyWith(
      name: _nameController.text,
      description: _descriptionController.text,
      tools: tools,
      model: _selectedModel,
      contentWithoutFrontmatter: _contentController.text,
    );

    Navigator.of(context).pop(updatedAgent);
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
                    'Edit Agent',
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
                placeholder: 'Agent name',
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
                placeholder: 'Agent description',
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              // Model and Tools row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Model dropdown
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Model',
                          style: MacosTheme.of(context).typography.headline.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        MacosPopupButton<String?>(
                          value: _selectedModel,
                          onChanged: (value) {
                            setState(() {
                              _selectedModel = value;
                            });
                          },
                          items: [
                            const MacosPopupMenuItem(
                              value: null,
                              child: Text('Default'),
                            ),
                            ..._availableModels.map(
                              (model) => MacosPopupMenuItem(
                                value: model,
                                child: Text(model),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Tools field
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tools (comma-separated)',
                          style: MacosTheme.of(context).typography.headline.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        MacosTextField(
                          controller: _toolsController,
                          placeholder: 'e.g., Read, Write, Bash',
                        ),
                      ],
                    ),
                  ),
                ],
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
                    placeholder: 'Agent content in markdown format',
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
