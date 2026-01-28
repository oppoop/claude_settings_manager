import 'dart:convert';
import '../models/settings_model.dart';
import '../models/claude_config.dart';

/// Service for reading and writing Claude settings.json
class SettingsService {
  final ClaudeConfig config;

  SettingsService(this.config);

  /// Load settings from settings.json
  Future<ClaudeSettings> loadSettings() async {
    if (!await config.settingsFile.exists()) {
      // Return default settings if file doesn't exist
      return ClaudeSettings();
    }

    try {
      final content = await config.settingsFile.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      return ClaudeSettings.fromJson(json);
    } catch (e) {
      throw Exception('Failed to parse settings.json: $e');
    }
  }

  /// Save settings to settings.json
  Future<void> saveSettings(ClaudeSettings settings) async {
    try {
      final json = settings.toJson();
      final encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(json);

      await config.settingsFile.writeAsString(prettyJson);
    } catch (e) {
      throw Exception('Failed to save settings.json: $e');
    }
  }

  /// Add permission to allow list
  Future<void> addPermission(String permission) async {
    final settings = await loadSettings();
    final permissions = settings.permissions ?? PermissionsConfig();
    final allowList = List<String>.from(permissions.allow ?? []);

    if (!allowList.contains(permission)) {
      allowList.add(permission);

      final updatedSettings = ClaudeSettings(
        includeCoAuthoredBy: settings.includeCoAuthoredBy,
        permissions: PermissionsConfig(
          allow: allowList,
          deny: permissions.deny,
        ),
        enabledPlugins: settings.enabledPlugins,
        hooks: settings.hooks,
      );

      await saveSettings(updatedSettings);
    }
  }

  /// Remove permission from allow list
  Future<void> removePermission(String permission) async {
    final settings = await loadSettings();
    final permissions = settings.permissions;

    if (permissions == null || permissions.allow == null) {
      return;
    }

    final allowList = List<String>.from(permissions.allow!);
    allowList.remove(permission);

    final updatedSettings = ClaudeSettings(
      includeCoAuthoredBy: settings.includeCoAuthoredBy,
      permissions: PermissionsConfig(
        allow: allowList,
        deny: permissions.deny,
      ),
      enabledPlugins: settings.enabledPlugins,
      hooks: settings.hooks,
    );

    await saveSettings(updatedSettings);
  }

  /// Enable plugin
  Future<void> enablePlugin(String pluginName) async {
    final settings = await loadSettings();
    final plugins = Map<String, bool>.from(settings.enabledPlugins ?? {});
    plugins[pluginName] = true;

    final updatedSettings = ClaudeSettings(
      includeCoAuthoredBy: settings.includeCoAuthoredBy,
      permissions: settings.permissions,
      enabledPlugins: plugins,
      hooks: settings.hooks,
    );

    await saveSettings(updatedSettings);
  }

  /// Disable plugin
  Future<void> disablePlugin(String pluginName) async {
    final settings = await loadSettings();
    final plugins = Map<String, bool>.from(settings.enabledPlugins ?? {});
    plugins[pluginName] = false;

    final updatedSettings = ClaudeSettings(
      includeCoAuthoredBy: settings.includeCoAuthoredBy,
      permissions: settings.permissions,
      enabledPlugins: plugins,
      hooks: settings.hooks,
    );

    await saveSettings(updatedSettings);
  }

  /// Get raw JSON string (for advanced editing)
  Future<String> getRawJson() async {
    if (!await config.settingsFile.exists()) {
      return '{}';
    }
    return await config.settingsFile.readAsString();
  }

  /// Save raw JSON string (after manual editing)
  Future<void> saveRawJson(String jsonString) async {
    // Validate JSON first
    try {
      jsonDecode(jsonString);
    } catch (e) {
      throw Exception('Invalid JSON format: $e');
    }

    await config.settingsFile.writeAsString(jsonString);
  }
}
