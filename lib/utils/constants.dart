/// Application constants
class AppConstants {
  // App info
  static const String appName = 'Claude Settings Manager';
  static const String appVersion = '1.0.0';

  // File names
  static const String settingsFileName = 'settings.json';
  static const String skillFileName = 'SKILL.md';
  static const String pluginsFileName = 'installed_plugins.json';
  static const String claudeMdFileName = 'CLAUDE.md';

  // Directory names
  static const String claudeDirName = '.claude';
  static const String skillsDirName = 'skills';
  static const String agentsDirName = 'agents';
  static const String rulesDirName = 'rules';
  static const String pluginsDirName = 'plugins';
  static const String hooksDirName = 'hooks';

  // Hook event types
  static const List<String> hookEventTypes = [
    'PreToolUse',
    'PostToolUse',
    'UserPromptSubmit',
    'PermissionRequest',
    'Notification',
    'Stop',
    'SessionStart',
    'SessionEnd',
  ];

  // Agent models
  static const List<String> agentModels = [
    'opus',
    'sonnet',
    'haiku',
  ];

  // Backup settings
  static const String backupFileExtension = '.zip';
  static const String backupFilePrefix = 'claude_backup_';

  // Validation
  static const List<String> skillRequiredFields = ['name', 'description'];
  static const List<String> agentRequiredFields = ['name', 'description'];
}
