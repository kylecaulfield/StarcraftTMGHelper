class GameSettings {
  final int startingControlPoints;
  final int startingFactionPoints;
  final int startingRound;
  final int victoryThreshold;

  const GameSettings({
    required this.startingControlPoints,
    required this.startingFactionPoints,
    required this.startingRound,
    required this.victoryThreshold,
  });

  factory GameSettings.defaults() => const GameSettings(
        startingControlPoints: 0,
        startingFactionPoints: 0,
        startingRound: 1,
        victoryThreshold: 15,
      );

  GameSettings copyWith({
    int? startingControlPoints,
    int? startingFactionPoints,
    int? startingRound,
    int? victoryThreshold,
  }) {
    return GameSettings(
      startingControlPoints:
          startingControlPoints ?? this.startingControlPoints,
      startingFactionPoints:
          startingFactionPoints ?? this.startingFactionPoints,
      startingRound: startingRound ?? this.startingRound,
      victoryThreshold: victoryThreshold ?? this.victoryThreshold,
    );
  }
}
