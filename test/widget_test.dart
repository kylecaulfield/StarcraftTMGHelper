import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:starcraft_tmg_helper/game_screen.dart';
import 'package:starcraft_tmg_helper/game_settings.dart';
import 'package:starcraft_tmg_helper/main.dart';
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

  testWidgets('Restore defaults resets adjusted settings', (tester) async {
    await _setTabletSize(tester);
    await tester.pumpWidget(MaterialApp(
      home: SettingsScreen(
        initialSettings: GameSettings.defaults().copyWith(
          victoryThreshold: 20,
          startingRound: 3,
        ),
        onStart: (_) {},
      ),
    ));

    expect(find.text('20'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.tap(find.text('Restore defaults'));
    await tester.pump();

    expect(find.text('15'), findsOneWidget);
    expect(find.text('20'), findsNothing);
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

  testWidgets('Long-press on plus adds 5 points', (tester) async {
    await _setTabletSize(tester);
    await tester.pumpWidget(MaterialApp(
      home: GameScreen(
        settings: GameSettings.defaults(),
        onNewGame: () {},
      ),
    ));

    await tester.longPress(find.byIcon(Icons.add).first);
    await tester.pump();

    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('Long-press on minus clamps at zero', (tester) async {
    await _setTabletSize(tester);
    await tester.pumpWidget(MaterialApp(
      home: GameScreen(
        settings: GameSettings.defaults().copyWith(startingControlPoints: 3),
        onNewGame: () {},
      ),
    ));

    // Both players start at 3 Control Points.
    expect(find.text('3'), findsNWidgets(2));

    await tester.longPress(find.byIcon(Icons.remove).first);
    await tester.pump();

    // Blue's 3 - 5 clamps to 0; only Red still shows 3.
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('Reset asks for confirmation before resetting counters',
      (tester) async {
    await _setTabletSize(tester);
    await tester.pumpWidget(MaterialApp(
      home: GameScreen(
        settings: GameSettings.defaults(),
        onNewGame: () {},
      ),
    ));

    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();
    expect(find.text('1'), findsWidgets);

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    expect(find.text('Reset this game?'), findsOneWidget);

    // Cancel keeps the score.
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsWidgets);

    // Confirm resets it.
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset game'));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsNWidgets(4));
  });

  testWidgets('New Game confirms, then returns to setup with remembered values',
      (tester) async {
    await _setTabletSize(tester);
    await tester.pumpWidget(const StarcraftTmgHelperApp());

    // Bump victory threshold from 15 to 16 on the setup screen.
    final thresholdPlus = find.byIcon(Icons.add).last;
    await tester.tap(thresholdPlus);
    await tester.pump();
    expect(find.text('16'), findsOneWidget);

    await tester.tap(find.text('Start Game'));
    await tester.pumpAndSettle();
    expect(find.text('BLUE'), findsOneWidget);

    await tester.tap(find.text('New Game'));
    await tester.pumpAndSettle();
    expect(find.text('End this game?'), findsOneWidget);

    await tester.tap(find.text('End game'));
    await tester.pumpAndSettle();

    // Back on setup with the adjusted threshold remembered.
    expect(find.text('Start Game'), findsOneWidget);
    expect(find.text('16'), findsOneWidget);
  });
}
