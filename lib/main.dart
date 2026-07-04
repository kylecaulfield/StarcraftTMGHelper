import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'game_screen.dart';
import 'game_settings.dart';
import 'settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  WakelockPlus.enable();
  runApp(const StarcraftTmgHelperApp());
}

class StarcraftTmgHelperApp extends StatefulWidget {
  const StarcraftTmgHelperApp({super.key});

  @override
  State<StarcraftTmgHelperApp> createState() => _StarcraftTmgHelperAppState();
}

class _StarcraftTmgHelperAppState extends State<StarcraftTmgHelperApp> {
  GameSettings _lastSettings = GameSettings.defaults();
  bool _inGame = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Starcraft TMG Helper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF101218),
      ),
      home: _inGame
          ? GameScreen(
              settings: _lastSettings,
              onNewGame: () => setState(() => _inGame = false),
            )
          : SettingsScreen(
              initialSettings: _lastSettings,
              onStart: (s) => setState(() {
                _lastSettings = s;
                _inGame = true;
              }),
            ),
    );
  }
}
