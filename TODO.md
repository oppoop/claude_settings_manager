# Claude Settings Manager - TODO List

## 🔄 Recent Updates (2026-01-28)

- ✅ Fixed MacosTypography build error for macos_ui 2.2.2 compatibility
- ✅ Successfully built macOS Release app (42.1MB)
- ✅ Initialized Git repository with comprehensive .gitignore
- ✅ Created initial commit following commit guidelines
- ✅ Pushed to GitHub repository: https://github.com/oppoop/claude_settings_manager
- ✅ Installed and configured GitHub CLI for authentication

## 🎯 Project Status

### ✅ Completed (Phase 1)
- [x] Flutter macOS project setup
- [x] Dependencies configuration
- [x] Data models (Settings, Skill, Agent, Backup, ClaudeConfig)
- [x] Core services (ConfigLocator, SettingsService, SkillService, AgentService)
- [x] YAML frontmatter parser
- [x] macOS UI theme setup
- [x] Main application structure
- [x] Sidebar navigation
- [x] Settings viewer screen
- [x] Skills list and detail view
- [x] Agents list and detail view
- [x] Auto-discovery of ~/.claude directory
- [x] Sandbox permission handling
- [x] Refresh buttons for Skills and Agents
- [x] Delete functionality with confirmation dialogs
- [x] Confirmation dialog widget component
- [x] Success/error notifications for delete operations
- [x] Git repository initialization with proper .gitignore
- [x] Fixed MacosTypography build error for macos_ui compatibility
- [x] Successful macOS app build (Release configuration)
- [x] GitHub repository setup and initial commit pushed

---

## 📋 Phase 2: Edit & Management Features

### Settings Management
- [ ] **Edit settings.json directly**
  - [ ] JSON editor with syntax highlighting
  - [ ] Validate JSON before saving
  - [ ] Show validation errors
  - [ ] Format JSON automatically

- [ ] **Permissions Management**
  - [ ] Add new permission to allow list
  - [ ] Remove permission from allow list
  - [ ] Edit permission patterns
  - [ ] Add/remove deny list entries
  - [ ] Visual permission editor UI

- [ ] **Plugin Management**
  - [ ] Toggle plugin enable/disable
  - [ ] View plugin details
  - [ ] Add new plugin entry
  - [ ] Remove plugin entry

### Skills Management
- [ ] **Edit Skills**
  - [ ] Edit skill name and description
  - [ ] Edit SKILL.md content with markdown editor
  - [ ] Save changes back to file
  - [ ] Preview markdown rendering

- [ ] **Create New Skills**
  - [ ] New skill creation dialog
  - [ ] Template selection
  - [ ] Auto-generate SKILL.md structure

- [x] **Delete Skills**
  - [x] Confirmation dialog
  - [x] Delete skill directory
  - [x] Refresh skill list

- [ ] **Import Skills**
  - [ ] Import from directory picker
  - [ ] Validate skill structure
  - [ ] Handle duplicate names
  - [ ] Batch import multiple skills

### Agents Management
- [ ] **Edit Agents**
  - [ ] Edit agent metadata (name, description, tools, model)
  - [ ] Edit agent content
  - [ ] Model dropdown (opus/sonnet/haiku)
  - [ ] Tools multi-select editor

- [ ] **Create New Agents**
  - [ ] New agent creation dialog
  - [ ] Template selection
  - [ ] Auto-generate frontmatter

- [x] **Delete Agents**
  - [x] Confirmation dialog
  - [x] Delete agent file
  - [x] Refresh agent list

- [ ] **Import Agents**
  - [ ] Import from file picker
  - [ ] Validate agent structure
  - [ ] Handle duplicate names

---

## 📋 Phase 3: Hooks Management Screen

### Hooks Viewer
- [ ] **Create hooks_screen.dart**
  - [ ] List all hook event types
  - [ ] Show hooks grouped by event
  - [ ] Display hook matcher and commands

### Hooks Editor
- [ ] **Visual Hook Editor**
  - [ ] Add new hook configuration
  - [ ] Edit hook matcher pattern
  - [ ] Edit hook command
  - [ ] Delete hook
  - [ ] Test hook pattern matching

