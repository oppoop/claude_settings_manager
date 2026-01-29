import 'dart:io';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/app_state_provider.dart';
import '../theme/app_theme.dart';
import 'settings_screen.dart';
import 'skills_screen.dart';
import 'agents_screen.dart';
import 'hooks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize on first launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppStateProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        if (appState.isLoading) {
          return MacosScaffold(
            children: [
              ContentArea(
                builder: (context, scrollController) {
                  return const Center(
                    child: ProgressCircle(),
                  );
                },
              ),
            ],
          );
        }

        if (appState.error != null && !appState.isConfigured) {
          return MacosScaffold(
            children: [
              ContentArea(
                builder: (context, scrollController) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.folder_off,
                            size: 64,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Claude Configuration Not Found',
                            style: MacosTheme.of(context).typography.largeTitle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            appState.error!,
                            style: MacosTheme.of(context).typography.body,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PushButton(
                                controlSize: ControlSize.large,
                                onPressed: () async {
                                  // Manual directory selection
                                  String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
                                    dialogTitle: 'Select .claude directory',
                                  );

                                  if (selectedDirectory != null) {
                                    final dir = Directory(selectedDirectory);
                                    await appState.setConfigDirectory(dir);
                                  }
                                },
                                child: const Text('Choose Directory'),
                              ),
                              const SizedBox(width: 16),
                              PushButton(
                                controlSize: ControlSize.large,
                                secondary: true,
                                onPressed: () {
                                  appState.initialize();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }

        return MacosScaffold(
          children: [
            ResizablePane(
              minSize: 180,
              startSize: 200,
              windowBreakpoint: 700,
              resizableSide: ResizableSide.right,
              builder: (context, scrollController) {
                return SidebarItems(
                  currentIndex: appState.selectedIndex,
                  onChanged: (index) {
                    appState.setSelectedIndex(index);
                  },
                  items: const [
                    SidebarItem(
                      leading: MacosIcon(Icons.settings),
                      label: Text('Settings'),
                    ),
                    SidebarItem(
                      leading: MacosIcon(Icons.extension),
                      label: Text('Skills'),
                    ),
                    SidebarItem(
                      leading: MacosIcon(Icons.smart_toy),
                      label: Text('Agents'),
                    ),
                    SidebarItem(
                      leading: MacosIcon(Icons.webhook),
                      label: Text('Hooks'),
                    ),
                    SidebarItem(
                      leading: MacosIcon(Icons.backup),
                      label: Text('Backup'),
                    ),
                    SidebarItem(
                      leading: MacosIcon(Icons.download),
                      label: Text('Import'),
                    ),
                  ],
                );
              },
            ),
            ContentArea(
              builder: (context, scrollController) {
                return _buildContent(appState.selectedIndex);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent(int index) {
    switch (index) {
      case 0:
        return const SettingsScreen();
      case 1:
        return const SkillsScreen();
      case 2:
        return const AgentsScreen();
      case 3:
        return const HooksScreen();
      case 4:
        return _buildPlaceholder('Backup', 'Backup & restore coming soon');
      case 5:
        return _buildPlaceholder('Import', 'Import configurations coming soon');
      default:
        return _buildPlaceholder('Unknown', 'Page not found');
    }
  }

  Widget _buildPlaceholder(String title, String message) {
    IconData icon;
    switch (title) {
      case 'Hooks':
        icon = Icons.webhook;
        break;
      case 'Backup':
        icon = Icons.backup;
        break;
      case 'Import':
        icon = Icons.download;
        break;
      default:
        icon = Icons.info;
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient(context),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: MacosTheme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 80,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              title,
              style: MacosTheme.of(context).typography.largeTitle,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: MacosTheme.of(context).dividerColor,
                ),
              ),
              child: Text(
                message,
                style: MacosTheme.of(context).typography.headline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
