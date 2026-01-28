import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/claude_config.dart';
import '../models/settings_model.dart';
import '../models/skill_model.dart';
import '../models/agent_model.dart';
import '../services/config_locator.dart';
import '../services/settings_service.dart';
import '../services/skill_service.dart';
import '../services/agent_service.dart';

/// Main application state provider
class AppStateProvider with ChangeNotifier {
  // Services
  final ConfigLocator _configLocator = ConfigLocator();
  SettingsService? _settingsService;
  SkillService? _skillService;
  AgentService? _agentService;

  // State
  ClaudeConfig? _config;
  ClaudeSettings? _settings;
  List<SkillModel> _skills = [];
  List<AgentModel> _agents = [];
  bool _isLoading = false;
  String? _error;

  // Currently selected navigation item
  int _selectedIndex = 0;

  // Getters
  ClaudeConfig? get config => _config;
  ClaudeSettings? get settings => _settings;
  List<SkillModel> get skills => _skills;
  List<AgentModel> get agents => _agents;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedIndex => _selectedIndex;
  bool get isConfigured => _config != null;

  /// Initialize - find and load Claude configuration
  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Find Claude config directory
      final claudeDir = await _configLocator.findClaudeConfig();

      if (claudeDir == null) {
        final defaultPath = _configLocator.getDefaultClaudeConfigPath();
        _error = 'Claude configuration directory not found.\n'
            'Expected location: $defaultPath\n'
            'Please ensure Claude Code is installed.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Load configuration
      _config = await _configLocator.loadConfig(claudeDir);

      // Initialize services
      _settingsService = SettingsService(_config!);
      _skillService = SkillService(_config!);
      _agentService = AgentService(_config!);

      // Load initial data
      await loadAll();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all data (settings, skills, agents)
  Future<void> loadAll() async {
    try {
      await Future.wait([
        loadSettings(),
        loadSkills(),
        loadAgents(),
      ]);
    } catch (e) {
      _error = 'Failed to load data: $e';
      notifyListeners();
    }
  }

  /// Load settings
  Future<void> loadSettings() async {
    if (_settingsService == null) return;

    try {
      _settings = await _settingsService!.loadSettings();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load settings: $e';
      notifyListeners();
    }
  }

  /// Load skills
  Future<void> loadSkills() async {
    if (_skillService == null) return;

    try {
      _skills = await _skillService!.loadAllSkills();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load skills: $e';
      notifyListeners();
    }
  }

  /// Load agents
  Future<void> loadAgents() async {
    if (_agentService == null) return;

    try {
      _agents = await _agentService!.loadAllAgents();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load agents: $e';
      notifyListeners();
    }
  }

  /// Set selected navigation index
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  /// Manually set config directory
  Future<void> setConfigDirectory(Directory dir) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _config = await _configLocator.loadConfig(dir);

      // Reinitialize services
      _settingsService = SettingsService(_config!);
      _skillService = SkillService(_config!);
      _agentService = AgentService(_config!);

      // Reload data
      await loadAll();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load configuration: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get services for direct access
  SettingsService? get settingsService => _settingsService;
  SkillService? get skillService => _skillService;
  AgentService? get agentService => _agentService;
}
