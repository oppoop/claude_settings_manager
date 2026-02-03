import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../models/settings_model.dart';
import '../theme/app_theme.dart';
import '../widgets/edit_hook_dialog.dart';
import '../widgets/create_hook_dialog.dart';
import '../widgets/confirmation_dialog.dart';

class HooksScreen extends StatefulWidget {
  const HooksScreen({super.key});

  @override
  State<HooksScreen> createState() => _HooksScreenState();
}

class _HooksScreenState extends State<HooksScreen> {
  String? _selectedHookType;

  Future<void> _handleCreateHook() async {
    final result = await showMacosSheet<Map<String, dynamic>?>(
      context: context,
      builder: (context) => CreateHookDialog(
        initialHookType: _selectedHookType,
      ),
    );

    if (result != null && mounted) {
      final hookType = result['hookType'] as String;
      final config = result['config'] as HookConfig;

      try {
        final appState = Provider.of<AppStateProvider>(context, listen: false);
        final settingsService = appState.settingsService;
        if (settingsService == null) {
          _showErrorDialog('Settings service not initialized');
          return;
        }
        await settingsService.addHook(hookType, config);
        await appState.loadSettings();

        setState(() {
          _selectedHookType = hookType;
        });

        if (mounted) {
          _showSuccessNotification('Hook created successfully');
        }
      } catch (e) {
        if (mounted) {
          _showErrorDialog('Failed to create hook: $e');
        }
      }
    }
  }

  Future<void> _handleEditHook(String hookType, int index, HookConfig config) async {
    final result = await showMacosSheet<HookConfig?>(
      context: context,
      builder: (context) => EditHookDialog(
        hookType: hookType,
        configIndex: index,
        config: config,
      ),
    );

    if (result != null && mounted) {
      try {
        final appState = Provider.of<AppStateProvider>(context, listen: false);
        final settingsService = appState.settingsService;
        if (settingsService == null) {
          _showErrorDialog('Settings service not initialized');
          return;
        }
        await settingsService.updateHook(hookType, index, result);
        await appState.loadSettings();

        if (mounted) {
          _showSuccessNotification('Hook updated successfully');
        }
      } catch (e) {
        if (mounted) {
          _showErrorDialog('Failed to update hook: $e');
        }
      }
    }
  }

  Future<void> _handleDeleteHook(String hookType, int index) async {
    final confirmed = await showDeleteConfirmation(
      context: context,
      itemName: 'Configuration ${index + 1}',
      itemType: 'hook configuration',
    );

    if (confirmed && mounted) {
      try {
        final appState = Provider.of<AppStateProvider>(context, listen: false);
        final settingsService = appState.settingsService;
        if (settingsService == null) {
          _showErrorDialog('Settings service not initialized');
          return;
        }
        await settingsService.deleteHook(hookType, index);
        await appState.loadSettings();

        if (mounted) {
          _showSuccessNotification('Hook deleted successfully');
        }
      } catch (e) {
        if (mounted) {
          _showErrorDialog('Failed to delete hook: $e');
        }
      }
    }
  }

