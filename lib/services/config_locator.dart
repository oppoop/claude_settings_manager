import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/claude_config.dart';

/// Service to locate and validate Claude Code configuration directory
class ConfigLocator {
  /// Find Claude configuration directory
  /// Returns null if not found
  Future<Directory?> findClaudeConfig() async {
    // Try standard location: ~/.claude
    final home = _getHomeDirectory();
    print('🏠 Home directory: $home');

    if (home == null) {
      print('❌ Home directory is null');
      return null;
    }

    final claudeDir = Directory(path.join(home, '.claude'));
    print('📁 Checking Claude directory: ${claudeDir.path}');
    print('📂 Directory exists: ${await claudeDir.exists()}');

    if (await claudeDir.exists()) {
      // Verify it's a valid Claude config directory
      final settingsFile = File(path.join(claudeDir.path, 'settings.json'));
      print('📄 Checking settings.json: ${settingsFile.path}');
      print('✓ Settings file exists: ${await settingsFile.exists()}');

      if (await settingsFile.exists()) {
        print('✅ Found valid Claude configuration');
        return claudeDir;
      } else {
        print('❌ settings.json not found');
      }
    } else {
      print('❌ .claude directory not found');
    }

    return null;
  }

  /// Load Claude configuration from directory
  Future<ClaudeConfig> loadConfig(Directory claudeDir) async {
    final config = ClaudeConfig.fromDirectory(claudeDir);

    // Ensure essential directories exist
    await _ensureDirectoriesExist(config);

    return config;
  }

  /// Get home directory based on platform
  String? _getHomeDirectory() {
    if (Platform.isMacOS || Platform.isLinux) {
      // On macOS with sandbox, HOME points to container directory
      // Try to get the real home directory
      final home = Platform.environment['HOME'];

      // If running in sandbox, extract real username from container path
      if (home != null && home.contains('/Library/Containers/')) {
        // Container path: /Users/jack/Library/Containers/com.example.app/Data
        // Extract: /Users/jack
        final parts = home.split('/');
        if (parts.length >= 3 && parts[1] == 'Users') {
          final realHome = '/Users/${parts[2]}';
          print('🔓 Detected sandbox, using real home: $realHome');
          return realHome;
        }
      }

      return home;
    } else if (Platform.isWindows) {
      return Platform.environment['USERPROFILE'];
    }
    return null;
  }

  /// Ensure essential directories exist, create if they don't
  Future<void> _ensureDirectoriesExist(ClaudeConfig config) async {
    final dirs = [
      config.rulesDir,
      config.skillsDir,
      config.agentsDir,
      config.pluginsDir,
    ];

    for (final dir in dirs) {
      if (!await dir.exists()) {
        try {
          await dir.create(recursive: true);
        } catch (e) {
          // Ignore errors, some directories might be optional
        }
      }
    }

    // Create hooks directory if it doesn't exist
    if (config.hooksDir != null && !await config.hooksDir!.exists()) {
      try {
        await config.hooksDir!.create(recursive: true);
      } catch (e) {
        // Optional directory
      }
    }
  }

  /// Validate if a directory is a valid Claude config directory
  Future<bool> isValidClaudeConfig(Directory dir) async {
    if (!await dir.exists()) {
      return false;
    }

    // Check for settings.json
    final settingsFile = File(path.join(dir.path, 'settings.json'));
    return await settingsFile.exists();
  }

  /// Get default Claude config path
  String? getDefaultClaudeConfigPath() {
    final home = _getHomeDirectory();
    if (home == null) {
      return null;
    }
    return path.join(home, '.claude');
  }
}
