/// Backup metadata model
class BackupModel {
  final String name;
  final DateTime timestamp;
  final String filePath;
  final int sizeInBytes;
  final BackupContents contents;

  BackupModel({
    required this.name,
    required this.timestamp,
    required this.filePath,
    required this.sizeInBytes,
    required this.contents,
  });

  String get formattedSize {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  String get formattedDate {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-'
        '${timestamp.day.toString().padLeft(2, '0')} '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

/// Contents included in a backup
class BackupContents {
  final bool hasSettings;
  final bool hasRules;
  final int skillsCount;
  final int agentsCount;
  final bool hasPlugins;

  BackupContents({
    required this.hasSettings,
    required this.hasRules,
    required this.skillsCount,
    required this.agentsCount,
    required this.hasPlugins,
  });

  String get summary {
    final parts = <String>[];
    if (hasSettings) parts.add('Settings');
    if (hasRules) parts.add('Rules');
    if (skillsCount > 0) parts.add('$skillsCount Skills');
    if (agentsCount > 0) parts.add('$agentsCount Agents');
    if (hasPlugins) parts.add('Plugins');

    return parts.join(', ');
  }
}
