import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/edit_raw_json_dialog.dart';
import '../widgets/add_permission_dialog.dart';
import '../widgets/add_plugin_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;

  Future<void> _showSuccessNotification(String message) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showErrorDialog(String message) async {
    if (!mounted) return;
    showMacosAlertDialog(
      context: context,
      builder: (context) => MacosAlertDialog(
        appIcon: const FlutterLogo(size: 56),
        title: const Text('Error'),
        message: Text(message),
        primaryButton: PushButton(
          controlSize: ControlSize.large,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ),
    );
  }

  Future<void> _handleCoAuthoredByChange(bool value) async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final service = appState.settingsService;

    if (service == null) {
      _showErrorDialog('Settings service not initialized');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await service.updateIncludeCoAuthoredBy(value);
      await appState.loadSettings();
      _showSuccessNotification('Setting updated');
    } catch (e) {
      _showErrorDialog('Failed to update setting: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRefresh() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await appState.loadSettings();
      _showSuccessNotification('Settings refreshed');
    } catch (e) {
      _showErrorDialog('Failed to refresh: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleEditJson() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final service = appState.settingsService;

    if (service == null) {
      _showErrorDialog('Settings service not initialized');
      return;
    }

    try {
      final rawJson = await service.getRawJson();

      if (!mounted) return;
      final result = await showMacosSheet<String?>(
        context: context,
        builder: (context) => EditRawJsonDialog(initialJson: rawJson),
      );

      if (result != null) {
        setState(() => _isLoading = true);
        await service.saveRawJson(result);
        await appState.loadSettings();
        _showSuccessNotification('Settings saved');
      }
    } catch (e) {
      _showErrorDialog('Failed to save: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAddPermission() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final service = appState.settingsService;

    if (service == null) {
      _showErrorDialog('Settings service not initialized');
      return;
    }

    final result = await showMacosSheet<PermissionDialogResult?>(
      context: context,
      builder: (context) => const AddPermissionDialog(),
    );

    if (result == null) return;

    setState(() => _isLoading = true);
    try {
      if (result.isAllowList) {
        await service.addPermission(result.permission);
      } else {
        await service.addDenyPermission(result.permission);
      }
      await appState.loadSettings();
      _showSuccessNotification('Permission added');
    } catch (e) {
      _showErrorDialog('Failed to add permission: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRemovePermission(String permission, bool isAllowList) async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final service = appState.settingsService;

    if (service == null) {
      _showErrorDialog('Settings service not initialized');
      return;
    }

    final confirm = await showMacosAlertDialog<bool>(
      context: context,
      builder: (context) => MacosAlertDialog(
        appIcon: const FlutterLogo(size: 56),
        title: const Text('Remove Permission'),
        message: Text('Remove "$permission" from ${isAllowList ? "allow" : "deny"} list?'),
        primaryButton: PushButton(
          controlSize: ControlSize.large,
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Remove'),
        ),
        secondaryButton: PushButton(
          controlSize: ControlSize.large,
          secondary: true,
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      if (isAllowList) {
        await service.removePermission(permission);
      } else {
        await service.removeDenyPermission(permission);
      }
      await appState.loadSettings();
      _showSuccessNotification('Permission removed');
    } catch (e) {
      _showErrorDialog('Failed to remove permission: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAddPlugin() async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final service = appState.settingsService;

    if (service == null) {
      _showErrorDialog('Settings service not initialized');
      return;
    }

    final result = await showMacosSheet<PluginDialogResult?>(
      context: context,
      builder: (context) => const AddPluginDialog(),
    );

    if (result == null) return;

    setState(() => _isLoading = true);
    try {
      await service.addPlugin(result.name, result.enabled);
      await appState.loadSettings();
      _showSuccessNotification('Plugin added');
    } catch (e) {
      _showErrorDialog('Failed to add plugin: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleTogglePlugin(String pluginName, bool currentState) async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final service = appState.settingsService;

    if (service == null) {
      _showErrorDialog('Settings service not initialized');
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (currentState) {
        await service.disablePlugin(pluginName);
      } else {
        await service.enablePlugin(pluginName);
      }
      await appState.loadSettings();
      _showSuccessNotification('Plugin ${currentState ? "disabled" : "enabled"}');
    } catch (e) {
      _showErrorDialog('Failed to toggle plugin: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRemovePlugin(String pluginName) async {
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    final service = appState.settingsService;

    if (service == null) {
      _showErrorDialog('Settings service not initialized');
      return;
    }

    final confirm = await showMacosAlertDialog<bool>(
      context: context,
      builder: (context) => MacosAlertDialog(
        appIcon: const FlutterLogo(size: 56),
        title: const Text('Remove Plugin'),
        message: Text('Remove plugin "$pluginName"?'),
        primaryButton: PushButton(
          controlSize: ControlSize.large,
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Remove'),
        ),
        secondaryButton: PushButton(
          controlSize: ControlSize.large,
          secondary: true,
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await service.removePlugin(pluginName);
      await appState.loadSettings();
      _showSuccessNotification('Plugin removed');
    } catch (e) {
      _showErrorDialog('Failed to remove plugin: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final settings = appState.settings;

        if (settings == null) {
          return const Center(
            child: Text('No settings loaded'),
          );
        }

        return Stack(
          children: [
            Container(
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
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient(context),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'Settings',
                          style: MacosTheme.of(context).typography.largeTitle,
                        ),
                        const Spacer(),
                        PushButton(
                          controlSize: ControlSize.regular,
                          secondary: true,
                          onPressed: _handleEditJson,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MacosIcon(Icons.code, size: 14),
                              SizedBox(width: 6),
                              Text('Edit JSON'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        MacosIconButton(
                          icon: const MacosIcon(Icons.refresh),
                          onPressed: _handleRefresh,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // General section
                    _buildSection(
                      context,
                      'General',
                      null,
                      [
                        _buildCheckbox(
                          context,
                          'Include Co-Authored-By',
                          settings.includeCoAuthoredBy ?? false,
                          _handleCoAuthoredByChange,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Permissions section
                    _buildSection(
                      context,
                      'Permissions',
                      MacosIconButton(
                        icon: MacosIcon(
                          Icons.add,
                          color: MacosTheme.of(context).primaryColor,
                        ),
                        onPressed: _handleAddPermission,
                      ),
                      [
                        // Allow list
                        Row(
                          children: [
                            const MacosIcon(Icons.check_circle, size: 16, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(
                              'Allow (${settings.permissions?.allow?.length ?? 0})',
                              style: MacosTheme.of(context).typography.headline.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (settings.permissions?.allow != null && settings.permissions!.allow!.isNotEmpty)
                          ...settings.permissions!.allow!.map((permission) =>
                            _buildPermissionItem(context, permission, true),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Text(
                              'No permissions in allow list',
                              style: MacosTheme.of(context).typography.caption1,
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Deny list
                        Row(
                          children: [
                            const MacosIcon(Icons.cancel, size: 16, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              'Deny (${settings.permissions?.deny?.length ?? 0})',
                              style: MacosTheme.of(context).typography.headline.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (settings.permissions?.deny != null && settings.permissions!.deny!.isNotEmpty)
                          ...settings.permissions!.deny!.map((permission) =>
                            _buildPermissionItem(context, permission, false),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Text(
                              'No permissions in deny list',
                              style: MacosTheme.of(context).typography.caption1,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Plugins section
                    _buildSection(
                      context,
                      'Plugins',
                      MacosIconButton(
                        icon: MacosIcon(
                          Icons.add,
                          color: MacosTheme.of(context).primaryColor,
                        ),
                        onPressed: _handleAddPlugin,
                      ),
                      [
                        if (settings.enabledPlugins != null && settings.enabledPlugins!.isNotEmpty)
                          ...settings.enabledPlugins!.entries.map((entry) =>
                            _buildPluginItem(context, entry.key, entry.value),
                          )
                        else
                          const Text('No plugins configured'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Hooks section (read-only info)
                    _buildSection(
                      context,
                      'Hooks',
                      null,
                      [
                        Text(
                          'Configured Hooks: ${settings.hooks?.length ?? 0}',
                          style: MacosTheme.of(context).typography.body,
                        ),
                        if (settings.hooks != null && settings.hooks!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Manage hooks in the Hooks screen',
                              style: MacosTheme.of(context).typography.caption1,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Loading overlay
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.1),
                child: const Center(
                  child: ProgressCircle(),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget? trailing, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Text(
                title,
                style: MacosTheme.of(context).typography.headline,
              ),
              const Spacer(),
              if (trailing != null) trailing,
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.cardDecoration(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(
    BuildContext context,
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        MacosCheckbox(
          value: value,
          onChanged: (newValue) => onChanged(newValue),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: MacosTheme.of(context).typography.body,
        ),
      ],
    );
  }

  Widget _buildPermissionItem(BuildContext context, String permission, bool isAllowList) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 24),
      child: Row(
        children: [
          MacosIcon(
            isAllowList ? Icons.check_circle : Icons.cancel,
            size: 14,
            color: isAllowList ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              permission,
              style: MacosTheme.of(context).typography.body.copyWith(
                    fontFamily: 'monospace',
                  ),
            ),
          ),
          MacosIconButton(
            icon: const MacosIcon(
              Icons.remove_circle_outline,
              size: 16,
              color: Colors.red,
            ),
            onPressed: () => _handleRemovePermission(permission, isAllowList),
          ),
        ],
      ),
    );
  }

  Widget _buildPluginItem(BuildContext context, String name, bool enabled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          MacosSwitch(
            value: enabled,
            onChanged: (_) => _handleTogglePlugin(name, enabled),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: MacosTheme.of(context).typography.body,
            ),
          ),
          MacosIconButton(
            icon: const MacosIcon(
              Icons.remove_circle_outline,
              size: 16,
              color: Colors.red,
            ),
            onPressed: () => _handleRemovePlugin(name),
          ),
        ],
      ),
    );
  }
}
