/// Skill model representing a SKILL.md file with YAML frontmatter
class SkillModel {
  final String id; // Directory name
  final String name;
  final String description;
  final String fullContent; // Complete markdown content
  final String contentWithoutFrontmatter; // Content after frontmatter
  final String directoryPath;

  SkillModel({
    required this.id,
    required this.name,
    required this.description,
    required this.fullContent,
    required this.contentWithoutFrontmatter,
    required this.directoryPath,
  });

  factory SkillModel.fromYamlAndContent({
    required String id,
    required Map<String, dynamic> frontmatter,
    required String fullContent,
    required String contentWithoutFrontmatter,
    required String directoryPath,
  }) {
    return SkillModel(
      id: id,
      name: frontmatter['name'] as String? ?? id,
      description: frontmatter['description'] as String? ?? '',
      fullContent: fullContent,
      contentWithoutFrontmatter: contentWithoutFrontmatter,
      directoryPath: directoryPath,
    );
  }

  SkillModel copyWith({
    String? id,
    String? name,
    String? description,
    String? fullContent,
    String? contentWithoutFrontmatter,
    String? directoryPath,
  }) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      fullContent: fullContent ?? this.fullContent,
      contentWithoutFrontmatter:
          contentWithoutFrontmatter ?? this.contentWithoutFrontmatter,
      directoryPath: directoryPath ?? this.directoryPath,
    );
  }

  /// Generate frontmatter as YAML string
  String generateFrontmatter() {
    return '---\n'
        'name: $name\n'
        'description: $description\n'
        '---\n';
  }

  /// Regenerate full content with updated frontmatter
  String generateFullContent() {
    return generateFrontmatter() + contentWithoutFrontmatter;
  }
}
