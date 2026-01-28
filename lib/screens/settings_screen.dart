import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                  ],
                ),
                const SizedBox(height: 32),

              // Include Co-Authored-By
              _buildSection(
                context,
                'General',
                [
                  _buildCheckbox(
                    context,
                    'Include Co-Authored-By',
                    settings.includeCoAuthoredBy ?? false,
                    (value) {
                      // TODO: Implement save
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Permissions
              _buildSection(
                context,
                'Permissions',
                [
                  Text(
                    'Allowed Permissions: ${settings.permissions?.allow?.length ?? 0}',
                    style: MacosTheme.of(context).typography.body,
                  ),
                  const SizedBox(height: 8),
                  if (settings.permissions?.allow != null)
                    ...settings.permissions!.allow!.map((permission) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            const MacosIcon(Icons.check_circle,
                                size: 16, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                permission,
                                style: MacosTheme.of(context).typography.body,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Enabled Plugins
              _buildSection(
                context,
                'Enabled Plugins',
                [
                  if (settings.enabledPlugins != null &&
                      settings.enabledPlugins!.isNotEmpty)
                    ...settings.enabledPlugins!.entries.map((entry) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            MacosIcon(
                              entry.value ? Icons.check_circle : Icons.cancel,
                              size: 16,
                              color: entry.value ? Colors.green : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entry.key,
                                style: MacosTheme.of(context).typography.body,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Text('No plugins configured'),
                ],
              ),

              const SizedBox(height: 20),

              // Hooks
              _buildSection(
                context,
                'Hooks',
                [
                  Text(
                    'Configured Hooks: ${settings.hooks?.length ?? 0}',
                    style: MacosTheme.of(context).typography.body,
                  ),
                ],
              ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: MacosTheme.of(context).typography.headline,
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
}
