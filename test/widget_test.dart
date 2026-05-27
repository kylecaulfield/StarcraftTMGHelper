import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:starcraft_tmg_helper/game_screen.dart';
import 'package:starcraft_tmg_helper/game_settings.dart';
import 'package:starcraft_tmg_helper/settings_screen.dart';

Future<void> _setTabletSize(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(1600, 1000));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

void main() {
  testWidgets('Settings screen starts a game with adjusted values',
      (tester) async {
    await _setTabletSize(tester);
    GameSettings? captured;
    await tester.pumpWidget(MaterialApp(
      home: SettingsScreen(
        initialSettings: GameSettings.defaults(),
        onStart: (s) => captured = s,
      ),
    ));

    expect(find.text('Starcraft TMG Helper'), findsOneWidget);

    await tester.tap(find.text('Start Game'));
    await tester.pump();

    expect(captured, isNotNull);
    expect(captured!.startingRound, 1);
  });

  testWidgets('Game screen shows BLUE, RED, and ROUND', (tester) async {
    await _setTabletSize(tester);
    await tester.pumpWidget(MaterialApp(
      home: GameScreen(
        settings: GameSettings.defaults(),
        onNewGame: () {},
      ),
    ));

    expect(find.text('BLUE'), findsOneWidget);
    expect(find.text('RED'), findsOneWidget);
    expect(find.text('ROUND'), findsOneWidget);
  });

  testWidgets('Plus button on Blue Control Points increments counter',
      (tester) async {
    await _setTabletSize(tester);
    await tester.pumpWidget(MaterialApp(
      home: GameScreen(
        settings: GameSettings.defaults(),
        onNewGame: () {},
      ),
    ));

    final addIcons = find.byIcon(Icons.add);
    expect(addIcons, findsWidgets);

    await tester.tap(addIcons.first);
    await tester.pump();

    expect(find.text('1'), findsWidgets);
  });
}
