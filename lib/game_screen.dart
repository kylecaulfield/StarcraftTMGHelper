import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _confirmNewGame() async {
    final confirmed = await _confirm(
      title: 'End this game?',
      message:
          'This ends the current game and returns to the setup screen. Your setup values will be remembered.',
      confirmLabel: 'End game',
    );
    if (confirmed && mounted) {
      widget.onNewGame();
    }
  }

  Future<void> _confirmResetCounters() async {
    final confirmed = await _confirm(
      title: 'Reset this game?',
      message:
          'Control Points, Faction Points, and the round counter return to their starting values for both players.',
      confirmLabel: 'Reset game',
    );
    if (confirmed && mounted) {
      setState(_resetState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final threshold = widget.settings.victoryThreshold;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _confirmNewGame();
        }
      },
      child: Scaffold(
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
                  onControlChanged: (v) {
                    HapticFeedback.selectionClick();
                    setState(() => _blueControl = v);
                  },
                  onFactionChanged: (v) {
                    HapticFeedback.selectionClick();
                    setState(() => _blueFaction = v);
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: _CenterColumn(
                  round: _round,
                  onRoundChanged: (v) {
                    HapticFeedback.selectionClick();
                    setState(() => _round = v);
                  },
                  onResetCounters: _confirmResetCounters,
                  onNewGame: _confirmNewGame,
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
                  onControlChanged: (v) {
                    HapticFeedback.selectionClick();
                    setState(() => _redControl = v);
                  },
                  onFactionChanged: (v) {
                    HapticFeedback.selectionClick();
                    setState(() => _redFaction = v);
                  },
                ),
              ),
            ],
          ),
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
                    onPressed:
                        round > 1 ? () => onRoundChanged(round - 1) : null,
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
