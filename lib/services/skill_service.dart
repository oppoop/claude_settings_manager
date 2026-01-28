import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/skill_model.dart';
import '../models/claude_config.dart';
import '../utils/yaml_parser.dart';
import '../utils/constants.dart';

/// Service for managing Claude skills
class SkillService {
  final ClaudeConfig config;

  SkillService(this.config);

  /// Load all skills from skills directory
  Future<List<SkillModel>> loadAllSkills() async {
    final skills = <SkillModel>[];

    if (!await config.skillsDir.exists()) {
      return skills;
    }

    await for (final entity in config.skillsDir.list()) {
      if (entity is Directory) {
        try {
          final skill = await loadSkill(entity);
          if (skill != null) {
            skills.add(skill);
          }
        } catch (e) {
          // Skip invalid skills
          continue;
        }
      }
    }

    return skills;
  }

  /// Load a single skill from directory
  Future<SkillModel?> loadSkill(Directory skillDir) async {
    final skillFile = File(path.join(skillDir.path, AppConstants.skillFileName));

    if (!await skillFile.exists()) {
      return null;
    }

    try {
      final content = await skillFile.readAsString();
      final parsed = YamlParser.parseFrontmatter(content);

      final skillId = path.basename(skillDir.path);

      return SkillModel.fromYamlAndContent(
        id: skillId,
        frontmatter: parsed.frontmatter,
        fullContent: content,
        contentWithoutFrontmatter: parsed.content,
        directoryPath: skillDir.path,
      );
    } catch (e) {
      throw Exception('Failed to load skill from ${skillDir.path}: $e');
    }
  }

  /// Save skill to directory
  Future<void> saveSkill(SkillModel skill) async {
    final skillDir = Directory(skill.directoryPath);
    final skillFile = File(path.join(skillDir.path, AppConstants.skillFileName));

    // Ensure directory exists
    if (!await skillDir.exists()) {
      await skillDir.create(recursive: true);
    }

    final content = skill.generateFullContent();
    await skillFile.writeAsString(content);
  }

  /// Create new skill
  Future<SkillModel> createSkill({
    required String id,
    required String name,
    required String description,
    String? initialContent,
  }) async {
    final skillDir = Directory(path.join(config.skillsDir.path, id));

    if (await skillDir.exists()) {
      throw Exception('Skill with id "$id" already exists');
    }

    final skill = SkillModel(
      id: id,
      name: name,
      description: description,
      fullContent: '',
      contentWithoutFrontmatter: initialContent ?? '\n# $name\n\n$description\n',
      directoryPath: skillDir.path,
    );

    await saveSkill(skill);
    return skill;
  }

  /// Delete skill
  Future<void> deleteSkill(SkillModel skill) async {
    final skillDir = Directory(skill.directoryPath);

    if (await skillDir.exists()) {
      await skillDir.delete(recursive: true);
    }
  }

  /// Import skill from external directory
  Future<SkillModel> importSkill(Directory sourceDir) async {
    final skillId = path.basename(sourceDir.path);
    final targetDir = Directory(path.join(config.skillsDir.path, skillId));

    // Check if skill already exists
    if (await targetDir.exists()) {
      throw Exception('Skill "$skillId" already exists');
    }

    // Copy directory recursively
    await _copyDirectory(sourceDir, targetDir);

    // Load and return the imported skill
    final skill = await loadSkill(targetDir);
    if (skill == null) {
      throw Exception('Failed to import skill: SKILL.md not found');
    }

    return skill;
  }

  /// Copy directory recursively
  Future<void> _copyDirectory(Directory source, Directory destination) async {
    await destination.create(recursive: true);

    await for (final entity in source.list(recursive: false)) {
      if (entity is Directory) {
        final newDirectory = Directory(
          path.join(destination.path, path.basename(entity.path)),
        );
        await _copyDirectory(entity, newDirectory);
      } else if (entity is File) {
        final newFile = File(
          path.join(destination.path, path.basename(entity.path)),
        );
        await entity.copy(newFile.path);
      }
    }
  }

  /// Validate skill
  bool validateSkill(SkillModel skill) {
    // Check required fields
    if (skill.name.isEmpty) return false;
    if (skill.description.isEmpty) return false;

    // File existence checked when loading
    return true;
  }

  /// Get skill directory path
  String getSkillDirectoryPath(String skillId) {
    return path.join(config.skillsDir.path, skillId);
  }
}
