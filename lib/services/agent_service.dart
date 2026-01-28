import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/agent_model.dart';
import '../models/claude_config.dart';
import '../utils/yaml_parser.dart';

/// Service for managing Claude agents
class AgentService {
  final ClaudeConfig config;

  AgentService(this.config);

  /// Load all agents from agents directory
  Future<List<AgentModel>> loadAllAgents() async {
    final agents = <AgentModel>[];

    if (!await config.agentsDir.exists()) {
      return agents;
    }

    await for (final entity in config.agentsDir.list()) {
      if (entity is File && entity.path.endsWith('.md')) {
        try {
          final agent = await loadAgent(entity);
          if (agent != null) {
            agents.add(agent);
          }
        } catch (e) {
          // Skip invalid agents
          continue;
        }
      }
    }

    return agents;
  }

  /// Load a single agent from file
  Future<AgentModel?> loadAgent(File agentFile) async {
    if (!await agentFile.exists()) {
      return null;
    }

    try {
      final content = await agentFile.readAsString();
      final parsed = YamlParser.parseFrontmatter(content);

      final agentId = path.basenameWithoutExtension(agentFile.path);

      return AgentModel.fromYamlAndContent(
        id: agentId,
        frontmatter: parsed.frontmatter,
        fullContent: content,
        contentWithoutFrontmatter: parsed.content,
        filePath: agentFile.path,
      );
    } catch (e) {
      throw Exception('Failed to load agent from ${agentFile.path}: $e');
    }
  }

  /// Save agent to file
  Future<void> saveAgent(AgentModel agent) async {
    final agentFile = File(agent.filePath);

    // Ensure parent directory exists
    final parentDir = agentFile.parent;
    if (!await parentDir.exists()) {
      await parentDir.create(recursive: true);
    }

    final content = agent.generateFullContent();
    await agentFile.writeAsString(content);
  }

  /// Create new agent
  Future<AgentModel> createAgent({
    required String id,
    required String name,
    required String description,
    List<String>? tools,
    String? model,
    String? initialContent,
  }) async {
    final agentFile = File(path.join(config.agentsDir.path, '$id.md'));

    if (await agentFile.exists()) {
      throw Exception('Agent with id "$id" already exists');
    }

    final agent = AgentModel(
      id: id,
      name: name,
      description: description,
      tools: tools,
      model: model,
      fullContent: '',
      contentWithoutFrontmatter:
          initialContent ?? '\n# $name\n\n$description\n',
      filePath: agentFile.path,
    );

    await saveAgent(agent);
    return agent;
  }

  /// Delete agent
  Future<void> deleteAgent(AgentModel agent) async {
    final agentFile = File(agent.filePath);

    if (await agentFile.exists()) {
      await agentFile.delete();
    }
  }

  /// Import agent from external file
  Future<AgentModel> importAgent(File sourceFile) async {
    if (!sourceFile.path.endsWith('.md')) {
      throw Exception('Agent file must have .md extension');
    }

    final agentId = path.basenameWithoutExtension(sourceFile.path);
    final targetFile = File(path.join(config.agentsDir.path, '$agentId.md'));

    // Check if agent already exists
    if (await targetFile.exists()) {
      throw Exception('Agent "$agentId" already exists');
    }

    // Copy file
    await sourceFile.copy(targetFile.path);

    // Load and return the imported agent
    final agent = await loadAgent(targetFile);
    if (agent == null) {
      throw Exception('Failed to import agent: Invalid file format');
    }

    return agent;
  }

  /// Validate agent
  ({bool isValid, List<String> errors}) validateAgent(AgentModel agent) {
    final errors = <String>[];

    // Check required fields
    if (agent.name.isEmpty) {
      errors.add('Agent name is required');
    }

    if (agent.description.isEmpty) {
      errors.add('Agent description is required');
    }

    // Validate model if specified
    if (agent.model != null && !agent.isValidModel()) {
      errors.add(
          'Invalid model: ${agent.model}. Must be opus, sonnet, or haiku');
    }

    // Note: File existence is checked when loading

    return (isValid: errors.isEmpty, errors: errors);
  }

  /// Get agent file path
  String getAgentFilePath(String agentId) {
    return path.join(config.agentsDir.path, '$agentId.md');
  }
}
