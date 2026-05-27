import 'package:flutter/material.dart';

import 'game_settings.dart';
import 'player_panel.dart';

class GameScreen extends StatefulWidget {
  final GameSettings settings;
  final VoidCallback onNewGame;

  const GameScreen({
    super.key,
    required this.settings,
    required this.onNewGame,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late int _blueControl;
  late int _blueFaction;
  late int _redControl;
  late int _redFaction;
  late int _round;

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  void _resetState() {
    _blueControl = widget.settings.startingControlPoints;
    _blueFaction = widget.settings.startingFactionPoints;
    _redControl = widget.settings.startingControlPoints;
    _redFaction = widget.settings.startingFactionPoints;
    _round = widget.settings.startingRound;
  }

  void _confirmReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Start a new game?'),
        content: const Text(
          'This will reset Control Points, Faction Points, and the round counter for both players.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('New game'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      widget.onNewGame();
    }
  }

  void _resetCounters() {
    setState(_resetState);
  }

  @override
  Widget build(BuildContext context) {
    final threshold = widget.settings.victoryThreshold;
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: PlayerPanel(
                name: 'BLUE',
                color: const Color(0xFF1E88E5),
                accentColor: const Color(0xFF64B5F6),
                controlPoints: _blueControl,
                factionPoints: _blueFaction,
                victoryThreshold: threshold,
                onControlChanged: (v) => setState(() => _blueControl = v),
                onFactionChanged: (v) => setState(() => _blueFaction = v),
              ),
            ),
            Expanded(
              flex: 2,
              child: _CenterColumn(
                round: _round,
                onRoundChanged: (v) => setState(() => _round = v),
                onResetCounters: _resetCounters,
                onNewGame: _confirmReset,
              ),
            ),
            Expanded(
              flex: 4,
              child: PlayerPanel(
                name: 'RED',
                color: const Color(0xFFE53935),
                accentColor: const Color(0xFFEF5350),
                controlPoints: _redControl,
                factionPoints: _redFaction,
                victoryThreshold: threshold,
                onControlChanged: (v) => setState(() => _redControl = v),
                onFactionChanged: (v) => setState(() => _redFaction = v),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterColumn extends StatelessWidget {
  final int round;
  final ValueChanged<int> onRoundChanged;
  final VoidCallback onResetCounters;
  final VoidCallback onNewGame;

  const _CenterColumn({
    required this.round,
    required this.onRoundChanged,
    required this.onResetCounters,
    required this.onNewGame,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF181A22),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          const Text(
            'ROUND',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RoundButton(
                    icon: Icons.keyboard_arrow_up,
                    onPressed: () => onRoundChanged(round + 1),
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$round',
                      style: const TextStyle(
                        fontSize: 140,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _RoundButton(
                    icon: Icons.keyboard_arrow_down,
                    onPressed: round > 1 ? () => onRoundChanged(round - 1) : null,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onResetCounters,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: onNewGame,
            icon: const Icon(Icons.fiber_new),
            label: const Text('New Game'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _RoundButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 56,
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Icon(icon, size: 32),
      ),
    );
  }
}
