import 'package:flutter/material.dart';

import 'game_settings.dart';

class SettingsScreen extends StatefulWidget {
  final GameSettings initialSettings;
  final ValueChanged<GameSettings> onStart;

  const SettingsScreen({
    super.key,
    required this.initialSettings,
    required this.onStart,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _startingControlPoints;
  late int _startingFactionPoints;
  late int _startingRound;
  late int _victoryThreshold;

  @override
  void initState() {
    super.initState();
    _startingControlPoints = widget.initialSettings.startingControlPoints;
    _startingFactionPoints = widget.initialSettings.startingFactionPoints;
    _startingRound = widget.initialSettings.startingRound;
    _victoryThreshold = widget.initialSettings.victoryThreshold;
  }

  void _start() {
    widget.onStart(GameSettings(
      startingControlPoints: _startingControlPoints,
      startingFactionPoints: _startingFactionPoints,
      startingRound: _startingRound,
      victoryThreshold: _victoryThreshold,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Starcraft TMG Helper',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'New game setup',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _SettingRow(
                    label: 'Starting Control Points',
                    value: _startingControlPoints,
                    min: 0,
                    onChanged: (v) =>
                        setState(() => _startingControlPoints = v),
                  ),
                  _SettingRow(
                    label: 'Starting Faction Points',
                    value: _startingFactionPoints,
                    min: 0,
                    onChanged: (v) =>
                        setState(() => _startingFactionPoints = v),
                  ),
                  _SettingRow(
                    label: 'Starting Round',
                    value: _startingRound,
                    min: 1,
                    onChanged: (v) => setState(() => _startingRound = v),
                  ),
                  _SettingRow(
                    label: 'Victory Threshold (Faction Points)',
                    value: _victoryThreshold,
                    min: 1,
                    step: 1,
                    onChanged: (v) => setState(() => _victoryThreshold = v),
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: _start,
                    icon: const Icon(Icons.play_arrow, size: 28),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'Start Game',
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int step;
  final ValueChanged<int> onChanged;

  const _SettingRow({
    required this.label,
    required this.value,
    required this.min,
    required this.onChanged,
    this.step = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 18),
            ),
          ),
          IconButton.filledTonal(
            onPressed:
                value > min ? () => onChanged((value - step).clamp(min, 999)) : null,
            iconSize: 28,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 64,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton.filledTonal(
            onPressed: () => onChanged(value + step),
            iconSize: 28,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
