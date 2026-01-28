/// Agent model representing an agent .md file with YAML frontmatter
class AgentModel {
  final String id; // Filename without extension
  final String name;
  final String description;
  final List<String>? tools;
  final String? model; // opus, sonnet, or haiku
  final String fullContent; // Complete markdown content
  final String contentWithoutFrontmatter; // Content after frontmatter
  final String filePath;

  AgentModel({
    required this.id,
    required this.name,
    required this.description,
    this.tools,
    this.model,
    required this.fullContent,
    required this.contentWithoutFrontmatter,
    required this.filePath,
  });

  factory AgentModel.fromYamlAndContent({
    required String id,
    required Map<String, dynamic> frontmatter,
    required String fullContent,
    required String contentWithoutFrontmatter,
    required String filePath,
  }) {
    // Parse tools (can be string or list)
    List<String>? tools;
    if (frontmatter.containsKey('tools')) {
      final toolsData = frontmatter['tools'];
      if (toolsData is String) {
        tools = toolsData.split(',').map((e) => e.trim()).toList();
      } else if (toolsData is List) {
        tools = toolsData.map((e) => e.toString()).toList();
      }
    }

    return AgentModel(
      id: id,
      name: frontmatter['name'] as String? ?? id,
      description: frontmatter['description'] as String? ?? '',
      tools: tools,
      model: frontmatter['model'] as String?,
      fullContent: fullContent,
      contentWithoutFrontmatter: contentWithoutFrontmatter,
      filePath: filePath,
    );
  }

  AgentModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? tools,
    String? model,
    String? fullContent,
    String? contentWithoutFrontmatter,
    String? filePath,
  }) {
    return AgentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      tools: tools ?? this.tools,
      model: model ?? this.model,
      fullContent: fullContent ?? this.fullContent,
      contentWithoutFrontmatter:
          contentWithoutFrontmatter ?? this.contentWithoutFrontmatter,
      filePath: filePath ?? this.filePath,
    );
  }

  /// Generate frontmatter as YAML string
  String generateFrontmatter() {
    final buffer = StringBuffer('---\n');
    buffer.writeln('name: $name');
    buffer.writeln('description: $description');

    if (tools != null && tools!.isNotEmpty) {
      buffer.writeln('tools: ${tools!.join(", ")}');
    }

    if (model != null) {
      buffer.writeln('model: $model');
    }

    buffer.writeln('---\n');
    return buffer.toString();
  }

  /// Regenerate full content with updated frontmatter
  String generateFullContent() {
    return generateFrontmatter() + contentWithoutFrontmatter;
  }

  /// Validate model value
  bool isValidModel() {
    if (model == null) return true;
    return ['opus', 'sonnet', 'haiku'].contains(model);
  }
}
