/// A class representing a game with various attributes.
class Game {
  /// The unique identifier of the game.
  final int id;

  /// The start time of the current game phase.
  final DateTime? gamePhaseStartTime;

  /// The unique identifier of the player.
  final int playerId;

  /// The status of the game.
  final String status;

  /// The list of player IDs in the blue team.
  final List<int> blueTeam;

  /// The list of player IDs in the red team.
  final List<int> redTeam;

  /// The list of challenges in the game.
  final List<dynamic> challenges;

  /// Creates a new Game instance.
  ///
  /// - Parameters:
  ///   - id: The unique identifier of the game.
  ///   - gamePhaseStartTime: The start time of the current game phase.
  ///   - playerId: The unique identifier of the player.
  ///   - status: The status of the game.
  ///   - blueTeam: The list of player IDs in the blue team.
  ///   - redTeam: The list of player IDs in the red team.
  ///   - challenges: The list of challenges in the game.
  Game({
    required this.id,
    this.gamePhaseStartTime,
    required this.playerId,
    required this.status,
    required this.blueTeam,
    required this.redTeam,
    required this.challenges,
  });

  /// Creates a new Game instance from a JSON object.
  ///
  /// - Parameters:
  ///   - json: A Map representing the JSON object.
  ///
  /// - Returns: A new Game instance.
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      gamePhaseStartTime: json['game_phase_start_time'] != null
          ? DateTime.parse(json['game_phase_start_time'])
          : null,
      playerId: json['player_id'],
      status: json['status'],
      blueTeam: List<int>.from(json['blue_team']),
      redTeam: List<int>.from(json['red_team']),
      challenges: List<dynamic>.from(json['challenges']),
    );
  }

  /// Converts the Game instance to a JSON object.
  ///
  /// - Returns: A Map representing the JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_phase_start_time': gamePhaseStartTime?.toIso8601String(),
      'player_id': playerId,
      'status': status,
      'blue_team': blueTeam,
      'red_team': redTeam,
      'challenges': challenges,
    };
  }
}