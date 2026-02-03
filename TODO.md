# Claude Settings Manager - TODO List

## 🔄 Recent Updates

### 2026-02-03
- ✅ Implemented Settings editing functionality (full CRUD)
- ✅ Created EditRawJsonDialog with JSON validation and formatting
- ✅ Created AddPermissionDialog with preset options and custom input
- ✅ Created AddPluginDialog with name and enabled state
- ✅ Extended SettingsService with updateIncludeCoAuthoredBy, addDenyPermission, removeDenyPermission, addPlugin, removePlugin, formatJson methods
- ✅ Refactored SettingsScreen from read-only to fully editable
- ✅ Added "Edit JSON" button for raw JSON editing
- ✅ Added permissions management (add/remove allow/deny)
- ✅ Added plugins management (toggle/add/remove)
- ✅ Added proper null check handling for settingsService
- ✅ Successfully built macOS Release app (43.0MB)

### 2026-01-30
- ✅ Implemented Hooks editing functionality (add/edit/delete)
- ✅ Created EditHookDialog with matcher pattern and actions editor
- ✅ Created CreateHookDialog with hook type selection and validation
- ✅ Extended SettingsService with addHook, updateHook, deleteHook methods
- ✅ Updated HooksScreen with CRUD buttons and operations
- ✅ Successfully built macOS Release app (42.8MB)

### 2026-01-29
- ✅ Implemented Skills editing functionality with markdown editor
- ✅ Implemented Agents editing functionality with metadata editor
- ✅ Added Edit button to Skills detail view
- ✅ Added Edit button to Agents detail view
- ✅ Created EditSkillDialog with name, description, and content fields
- ✅ Created EditAgentDialog with name, description, tools, model, and content fields
- ✅ Implemented Skills creation functionality with validation
- ✅ Implemented Agents creation functionality with validation
- ✅ Added Create button (+ icon) to Skills screen header
- ✅ Added Create button (+ icon) to Agents screen header
- ✅ Created CreateSkillDialog with ID validation and content template
- ✅ Created CreateAgentDialog with ID validation and content template
- ✅ Implemented Skills import from external directory
- ✅ Implemented Agents import from external .md file
- ✅ Added Import button to Skills detail view
- ✅ Added Import button to Agents detail view
- ✅ Created Hooks management screen (read-only viewer)
- ✅ Display all hook event types in sidebar
- ✅ Show hook configurations with matcher and actions
- ✅ Added Hooks to main navigation
- ✅ Successfully built macOS Release app (42.6MB)

### 2026-01-28
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
- [x] **Edit settings.json directly**
  - [x] JSON editor with syntax highlighting
  - [x] Validate JSON before saving
  - [x] Show validation errors
  - [x] Format JSON automatically

- [x] **Permissions Management**
  - [x] Add new permission to allow list
  - [x] Remove permission from allow list
  - [ ] Edit permission patterns
  - [x] Add/remove deny list entries
  - [x] Visual permission editor UI

- [x] **Plugin Management**
  - [x] Toggle plugin enable/disable
  - [ ] View plugin details
  - [x] Add new plugin entry
  - [x] Remove plugin entry

### Skills Management
- [x] **Edit Skills**
  - [x] Edit skill name and description
  - [x] Edit SKILL.md content with markdown editor
  - [x] Save changes back to file
  - [ ] Preview markdown rendering

- [x] **Create New Skills**
  - [x] New skill creation dialog
  - [x] Default content template
  - [x] Auto-generate SKILL.md structure with frontmatter
  - [x] ID validation (lowercase, alphanumeric, dash, underscore)

- [x] **Delete Skills**
  - [x] Confirmation dialog
  - [x] Delete skill directory
  - [x] Refresh skill list

- [x] **Import Skills**
  - [x] Import from directory picker
  - [x] Validate skill structure (SKILL.md required)
  - [x] Handle duplicate names (error message)
  - [ ] Batch import multiple skills

### Agents Management
- [x] **Edit Agents**
  - [x] Edit agent metadata (name, description, tools, model)
  - [x] Edit agent content
  - [x] Model dropdown (opus/sonnet/haiku)
  - [x] Tools text editor (comma-separated)

- [x] **Create New Agents**
  - [x] New agent creation dialog
  - [x] Default content template
  - [x] Auto-generate frontmatter with all metadata
  - [x] ID validation (lowercase, alphanumeric, dash, underscore)

- [x] **Delete Agents**
  - [x] Confirmation dialog
  - [x] Delete agent file
  - [x] Refresh agent list

- [x] **Import Agents**
  - [x] Import from file picker (.md files only)
  - [x] Validate agent structure (frontmatter required)
  - [x] Handle duplicate names (error message)

---

## 📋 Phase 3: Hooks Management Screen

### Hooks Viewer
- [x] **Create hooks_screen.dart**
  - [x] List all hook event types
  - [x] Show hooks grouped by event
  - [x] Display hook matcher and commands
  - [x] Display hook actions with type and command

### Hooks Editor
- [x] **Visual Hook Editor**
  - [x] Add new hook configuration
  - [x] Edit hook matcher pattern
  - [x] Edit hook command
  - [x] Delete hook
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
6. ✅ **Edit Skills** (Completed - Full editing with markdown editor)
7. ✅ **Edit Agents** (Completed - Full editing with metadata)
8. ✅ **Create New Skills** (Completed - Dialog with validation and templates)
9. ✅ **Create New Agents** (Completed - Dialog with validation and templates)
10. ✅ **Import Skills** (Completed - Directory picker with validation)
11. ✅ **Import Agents** (Completed - File picker with .md filter)
12. ✅ **Add hooks screen** (Completed - Read-only viewer for hooks)
13. ✅ **Enable hooks editing** (Completed - Add/edit/delete hook configurations)
14. ✅ **Enable settings editing** (Completed - JSON editor, permissions, plugins management)
15. **Improve error display** - Show detailed error messages
16. **Add file watcher** - Auto-reload on external changes

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
