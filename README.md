# Claude Settings Manager

A native macOS desktop application for managing Claude Code settings, skills, agents, and hooks.

![Platform](https://img.shields.io/badge/platform-macOS-lightgrey)
![Flutter](https://img.shields.io/badge/Flutter-3.24+-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## 📱 Features

### ✅ Currently Available
- **Auto-discover** Claude Code configuration at `~/.claude`
- **View Settings** - Display settings.json with permissions, plugins, and hooks
- **Manage Skills** - Browse and view all your Claude skills
- **Manage Agents** - Browse and view all your Claude agents
- **macOS Native UI** - Beautiful native macOS interface with light/dark mode support

### 🚧 Coming Soon
- Edit settings, skills, and agents
- Create and delete skills/agents
- Visual hooks editor
- Real-time file monitoring
- Configuration validation
- Backup and restore
- Import/Export configurations

See [TODO.md](./TODO.md) for the complete roadmap.

---

## 🚀 Quick Start

### Prerequisites
- macOS 10.15+
- Flutter 3.24+
- Claude Code installed with `~/.claude` directory

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd claude_settings_manager

# Install dependencies
flutter pub get

# Run the app
flutter run -d macos
```

### First Launch

The app will automatically detect your Claude configuration at `~/.claude`. If not found, you can:
1. Click **"Choose Directory"** to manually select your `.claude` folder
2. Click **"Retry"** to try auto-detection again

---

## 🏗️ Architecture

### Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/                      # Data models
│   ├── settings_model.dart      # Settings JSON model
│   ├── skill_model.dart         # Skill YAML model
│   ├── agent_model.dart         # Agent YAML model
│   ├── backup_model.dart        # Backup metadata
│   └── claude_config.dart       # Config structure
├── services/                    # Business logic
│   ├── config_locator.dart      # Find ~/.claude
│   ├── settings_service.dart    # Read/write settings
│   ├── skill_service.dart       # Manage skills
│   └── agent_service.dart       # Manage agents
├── providers/                   # State management
│   └── app_state_provider.dart  # Global app state
├── screens/                     # UI screens
│   ├── home_screen.dart         # Main window
│   ├── settings_screen.dart     # Settings viewer
│   ├── skills_screen.dart       # Skills management
│   └── agents_screen.dart       # Agents management
├── widgets/                     # Reusable widgets
└── utils/                       # Utilities
    ├── yaml_parser.dart         # Parse YAML frontmatter
    └── constants.dart           # App constants
```

### Tech Stack

- **Flutter** - Cross-platform UI framework
- **macos_ui** - Native macOS widgets
- **Provider** - State management
- **yaml** - YAML parsing
- **json_serializable** - JSON serialization
- **file_picker** - Directory selection
- **watcher** - File monitoring (coming soon)

---

## 🎯 Usage

### Viewing Settings

Click **Settings** in the sidebar to view:
- General settings (includeCoAuthoredBy)
- Allowed permissions list
- Enabled plugins
- Hooks configuration count

### Managing Skills

Click **Skills** in the sidebar to:
- Browse all skills from `~/.claude/skills/`
- View skill metadata (name, description)
- Preview skill content
- Refresh skill list

### Managing Agents

Click **Agents** in the sidebar to:
- Browse all agents from `~/.claude/agents/`
- View agent metadata (name, description, tools, model)
- Preview agent content
- Refresh agent list

---

## 🔧 Development

### Running in Development

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run with verbose logging
flutter run -d macos --verbose
```

### Code Generation

When modifying models with `@JsonSerializable`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Debugging

The app outputs debug logs with emoji markers:
- 🏠 Home directory detection
- 📁 Directory checking
- 📂 Directory existence
- 📄 File checking
- ✅ Success
- ❌ Errors

---

## 🐛 Troubleshooting

### App shows "Retry" button

**Problem:** App cannot find `~/.claude` directory

**Solutions:**
1. Check console output for debug messages (🏠📁📂)
2. Verify `~/.claude` exists: `ls -la ~/.claude`
3. Verify `settings.json` exists: `ls ~/.claude/settings.json`
4. Use **"Choose Directory"** button to manually select `.claude` folder

### Sandbox permission issues

**Problem:** macOS sandbox prevents access to files

**Solution:** The app disables sandbox in debug mode. For production builds, you'll need to handle permissions differently.

### No skills/agents showing

**Problem:** Skills or agents not displayed

**Solutions:**
1. Check if directories exist: `ls ~/.claude/skills/` and `ls ~/.claude/agents/`
2. Verify SKILL.md files have valid YAML frontmatter
3. Click the refresh button (🔄)
4. Check console for parsing errors

---

## 📝 Configuration Files

### Settings.json Structure

```json
{
  "includeCoAuthoredBy": false,
  "permissions": {
    "allow": ["Read", "Write", "Bash(git:*)"],
    "deny": []
  },
  "enabledPlugins": {
    "plugin-name@org": true
  },
  "hooks": {
    "PreToolUse": [...]
  }
}
```

### Skill SKILL.md Structure

```markdown
---
name: skill-name
description: Skill description
---

# Skill content here
```

### Agent .md Structure

```markdown
---
name: agent-name
description: Agent description
tools: Read, Write, Bash
model: sonnet
---

# Agent instructions here
```

---

## 🗺️ Roadmap

### Phase 1: Core Functionality ✅
- [x] Project setup
- [x] Data models
- [x] Core services
- [x] Basic UI
- [x] Auto-discovery

### Phase 2: Edit Features 🚧
- [ ] Edit settings.json
- [ ] Edit skills
- [ ] Edit agents
- [ ] Create/delete functionality

### Phase 3: Hooks Management 📋
- [ ] Hooks viewer
- [ ] Visual hooks editor
- [ ] Hook scripts management

### Phase 4: Advanced Features 📋
- [ ] Real-time file monitoring
- [ ] Configuration validation
- [ ] Search & filter

### Phase 5: Backup & Import 📋
- [ ] Create backups
- [ ] Restore backups
- [ ] Import/export configs

### Phase 6: Cross-platform 📋
- [ ] Windows support
- [ ] Platform abstractions

See [TODO.md](./TODO.md) for detailed task list.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Guidelines

1. Follow Flutter style guide
2. Add tests for new features
3. Update documentation
4. Keep commits atomic and descriptive

---

## 📄 License

MIT License - See LICENSE file for details

---

## 🙏 Acknowledgments

- [Claude Code](https://claude.ai/code) - The CLI tool this app manages
- [macos_ui](https://pub.dev/packages/macos_ui) - Beautiful macOS widgets
- [Flutter](https://flutter.dev) - Amazing cross-platform framework

---

## 📞 Support

For issues and questions:
- Check [TODO.md](./TODO.md) for known issues
- Create an issue on GitHub
- Check console debug output (🏠📁📂📄✅❌)

---

**Built with ❤️ for Claude Code users**
