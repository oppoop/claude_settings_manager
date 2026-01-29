import 'dart:io';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/app_state_provider.dart';
import '../models/agent_model.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/edit_agent_dialog.dart';
import '../widgets/create_agent_dialog.dart';
import '../theme/app_theme.dart';

class AgentsScreen extends StatefulWidget {
  const AgentsScreen({super.key});

  @override
  State<AgentsScreen> createState() => _AgentsScreenState();
}

class _AgentsScreenState extends State<AgentsScreen> {
  AgentModel? _selectedAgent;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final agents = appState.agents;

        return Row(
          children: [
            // Agents List
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
                          Icons.smart_toy,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Agents (${agents.length})',
                          style: MacosTheme.of(context).typography.headline.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const Spacer(),
                        MacosIconButton(
                          icon: const MacosIcon(Icons.add, color: Colors.white),
                          onPressed: _handleCreateAgent,
                        ),
                        const SizedBox(width: 4),
                        MacosIconButton(
                          icon: const MacosIcon(Icons.refresh, color: Colors.white),
                          onPressed: () {
                            appState.loadAgents();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: agents.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.smart_toy_outlined,
                                  size: 48,
                                  color: MacosTheme.of(context).typography.caption1.color,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No agents found',
                                  style: MacosTheme.of(context).typography.headline,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: agents.length,
                            itemBuilder: (context, index) {
                              final agent = agents[index];
                              final isSelected = _selectedAgent?.name == agent.name;

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
                                      color: MacosTheme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: MacosIcon(
                                      Icons.smart_toy,
                                      color: MacosTheme.of(context).primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    agent.name,
                                    style: MacosTheme.of(context).typography.body.copyWith(
                                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                        ),
                                  ),
                                  subtitle: Text(
                                    agent.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: MacosTheme.of(context).typography.caption1,
                                  ),
                                  onClick: () {
                                    setState(() {
                                      _selectedAgent = agent;
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

            // Agent Detail
            Expanded(
              child: _selectedAgent == null
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
                              Icons.smart_toy,
                              size: 64,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Select an agent to view details',
                            style: MacosTheme.of(context).typography.headline,
                          ),
                        ],
                      ),
                    )
                  : _buildAgentDetail(_selectedAgent!),
            ),
          ],
        );
      },
    );
  }

  /// Handle agent import
  Future<void> _handleImportAgent() async {
    try {
      // Pick a file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select Agent File',
        type: FileType.custom,
        allowedExtensions: ['md'],
      );

      if (result == null || result.files.single.path == null) return;

      final sourceFile = File(result.files.single.path!);

      if (!await sourceFile.exists()) {
        throw Exception('Selected file does not exist');
      }

      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final importedAgent = await appState.agentService?.importAgent(sourceFile);

      // Reload agents
      await appState.loadAgents();

      // Select the imported agent
      if (importedAgent != null) {
        setState(() {
          _selectedAgent = appState.agents.firstWhere(
            (a) => a.id == importedAgent.id,
            orElse: () => importedAgent,
          );
        });
      }

      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Success'),
            message: Text('Agent "${importedAgent?.name}" has been imported.'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Error'),
            message: Text('Failed to import agent: $e'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    }
  }

  /// Handle agent creation
  Future<void> _handleCreateAgent() async {
    final result = await showMacosSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateAgentDialog(),
    );

    if (result == null) return;

    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      final newAgent = await appState.agentService?.createAgent(
        id: result['id'],
        name: result['name'],
        description: result['description'],
        tools: result['tools'] as List<String>?,
        model: result['model'] as String?,
        initialContent: result['content'],
      );

      // Reload agents
      await appState.loadAgents();

      // Select the newly created agent
      if (newAgent != null) {
        setState(() {
          _selectedAgent = appState.agents.firstWhere(
            (a) => a.id == newAgent.id,
            orElse: () => newAgent,
          );
        });
      }

      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Success'),
            message: Text('Agent "${result['name']}" has been created.'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Error'),
            message: Text('Failed to create agent: $e'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    }
  }

  /// Handle agent editing
  Future<void> _handleEditAgent(AgentModel agent) async {
    final updatedAgent = await showMacosSheet<AgentModel>(
      context: context,
      builder: (context) => EditAgentDialog(agent: agent),
    );

    if (updatedAgent == null) return;

    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      await appState.agentService?.saveAgent(updatedAgent);

      // Reload agents
      await appState.loadAgents();

      // Update selection to the updated agent
      setState(() {
        _selectedAgent = appState.agents.firstWhere(
          (a) => a.id == agent.id,
          orElse: () => agent,
        );
      });

      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Success'),
            message: Text('Agent "${updatedAgent.name}" has been updated.'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Error'),
            message: Text('Failed to update agent: $e'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    }
  }

  /// Handle agent deletion with confirmation
  Future<void> _handleDeleteAgent(AgentModel agent) async {
    final confirmed = await showDeleteConfirmation(
      context: context,
      itemName: agent.name,
      itemType: 'Agent',
    );

    if (!confirmed) return;

    try {
      final appState = Provider.of<AppStateProvider>(context, listen: false);
      await appState.agentService?.deleteAgent(agent);

      // Clear selection
      setState(() {
        _selectedAgent = null;
      });

      // Reload agents
      await appState.loadAgents();

      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Success'),
            message: Text('Agent "${agent.name}" has been deleted.'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showMacosAlertDialog(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: const FlutterLogo(size: 56),
            title: const Text('Error'),
            message: Text('Failed to delete agent: $e'),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
        );
      }
    }
  }

  Widget _buildAgentDetail(AgentModel agent) {
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
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    agent.name,
                    style: MacosTheme.of(context).typography.largeTitle,
                  ),
                ),
                PushButton(
                  controlSize: ControlSize.regular,
                  onPressed: () => _handleImportAgent(),
                  child: const Row(
                    children: [
                      Icon(Icons.download, size: 16),
                      SizedBox(width: 6),
                      Text('Import'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                PushButton(
                  controlSize: ControlSize.regular,
                  onPressed: () => _handleEditAgent(agent),
                  child: const Row(
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 6),
                      Text('Edit'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                PushButton(
                  controlSize: ControlSize.regular,
                  secondary: true,
                  onPressed: () => _handleDeleteAgent(agent),
                  child: const Row(
                    children: [
                      Icon(Icons.delete, size: 16),
                      SizedBox(width: 6),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: AppTheme.cardDecoration(context),
              child: Text(
                agent.description,
                style: MacosTheme.of(context).typography.body,
              ),
            ),
            const SizedBox(height: 20),

            // Agent properties
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.cardDecoration(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPropertyRow('Model', agent.model ?? 'default'),
                  if (agent.tools != null && agent.tools!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildPropertyRow('Tools', agent.tools!.join(', ')),
                  ],
                  const SizedBox(height: 12),
                  _buildPropertyRow('Location', agent.filePath),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 12),
              child: Text(
                'Content Preview',
                style: MacosTheme.of(context).typography.headline,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.elevatedCardDecoration(context),
              child: SelectableText(
                agent.contentWithoutFrontmatter.substring(
                  0,
                  agent.contentWithoutFrontmatter.length > 500
                      ? 500
                      : agent.contentWithoutFrontmatter.length,
                ),
                style: MacosTheme.of(context).typography.body.copyWith(
                      fontFamily: 'monospace',
                      height: 1.5,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: MacosTheme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: MacosTheme.of(context).typography.caption1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: MacosTheme.of(context).primaryColor,
                ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SelectableText(
            value,
            style: MacosTheme.of(context).typography.body,
          ),
        ),
      ],
    );
  }
}
