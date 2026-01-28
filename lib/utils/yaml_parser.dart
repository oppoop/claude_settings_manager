import 'package:yaml/yaml.dart';

/// Utility class to parse YAML frontmatter from markdown files
class YamlParser {
  /// Parse frontmatter from markdown content
  /// Returns a tuple: (frontmatter as Map, content without frontmatter)
  static ({Map<String, dynamic> frontmatter, String content})
      parseFrontmatter(String markdown) {
    // Check if content starts with ---
    if (!markdown.trimLeft().startsWith('---')) {
      return (
        frontmatter: <String, dynamic>{},
        content: markdown,
      );
    }

    // Find the closing ---
    final lines = markdown.split('\n');
    int startIndex = -1;
    int endIndex = -1;

    for (int i = 0; i < lines.length; i++) {
      final trimmed = lines[i].trim();
      if (trimmed == '---') {
        if (startIndex == -1) {
          startIndex = i;
        } else {
          endIndex = i;
          break;
        }
      }
    }

    // If no valid frontmatter found
    if (startIndex == -1 || endIndex == -1 || endIndex <= startIndex + 1) {
      return (
        frontmatter: <String, dynamic>{},
        content: markdown,
      );
    }

    // Extract frontmatter
    final frontmatterLines = lines.sublist(startIndex + 1, endIndex);
    final frontmatterString = frontmatterLines.join('\n');

    // Extract content after frontmatter
    final contentLines = lines.sublist(endIndex + 1);
    final content = contentLines.join('\n').trimLeft();

    // Parse YAML
    try {
      final yamlDoc = loadYaml(frontmatterString);
      final frontmatter = _convertYamlToMap(yamlDoc);

      return (
        frontmatter: frontmatter,
        content: content,
      );
    } catch (e) {
      // If YAML parsing fails, return empty frontmatter
      return (
        frontmatter: <String, dynamic>{},
        content: markdown,
      );
    }
  }

  /// Convert YAML document to Map<String, dynamic>
  static Map<String, dynamic> _convertYamlToMap(dynamic yamlDoc) {
    if (yamlDoc is YamlMap) {
      final map = <String, dynamic>{};
      yamlDoc.forEach((key, value) {
        map[key.toString()] = _convertYamlValue(value);
      });
      return map;
    }
    return {};
  }

  /// Convert YAML value to Dart type
  static dynamic _convertYamlValue(dynamic value) {
    if (value is YamlMap) {
      return _convertYamlToMap(value);
    } else if (value is YamlList) {
      return value.map((e) => _convertYamlValue(e)).toList();
    } else {
      return value;
    }
  }

  /// Validate frontmatter has required fields
  static bool validateFrontmatter(
    Map<String, dynamic> frontmatter,
    List<String> requiredFields,
  ) {
    for (final field in requiredFields) {
      if (!frontmatter.containsKey(field) || frontmatter[field] == null) {
        return false;
      }
    }
    return true;
  }
}
