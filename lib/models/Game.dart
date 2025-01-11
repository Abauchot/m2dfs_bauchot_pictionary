//lib/models/Game.dart
class Game {
  final int id;
  final DateTime? gamePhaseStartTime;
  final int playerId;
  final String status;
  final List<int> blueTeam;
  final List<int> redTeam;
  final List<dynamic> challenges;

  Game({
    required this.id,
    this.gamePhaseStartTime,
    required this.playerId,
    required this.status,
    required this.blueTeam,
    required this.redTeam,
    required this.challenges,
  });

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