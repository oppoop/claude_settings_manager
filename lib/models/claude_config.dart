import 'dart:io';

/// Represents the Claude Code configuration structure
class ClaudeConfig {
  final Directory rootDir; // ~/.claude
  final File settingsFile; // settings.json
  final Directory rulesDir; // rules/
  final Directory skillsDir; // skills/
  final Directory agentsDir; // agents/
  final Directory pluginsDir; // plugins/
  final Directory? hooksDir; // hooks/ (optional, may not exist)

  ClaudeConfig({
    required this.rootDir,
    required this.settingsFile,
    required this.rulesDir,
    required this.skillsDir,
    required this.agentsDir,
    required this.pluginsDir,
    this.hooksDir,
  });

  factory ClaudeConfig.fromDirectory(Directory claudeDir) {
    return ClaudeConfig(
      rootDir: claudeDir,
      settingsFile: File('${claudeDir.path}/settings.json'),
      rulesDir: Directory('${claudeDir.path}/rules'),
      skillsDir: Directory('${claudeDir.path}/skills'),
      agentsDir: Directory('${claudeDir.path}/agents'),
      pluginsDir: Directory('${claudeDir.path}/plugins'),
      hooksDir: Directory('${claudeDir.path}/hooks'),
    );
  }

  /// Check if essential directories exist
  Future<bool> validate() async {
    return await rootDir.exists() && await settingsFile.exists();
  }

  /// Get all skills directories (both global and project-local)
  Future<List<Directory>> getAllSkillsDirs() async {
    final dirs = <Directory>[];

    // Global skills: ~/.claude/skills
    if (await skillsDir.exists()) {
      await for (final entity in skillsDir.list()) {
        if (entity is Directory) {
          dirs.add(entity);
        }
      }
    }

    return dirs;
  }

  /// Get all agent files (both global and project-local)
  Future<List<File>> getAllAgentFiles() async {
    final files = <File>[];

    // Global agents: ~/.claude/agents
    if (await agentsDir.exists()) {
      await for (final entity in agentsDir.list()) {
        if (entity is File && entity.path.endsWith('.md')) {
          files.add(entity);
        }
      }
    }

    return files;
  }
}