  void _showSuccessNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorDialog(String message) {
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

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final settings = appState.settings;
        final hooks = settings?.hooks ?? {};

        // Get all hook types (both existing and common)
        final allHookTypes = {...commonHookTypes, ...hooks.keys}.toList()
          ..sort();

        return Row(
          children: [
            // Hook Types List
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
                          Icons.webhook,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Hooks',
                          style: MacosTheme.of(context).typography.headline.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const Spacer(),
                        MacosIconButton(
                          icon: const MacosIcon(Icons.add, color: Colors.white),
                          onPressed: _handleCreateHook,
                        ),
                        MacosIconButton(
                          icon: const MacosIcon(Icons.refresh, color: Colors.white),
                          onPressed: () {
                            appState.loadSettings();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: allHookTypes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.webhook_outlined,
                                  size: 48,
                                  color: MacosTheme.of(context).typography.caption1.color,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No hooks configured',
                                  style: MacosTheme.of(context).typography.headline,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: allHookTypes.length,
                            itemBuilder: (context, index) {
                              final hookType = allHookTypes[index];
                              final isSelected = _selectedHookType == hookType;
                              final hookConfigs = hooks[hookType] ?? [];
                              final hasHooks = hookConfigs.isNotEmpty;

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
                                      color: hasHooks
                                          ? MacosTheme.of(context).primaryColor.withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: MacosIcon(
                                      hasHooks ? Icons.webhook : Icons.webhook_outlined,
                                      color: hasHooks
                                          ? MacosTheme.of(context).primaryColor
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    hookType,
                                    style: MacosTheme.of(context).typography.body.copyWith(
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                        ),
                                  ),
                                  subtitle: Text(
                                    hasHooks
                                        ? '${hookConfigs.length} config(s)'
                                        : 'Not configured',
                                    style: MacosTheme.of(context).typography.caption1,
                                  ),
                                  onClick: () {
                                    setState(() {
                                      _selectedHookType = hookType;
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

            // Hook Detail
            Expanded(
              child: _selectedHookType == null
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
                              Icons.webhook,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Select a hook type to view details',
                            style: MacosTheme.of(context).typography.headline,
                          ),
                        ],
                      ),
                    )
                  : _buildHookDetail(
                      _selectedHookType!,
                      hooks[_selectedHookType] ?? [],
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHookDetail(String hookType, List<HookConfig> configs) {
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
                    Icons.webhook,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    hookType,
                    style: MacosTheme.of(context).typography.largeTitle,
                  ),
                ),
                PushButton(
                  controlSize: ControlSize.regular,
                  onPressed: _handleCreateHook,
                  child: const Text('Add Configuration'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            if (configs.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: AppTheme.cardDecoration(context),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.webhook_outlined,
                        size: 48,
                        color: MacosTheme.of(context).typography.caption1.color,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hooks configured for this event',
                        style: MacosTheme.of(context).typography.headline,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hooks allow you to run custom commands in response to events.',
                        style: MacosTheme.of(context).typography.caption1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      PushButton(
                        controlSize: ControlSize.regular,
                        onPressed: _handleCreateHook,
                        child: const Text('Create Hook'),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...configs.asMap().entries.map((entry) {
                final index = entry.key;
                final config = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildHookConfigCard(hookType, index, config),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildHookConfigCard(String hookType, int index, HookConfig config) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.elevatedCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Configuration ${index + 1}',
                style: MacosTheme.of(context).typography.headline.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                '${config.hooks?.length ?? 0} action(s)',
                style: MacosTheme.of(context).typography.caption1,
              ),
              const SizedBox(width: 12),
              MacosIconButton(
                icon: MacosIcon(
                  Icons.edit,
                  color: MacosTheme.of(context).primaryColor,
                  size: 18,
                ),
                onPressed: () => _handleEditHook(hookType, index, config),
              ),
              MacosIconButton(
                icon: const MacosIcon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 18,
                ),
                onPressed: () => _handleDeleteHook(hookType, index),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Matcher
          if (config.matcher != null) ...[
            Text(
              'Matcher Pattern',
              style: MacosTheme.of(context).typography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MacosTheme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: MacosTheme.of(context).dividerColor,
                ),
              ),
              child: SelectableText(
                config.matcher!,
                style: MacosTheme.of(context).typography.body.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Actions
          if (config.hooks != null && config.hooks!.isNotEmpty) ...[
            Text(
              'Actions',
              style: MacosTheme.of(context).typography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            ...config.hooks!.map((action) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: MacosTheme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: MacosTheme.of(context).dividerColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: MacosTheme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              action.type,
                              style: MacosTheme.of(context).typography.caption1.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: MacosTheme.of(context).primaryColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      if (action.command != null) ...[
                        const SizedBox(height: 8),
                        SelectableText(
                          action.command!,
                          style: MacosTheme.of(context).typography.caption1.copyWith(
                                fontFamily: 'monospace',
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
