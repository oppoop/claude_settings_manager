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

  /// Add a new hook configuration to a hook type
  Future<void> addHook(String hookType, HookConfig hookConfig) async {
    final settings = await loadSettings();
    final hooks = Map<String, List<HookConfig>>.from(
      settings.hooks?.map((key, value) => MapEntry(key, List<HookConfig>.from(value))) ?? {},
    );

    if (hooks.containsKey(hookType)) {
      hooks[hookType]!.add(hookConfig);
    } else {
      hooks[hookType] = [hookConfig];
    }

    final updatedSettings = ClaudeSettings(
      includeCoAuthoredBy: settings.includeCoAuthoredBy,
      permissions: settings.permissions,
      enabledPlugins: settings.enabledPlugins,
      hooks: hooks,
    );

    await saveSettings(updatedSettings);
  }

  /// Update an existing hook configuration
  Future<void> updateHook(String hookType, int configIndex, HookConfig newConfig) async {
    final settings = await loadSettings();
    final hooks = Map<String, List<HookConfig>>.from(
      settings.hooks?.map((key, value) => MapEntry(key, List<HookConfig>.from(value))) ?? {},
    );

    if (!hooks.containsKey(hookType) || configIndex >= (hooks[hookType]?.length ?? 0)) {
      throw Exception('Hook configuration not found');
    }

    hooks[hookType]![configIndex] = newConfig;

    final updatedSettings = ClaudeSettings(
      includeCoAuthoredBy: settings.includeCoAuthoredBy,
      permissions: settings.permissions,
      enabledPlugins: settings.enabledPlugins,
      hooks: hooks,
    );

    await saveSettings(updatedSettings);
  }

  /// Delete a hook configuration
  Future<void> deleteHook(String hookType, int configIndex) async {
    final settings = await loadSettings();
    final hooks = Map<String, List<HookConfig>>.from(
      settings.hooks?.map((key, value) => MapEntry(key, List<HookConfig>.from(value))) ?? {},
    );

    if (!hooks.containsKey(hookType) || configIndex >= (hooks[hookType]?.length ?? 0)) {
      throw Exception('Hook configuration not found');
    }

    hooks[hookType]!.removeAt(configIndex);

    // Remove the hook type entirely if no configurations remain
    if (hooks[hookType]!.isEmpty) {
      hooks.remove(hookType);
    }

    final updatedSettings = ClaudeSettings(
      includeCoAuthoredBy: settings.includeCoAuthoredBy,
      permissions: settings.permissions,
      enabledPlugins: settings.enabledPlugins,
      hooks: hooks.isEmpty ? null : hooks,
    );

    await saveSettings(updatedSettings);
  }

  /// Update includeCoAuthoredBy setting
  Future<void> updateIncludeCoAuthoredBy(bool value) async {
    final settings = await loadSettings();
    final updatedSettings = ClaudeSettings(
      includeCoAuthoredBy: value,
      permissions: settings.permissions,
      enabledPlugins: settings.enabledPlugins,
      hooks: settings.hooks,
    );
    await saveSettings(updatedSettings);
  }

  /// Add permission to deny list
  Future<void> addDenyPermission(String permission) async {
    final settings = await loadSettings();
    final permissions = settings.permissions ?? PermissionsConfig();
    final denyList = List<String>.from(permissions.deny ?? []);

    if (!denyList.contains(permission)) {
      denyList.add(permission);

      final updatedSettings = ClaudeSettings(
        includeCoAuthoredBy: settings.includeCoAuthoredBy,
        permissions: PermissionsConfig(
          allow: permissions.allow,
          deny: denyList,
        ),
        enabledPlugins: settings.enabledPlugins,
        hooks: settings.hooks,
      );

      await saveSettings(updatedSettings);
    }
  }

  /// Remove permission from deny list
  Future<void> removeDenyPermission(String permission) async {
    final settings = await loadSettings();
    final permissions = settings.permissions;

    if (permissions == null || permissions.deny == null) {
      return;
    }

    final denyList = List<String>.from(permissions.deny!);
    denyList.remove(permission);

    final updatedSettings = ClaudeSettings(
      includeCoAuthoredBy: settings.includeCoAuthoredBy,
      permissions: PermissionsConfig(
        allow: permissions.allow,
        deny: denyList.isEmpty ? null : denyList,
      ),
      enabledPlugins: settings.enabledPlugins,
      hooks: settings.hooks,
    );

    await saveSettings(updatedSettings);
  }

  /// Add new plugin entry
  Future<void> addPlugin(String pluginName, bool enabled) async {
    final settings = await loadSettings();
    final plugins = Map<String, bool>.from(settings.enabledPlugins ?? {});
    plugins[pluginName] = enabled;

    final updatedSettings = ClaudeSettings(
      includeCoAuthoredBy: settings.includeCoAuthoredBy,
      permissions: settings.permissions,
      enabledPlugins: plugins,
      hooks: settings.hooks,
    );

    await saveSettings(updatedSettings);
  }

  /// Remove plugin entry
  Future<void> removePlugin(String pluginName) async {
    final settings = await loadSettings();
    final plugins = Map<String, bool>.from(settings.enabledPlugins ?? {});
    plugins.remove(pluginName);

    final updatedSettings = ClaudeSettings(
      includeCoAuthoredBy: settings.includeCoAuthoredBy,
      permissions: settings.permissions,
      enabledPlugins: plugins.isEmpty ? null : plugins,
      hooks: settings.hooks,
    );

    await saveSettings(updatedSettings);
  }

  /// Format JSON string with proper indentation.
  /// Throws [FormatException] if jsonString is not valid JSON.
  static String formatJson(String jsonString) {
    try {
      final parsed = jsonDecode(jsonString);
      final encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(parsed);
    } on FormatException catch (e) {
      throw FormatException('Invalid JSON: ${e.message}');
    }
  }
}
