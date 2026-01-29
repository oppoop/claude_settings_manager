import 'dart:io';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/app_state_provider.dart';
import '../models/skill_model.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/edit_skill_dialog.dart';
import '../widgets/create_skill_dialog.dart';
import '../theme/app_theme.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  SkillModel? _selectedSkill;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final skills = appState.skills;

        return Row(
          children: [
            // Skills List
            Container(
              width: 300,
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor(context),
                border: Border(
                  right: BorderSide(
                    color: MacosTheme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient(context),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.extension,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Skills (${skills.length})',
                          style: MacosTheme.of(context).typography.headline.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const Spacer(),
                        MacosIconButton(
                          icon: const MacosIcon(Icons.add, color: Colors.white),
                          onPressed: _handleCreateSkill,
                        ),
                        const SizedBox(width: 4),
                        MacosIconButton(
                          icon: const MacosIcon(Icons.refresh, color: Colors.white),
                          onPressed: () {
                            appState.loadSkills();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: skills.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.extension_off,
                                  size: 48,
                                  color: MacosTheme.of(context).typography.caption1.color,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No skills found',
                                  style: MacosTheme.of(context).typography.headline,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: skills.length,
                            itemBuilder: (context, index) {
                              final skill = skills[index];
                              final isSelected = _selectedSkill?.name == skill.name;

                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? MacosTheme.of(context).primaryColor.withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? MacosTheme.of(context).primaryColor
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: MacosListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: MacosTheme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: MacosIcon(
                                      Icons.extension,
                                      color: MacosTheme.of(context).primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    skill.name,
                                    style: MacosTheme.of(context).typography.body.copyWith(
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                        ),
                                  ),
                                  subtitle: Text(
                                    skill.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: MacosTheme.of(context).typography.caption1,
                                  ),
                                  onClick: () {
                                    setState(() {
                                      _selectedSkill = skill;
                                    });
                                  },
                                  mouseCursor: SystemMouseCursors.click,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            // Skill Detail
            Expanded(
              child: _selectedSkill == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient(context),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.extension,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Select a skill to view details',
                            style: MacosTheme.of(context).typography.headline,
                          ),
                        ],
                      ),
                    )
                  : _buildSkillDetail(_selectedSkill!),
            ),
          ],
        );
      },
    );
  }

  /// Handle skill import
  Future<void> _handleImportSkill() async {
    try {
      // Pick a directory
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select Skill Directory',
      );

      if (selectedDirectory == null) return;

      final sourceDir = Directory(selectedDirectory);

      if (!await sourceDir.exists()) {
        throw Exception('Selected directory does not exist');
      }

      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final importedSkill = await appState.skillService?.importSkill(sourceDir);

      // Reload skills
      await appState.loadSkills();

      // Select the imported skill
      if (importedSkill != null) {
        setState(() {
          _selectedSkill = appState.skills.firstWhere(
            (s) => s.id == importedSkill.id,
            orElse: () => importedSkill,
          );
        });
      }

      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Success'),
            message: Text('Skill "${importedSkill?.name}" has been imported.'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Error'),
            message: Text('Failed to import skill: $e'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    }
  }

  /// Handle skill creation
  Future<void> _handleCreateSkill() async {
    final result = await showMacosSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateSkillDialog(),
    );

    if (result == null) return;

    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final newSkill = await appState.skillService?.createSkill(
        id: result['id'],
        name: result['name'],
        description: result['description'],
        initialContent: result['content'],
      );

      // Reload skills
      await appState.loadSkills();

      // Select the newly created skill
      if (newSkill != null) {
        setState(() {
          _selectedSkill = appState.skills.firstWhere(
            (s) => s.id == newSkill.id,
            orElse: () => newSkill,
          );
        });
      }

      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Success'),
            message: Text('Skill "${result['name']}" has been created.'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Error'),
            message: Text('Failed to create skill: $e'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    }
  }

  /// Handle skill editing
  Future<void> _handleEditSkill(SkillModel skill) async {
    final updatedSkill = await showMacosSheet<SkillModel>(
      context: context,
      builder: (context) => EditSkillDialog(skill: skill),
    );

    if (updatedSkill == null) return;

    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      await appState.skillService?.saveSkill(updatedSkill);

      // Reload skills
      await appState.loadSkills();

      // Update selection to the updated skill
      setState(() {
        _selectedSkill = appState.skills.firstWhere(
          (s) => s.id == skill.id,
          orElse: () => skill,
        );
      });

      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Success'),
            message: Text('Skill "${updatedSkill.name}" has been updated.'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Error'),
            message: Text('Failed to update skill: $e'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    }
  }

  /// Handle skill deletion with confirmation
  Future<void> _handleDeleteSkill(SkillModel skill) async {
    final confirmed = await showDeleteConfirmation(
      context: context,
      itemName: skill.name,
      itemType: 'Skill',
    );

    if (!confirmed) return;

    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      await appState.skillService?.deleteSkill(skill);

      // Clear selection
      setState(() {
        _selectedSkill = null;
      });

      // Reload skills
      await appState.loadSkills();

      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Success'),
            message: Text('Skill "${skill.name}" has been deleted.'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Error'),
            message: Text('Failed to delete skill: $e'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    }
  }

  Widget _buildSkillDetail(SkillModel skill) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MacosTheme.of(context).canvasColor,
            MacosTheme.of(context).canvasColor.withOpacity(0.95),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient(context),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.extension,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    skill.name,
                    style: MacosTheme.of(context).typography.largeTitle,
                  ),
                ),
                PushButton(
                  controlSize: ControlSize.regular,
                  onPressed: () => _handleImportSkill(),
                  child: const Row(
                    children: [
                      Icon(Icons.download, size: 16),
                      SizedBox(width: 6),
                      Text('Import'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                PushButton(
                  controlSize: ControlSize.regular,
                  onPressed: () => _handleEditSkill(skill),
                  child: const Row(
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 6),
                      Text('Edit'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                PushButton(
                  controlSize: ControlSize.regular,
                  secondary: true,
                  onPressed: () => _handleDeleteSkill(skill),
                  child: const Row(
                    children: [
                      Icon(Icons.delete, size: 16),
                      SizedBox(width: 6),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(context),
              child: Text(
                skill.description,
                style: MacosTheme.of(context).typography.body,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: MacosTheme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.folder,
                    size: 16,
                    color: MacosTheme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      skill.directoryPath,
                      style: MacosTheme.of(context).typography.caption1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'Content Preview',
                style: MacosTheme.of(context).typography.headline,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.elevatedCardDecoration(context),
              child: SelectableText(
                skill.contentWithoutFrontmatter.substring(
                  0,
                  skill.contentWithoutFrontmatter.length > 500
                      ? 500
                      : skill.contentWithoutFrontmatter.length,
                ),
                style: MacosTheme.of(context).typography.body.copyWith(
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
