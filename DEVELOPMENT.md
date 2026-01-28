# Development Guide

快速開發參考指南

## 🚀 快速啟動

```bash
# 首次設置
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# 每日開發
flutter run -d macos

# 熱重載快捷鍵
r    # 熱重載
R    # 熱重啟
q    # 退出
```

## 📁 項目結構

```
lib/
├── models/          數據模型（需要 build_runner 生成代碼）
├── services/        業務邏輯
├── providers/       狀態管理（使用 Provider）
├── screens/         UI 畫面
├── widgets/         可重用組件
└── utils/           工具類
```

## ✅ 下一步要做什麼？

### 優先級 P0（立即做）
1. **添加編輯功能** - 編輯 skills/agents 內容
   - 編輯 skill name, description, content
   - 編輯 agent name, description, tools, model, content
   - 實時預覽 markdown 內容
   - 保存變更到文件

2. **創建新 Skills/Agents** - 添加創建功能
   - 創建 skill 對話框
   - 創建 agent 對話框
   - 模板選擇
   - 自動生成基本結構

### 優先級 P1（本週）
1. **Hooks 管理畫面** - 完成 hooks_screen.dart
2. **設定編輯器** - 讓 settings.json 可編輯
3. **文件監控** - 實現 file_watcher_service.dart
4. **Import 功能** - 導入外部 skills/agents

### 優先級 P2（下週）
1. **驗證服務** - validator_service.dart
2. **備份功能** - backup_service.dart
3. **導入導出** - import_export_service.dart

詳細任務清單見 [TODO.md](./TODO.md)

## 🔨 常用命令

### Flutter 命令
```bash
# 清理構建
flutter clean

# 獲取依賴
flutter pub get

# 分析代碼
flutter analyze

# 運行測試
flutter test

# 構建 macOS 應用
flutter build macos

# 查看設備
flutter devices
```

### 代碼生成
```bash
# 生成 JSON 序列化代碼（修改 models 後）
dart run build_runner build --delete-conflicting-outputs

# 監聽模式（自動重新生成）
dart run build_runner watch --delete-conflicting-outputs
```

### 調試
```bash
# 詳細輸出
flutter run -d macos --verbose

# 查看日誌
flutter logs
```

## 📝 添加新功能的步驟

### 1. 添加新的 Screen
```bash
# 創建文件
touch lib/screens/my_new_screen.dart

# 在 home_screen.dart 中添加路由
# 在 sidebar 中添加導航項
```

### 2. 添加新的 Service
```bash
# 創建服務
touch lib/services/my_service.dart

# 在 app_state_provider.dart 中初始化
```

### 3. 添加新的 Model
```bash
# 創建模型
touch lib/models/my_model.dart

# 添加 @JsonSerializable 註解（如果需要）
# 運行 build_runner
dart run build_runner build --delete-conflicting-outputs
```

## 🎨 UI 開發指南

### 使用 macOS 原生組件

```dart
import 'package:macos_ui/macos_ui.dart';

// 按鈕
PushButton(
  controlSize: ControlSize.large,
  onPressed: () {},
  child: Text('Click Me'),
)

// 複選框
MacosCheckbox(
  value: true,
  onChanged: (value) {},
)

// 列表項
MacosListTile(
  leading: MacosIcon(Icons.star),
  title: Text('Title'),
  subtitle: Text('Subtitle'),
  onClick: () {},
)

// 圖標
MacosIcon(Icons.settings)
```

### 獲取主題顏色
```dart
final theme = MacosTheme.of(context);
final textStyle = theme.typography.body;
final primaryColor = theme.primaryColor;
```

### 響應式佈局
```dart
Row(
  children: [
    SizedBox(width: 200),  // 固定寬度
    Expanded(child: ...),  // 自適應寬度
  ],
)
```

## 🔍 調試技巧

### 打印調試信息
```dart
print('🐛 Debug: $variable');
debugPrint('Warning: $message');
```

### 使用 emoji 標記
```dart
print('🏠 Home directory: $home');
print('📁 Checking directory: $path');
print('✅ Success!');
print('❌ Error: $error');
```

