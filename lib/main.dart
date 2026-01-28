import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/app_state_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
      ],
      child: const ClaudeSettingsManagerApp(),
    ),
  );
}

class ClaudeSettingsManagerApp extends StatelessWidget {
  const ClaudeSettingsManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'Claude Settings Manager',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
