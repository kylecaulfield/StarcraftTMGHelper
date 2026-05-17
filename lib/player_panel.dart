import 'package:flutter/material.dart';

class PlayerPanel extends StatelessWidget {
  final String name;
  final Color color;
  final Color accentColor;
  final int controlPoints;
  final int factionPoints;
  final int victoryThreshold;
  final ValueChanged<int> onControlChanged;
  final ValueChanged<int> onFactionChanged;

  const PlayerPanel({
    super.key,
    required this.name,
    required this.color,
    required this.accentColor,
    required this.controlPoints,
    required this.factionPoints,
    required this.victoryThreshold,
    required this.onControlChanged,
    required this.onFactionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final reachedVictory = factionPoints >= victoryThreshold;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withOpacity(0.25),
            color.withOpacity(0.08),
          ],
        ),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                  color: accentColor,
                ),
              ),
              if (reachedVictory) ...[
                const SizedBox(width: 12),
                const Icon(Icons.emoji_events, color: Colors.amber, size: 36),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: _CounterCard(
                    label: 'CONTROL POINTS',
                    value: controlPoints,
                    color: color,
                    onChanged: onControlChanged,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _CounterCard(
                    label: 'FACTION POINTS',
                    value: factionPoints,
                    color: color,
                    onChanged: onFactionChanged,
                    badge: '$factionPoints / $victoryThreshold',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CounterCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final ValueChanged<int> onChanged;
  final String? badge;

  const _CounterCard({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: Colors.white70,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _StepButton(
                    icon: Icons.remove,
                    color: color,
                    onPressed:
                        value > 0 ? () => onChanged(value - 1) : null,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$value',
                        style: const TextStyle(
                          fontSize: 160,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _StepButton(
                    icon: Icons.add,
                    color: color,
                    onPressed: () => onChanged(value + 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  const _StepButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: onPressed == null
            ? Colors.white.withOpacity(0.05)
            : color.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Icon(
              icon,
              size: 64,
              color: onPressed == null ? Colors.white24 : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