### Flutter DevTools
應用運行後會顯示 DevTools URL：
```
http://127.0.0.1:63660/...
```

在瀏覽器中打開可以：
- 檢查 Widget 樹
- 查看性能
- 分析內存
- 查看網絡請求

## ⚠️ 常見問題

### build_runner 錯誤
```bash
# 刪除生成的文件重新生成
find . -name "*.g.dart" -delete
dart run build_runner build --delete-conflicting-outputs
```

### Hot reload 不工作
```bash
# 使用 Hot Restart (R) 或重新運行應用
flutter run -d macos
```

### Provider 狀態不更新
```dart
// 確保調用 notifyListeners()
_myValue = newValue;
notifyListeners();

// 使用 Consumer 而不是 context.read
Consumer<AppStateProvider>(
  builder: (context, provider, child) {
    return Text(provider.value);
  },
)
```

### macOS 權限問題
檢查 `macos/Runner/DebugProfile.entitlements`：
```xml
<key>com.apple.security.app-sandbox</key>
<false/>  <!-- Debug 模式下關閉沙箱 -->
```

## 📦 依賴管理

### 添加新依賴
```bash
# 添加到 pubspec.yaml
flutter pub add package_name

# 或手動編輯 pubspec.yaml 後
flutter pub get
```

### 常用套件
- `macos_ui` - macOS 原生 UI
- `provider` - 狀態管理
- `file_picker` - 文件選擇器
- `yaml` - YAML 解析
- `watcher` - 文件監控
- `archive` - ZIP 壓縮

## 🧪 測試

### 運行測試
```bash
# 所有測試
flutter test

# 特定文件
flutter test test/services/config_locator_test.dart

# 帶覆蓋率
flutter test --coverage
```

### 測試模板
```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyService', () {
    test('should do something', () {
      // Arrange
      final service = MyService();

      // Act
      final result = service.doSomething();

      // Assert
      expect(result, equals(expected));
    });
  });
}
```

## 🚢 發布

### 構建發布版本
```bash
flutter build macos --release
```

構建產物在：
```
build/macos/Build/Products/Release/claude_settings_manager.app
```

### 創建 DMG
```bash
# 安裝 create-dmg (首次)
brew install create-dmg

# 創建 DMG
create-dmg \
  --volname "Claude Settings Manager" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --app-drop-link 600 185 \
  "ClaudeSettingsManager.dmg" \
  "build/macos/Build/Products/Release/claude_settings_manager.app"
```

## 📚 參考資料

- [Flutter macOS 文檔](https://docs.flutter.dev/platform-integration/macos/building)
- [macos_ui 文檔](https://pub.dev/packages/macos_ui)
- [Provider 文檔](https://pub.dev/packages/provider)
- [Flutter 樣式指南](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)

## 💡 開發建議

1. **保持簡單** - 先實現核心功能，再優化
2. **頻繁提交** - 小步提交，容易回滾
3. **測試驅動** - 重要功能先寫測試
4. **代碼審查** - 使用 code-reviewer agent
5. **文檔同步** - 功能完成後更新 README 和 TODO

## 🎯 本週目標

見 [TODO.md - Quick Wins](./TODO.md#-quick-wins-do-next) 部分

---

## 📝 Recent Updates

### 2026-01-27: Delete Functionality Completed
- ✅ Created `confirmation_dialog.dart` widget component
- ✅ Implemented delete functionality for Skills
  - Confirmation dialog before deletion
  - Success/error notifications
  - Auto-refresh list after deletion
  - Clear selection after deletion
- ✅ Implemented delete functionality for Agents
  - Same features as Skills deletion
  - Proper error handling
- ✅ Fixed code analysis issues
- ✅ All delete operations properly integrated with services

**Files Modified:**
- `lib/widgets/confirmation_dialog.dart` (new)
- `lib/screens/skills_screen.dart`
- `lib/screens/agents_screen.dart`

**Next Steps:**
- Test delete functionality in running app
- Implement edit functionality
- Add create new skill/agent functionality

---

**Happy Coding! 🎉**