- [ ] **Hook Scripts Management**
  - [ ] List scripts in .claude/hooks/ directory
  - [ ] View script content
  - [ ] Edit script content
  - [ ] Create new hook script
  - [ ] Delete hook script

### Hook Service
- [ ] **Create hook_service.dart**
  - [ ] Load hooks from settings.json
  - [ ] Save hooks to settings.json
  - [ ] Validate hook configuration
  - [ ] Test hook matcher patterns

---

## 📋 Phase 4: Advanced Features

### Real-time File Monitoring
- [ ] **Create file_watcher_service.dart**
  - [ ] Watch settings.json for changes
  - [ ] Watch skills directory
  - [ ] Watch agents directory
  - [ ] Watch hooks directory
  - [ ] Auto-reload on external changes
  - [ ] Show notification on file change

- [ ] **UI Indicators**
  - [ ] "File changed externally" banner
  - [ ] Reload button
  - [ ] Auto-reload toggle in settings

### Configuration Validation
- [ ] **Create validator_service.dart**
  - [ ] Validate JSON format
  - [ ] Validate YAML frontmatter format
  - [ ] Check required fields
  - [ ] Validate permission patterns
  - [ ] Validate hook configurations
  - [ ] Show validation errors with line numbers

- [ ] **Validation UI**
  - [ ] Validation indicator widget
  - [ ] Error list panel
  - [ ] Click error to jump to location
  - [ ] Auto-validate on save

### Search & Filter
- [ ] **Search functionality**
  - [ ] Search skills by name/description
  - [ ] Search agents by name/description
  - [ ] Filter by enabled/disabled
  - [ ] Search in settings.json

---

## 📋 Phase 5: Backup & Import/Export

### Backup Service
- [ ] **Create backup_service.dart**
  - [ ] Create ZIP backup of all configs
  - [ ] Include settings.json
  - [ ] Include all skills
  - [ ] Include all agents
  - [ ] Include rules/
  - [ ] Include hooks/
  - [ ] Generate backup metadata

### Backup Screen
- [ ] **Create backup_screen.dart**
  - [ ] List existing backups
  - [ ] Show backup details (date, size, contents)
  - [ ] Create new backup button
  - [ ] Restore backup button
  - [ ] Delete backup button
  - [ ] Export backup to custom location

### Restore Functionality
- [ ] **Restore from backup**
  - [ ] Select backup file
  - [ ] Preview backup contents
  - [ ] Confirm overwrite dialog
  - [ ] Restore files
  - [ ] Reload application state

### Import/Export Service
- [ ] **Create import_export_service.dart**
  - [ ] Export single skill
  - [ ] Export single agent
  - [ ] Export settings subset
  - [ ] Export complete configuration
  - [ ] Import skill package
  - [ ] Import agent package
  - [ ] Import settings

### Import Screen
- [ ] **Create import_screen.dart**
  - [ ] Import skills from folder
  - [ ] Import agents from file
  - [ ] Import settings.json (merge option)
  - [ ] Import hook scripts
  - [ ] Preview before import
  - [ ] Validation before import
  - [ ] Handle conflicts

---

## 📋 Phase 6: UI/UX Improvements

### User Experience
- [ ] **Loading states**
  - [ ] Skeleton loaders
  - [ ] Progress indicators
  - [ ] Loading animations

- [ ] **Error handling**
  - [ ] User-friendly error messages
  - [ ] Error toast notifications
  - [ ] Error recovery options

- [ ] **Notifications**
  - [ ] Success notifications
  - [ ] Warning notifications
  - [ ] Info notifications

### Keyboard Shortcuts
- [ ] Cmd+S to save
- [ ] Cmd+R to refresh
- [ ] Cmd+F to search
- [ ] Cmd+N to create new
- [ ] Cmd+Backspace to delete

### Context Menus
- [ ] Right-click on skill
- [ ] Right-click on agent
- [ ] Copy/paste functionality
- [ ] Duplicate skill/agent

### Preferences
- [ ] **App settings screen**
  - [ ] Auto-reload toggle
  - [ ] Default backup location
  - [ ] Theme preference
  - [ ] Font size preference

---

## 📋 Phase 7: Cross-platform Preparation

