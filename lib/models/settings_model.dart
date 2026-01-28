import 'package:json_annotation/json_annotation.dart';

part 'settings_model.g.dart';

/// Claude Code settings.json model
@JsonSerializable(explicitToJson: true)
class ClaudeSettings {
  final bool? includeCoAuthoredBy;
  final PermissionsConfig? permissions;
  final Map<String, bool>? enabledPlugins;
  final Map<String, List<HookConfig>>? hooks;

  ClaudeSettings({
    this.includeCoAuthoredBy,
    this.permissions,
    this.enabledPlugins,
    this.hooks,
  });

  factory ClaudeSettings.fromJson(Map<String, dynamic> json) =>
      _$ClaudeSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ClaudeSettingsToJson(this);
}

/// Permissions configuration
@JsonSerializable()
class PermissionsConfig {
  final List<String>? allow;
  final List<String>? deny;

  PermissionsConfig({
    this.allow,
    this.deny,
  });

  factory PermissionsConfig.fromJson(Map<String, dynamic> json) =>
      _$PermissionsConfigFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionsConfigToJson(this);
}

/// Hook configuration
@JsonSerializable(explicitToJson: true)
class HookConfig {
  final String? matcher;
  final List<HookAction>? hooks;

  HookConfig({
    this.matcher,
    this.hooks,
  });

  factory HookConfig.fromJson(Map<String, dynamic> json) =>
      _$HookConfigFromJson(json);

  Map<String, dynamic> toJson() => _$HookConfigToJson(this);
}

/// Hook action
@JsonSerializable()
class HookAction {
  final String type;
  final String? command;

  HookAction({
    required this.type,
    this.command,
  });

  factory HookAction.fromJson(Map<String, dynamic> json) =>
      _$HookActionFromJson(json);

  Map<String, dynamic> toJson() => _$HookActionToJson(this);
}
