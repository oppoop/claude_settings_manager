# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Delete functionality for Skills with confirmation dialog
- Delete functionality for Agents with confirmation dialog
- Reusable confirmation dialog widget component
- Success and error notifications for delete operations
- Automatic list refresh after deletion
- Manual refresh buttons for Skills and Agents lists

### Changed
- Updated Skills screen to support delete operations
- Updated Agents screen to support delete operations

### Fixed
- Fixed ButtonSize parameter issue in confirmation dialogs
- Fixed code analysis warnings

## [0.1.0] - 2026-01-27

### Added
- Initial Flutter macOS project setup
- Core data models (Settings, Skill, Agent, Backup, ClaudeConfig)
- Service layer (ConfigLocator, SettingsService, SkillService, AgentService)
- YAML frontmatter parser utility
- macOS UI theme integration
- Main application structure with sidebar navigation
- Settings viewer screen (read-only)
- Skills list and detail view
- Agents list and detail view
- Auto-discovery of ~/.claude directory
- Sandbox permission handling for macOS
- Debug logging with emoji markers

### Technical Details
- Flutter SDK with macOS support
- macos_ui package for native macOS components
- Provider package for state management
- YAML parsing for frontmatter
- File system operations with proper error handling