### Platform Abstraction
- [ ] **Create platform utilities**
  - [ ] Abstract path handling
  - [ ] Platform-specific home directory
  - [ ] Platform-specific file operations

### Windows Support Preparation
- [ ] **Test on Windows**
  - [ ] Windows home directory resolution
  - [ ] Windows file paths
  - [ ] Windows UI testing
  - [ ] Windows-specific entitlements

### Code Organization
- [ ] Move platform-specific code to separate files
- [ ] Create platform interfaces
- [ ] Implement platform-specific implementations

---

## 📋 Phase 8: Testing & Quality

### Unit Tests
- [ ] **Model tests**
  - [ ] Test settings_model serialization
  - [ ] Test skill_model YAML parsing
  - [ ] Test agent_model YAML parsing

- [ ] **Service tests**
  - [ ] Test config_locator
  - [ ] Test settings_service
  - [ ] Test skill_service
  - [ ] Test agent_service
  - [ ] Test validator_service
  - [ ] Test backup_service

### Integration Tests
- [ ] Test full workflow: create skill -> edit -> delete
- [ ] Test full workflow: backup -> restore
- [ ] Test full workflow: import -> export

### Widget Tests
- [ ] Test settings_screen
- [ ] Test skills_screen
- [ ] Test agents_screen
- [ ] Test home_screen navigation

---

## 📋 Phase 9: Documentation & Polish

### Documentation
- [ ] **README.md**
  - [ ] Installation instructions
  - [ ] Usage guide
  - [ ] Screenshots
  - [ ] Features list

- [ ] **CONTRIBUTING.md**
  - [ ] How to contribute
  - [ ] Code style guide
  - [ ] Development setup

- [ ] **User Guide**
  - [ ] Feature walkthrough
  - [ ] Tips and tricks
  - [ ] Troubleshooting

### Code Quality
- [ ] Fix all linter warnings
- [ ] Add code comments
- [ ] Improve error messages
- [ ] Add logging

### App Polish
- [ ] App icon design
- [ ] Launch screen
- [ ] About dialog
- [ ] Version info

---

## 📋 Phase 10: Distribution

### Build & Release
- [ ] **macOS build**
  - [ ] Release build configuration
  - [ ] Code signing
  - [ ] Notarization
  - [ ] DMG creation

- [ ] **Windows build** (future)
  - [ ] Windows installer
  - [ ] Code signing

### Release Process
- [ ] Version numbering
- [ ] Changelog generation
- [ ] GitHub releases
- [ ] Distribution channels

---

## 🚀 Quick Wins (Do Next)

These are high-priority items that provide immediate value:

1. ✅ **Fix current sandbox issue** (Completed)
2. ✅ **Enable skill deletion** (Completed - with confirmation dialog)
3. ✅ **Enable agent deletion** (Completed - with confirmation dialog)
4. ✅ **Add refresh buttons** (Completed - manual refresh available)
5. ✅ **Git repository setup** (Completed - pushed to GitHub)
6. **Edit Skills** - Edit SKILL.md content and metadata
7. **Edit Agents** - Edit agent content and frontmatter
8. **Add hooks screen** - Complete the hooks management UI
9. **Enable settings editing** - Make settings.json editable
10. **Improve error display** - Show detailed error messages
11. **Add file watcher** - Auto-reload on external changes

---

## 🐛 Known Issues

1. ~~**Sandbox path issue**~~ - ✅ Fixed: macOS sandbox handling implemented
2. **No edit functionality** - Currently read-only (Phase 2)
3. ~~**No delete confirmation**~~ - ✅ Fixed: Confirmation dialogs implemented
4. **No search** - Can't search through large lists (Phase 4)
5. **No backup** - No way to backup current configuration (Phase 5)

---

## 💡 Future Ideas

- [ ] Export to GitHub gist
- [ ] Share skills via URL
- [ ] Skill marketplace integration
- [ ] Syntax highlighting for skill content
- [ ] Diff viewer for changes
- [ ] Git integration
- [ ] Cloud sync
- [ ] Multi-profile support
- [ ] Skill templates library
- [ ] Agent templates library
- [ ] Dark/light mode toggle in app
- [ ] Custom themes
- [ ] Skill analytics
- [ ] Usage statistics
