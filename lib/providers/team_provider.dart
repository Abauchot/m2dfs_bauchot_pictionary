import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m2dfs_bauchot_pictionary/models/Player.dart';

/// Represents the state of the teams in the game.
class TeamState {
  /// The list of players in the red team.
  final List<Player> teamRed;

  /// The list of players in the blue team.
  final List<Player> teamBlue;

  /// Creates a new TeamState instance.
  ///
  /// - Parameters:
  ///   - teamRed: The list of players in the red team.
  ///   - teamBlue: The list of players in the blue team.
  TeamState({
    required this.teamRed,
    required this.teamBlue,
  });

  /// Creates an initial TeamState with empty teams.
  ///
  /// - Returns: A new TeamState instance with empty red and blue teams.
  factory TeamState.initial() {
    return TeamState(
      teamRed: [],
      teamBlue: [],
    );
  }

  /// Creates a copy of the current TeamState with optional new values.
  ///
  /// - Parameters:
  ///   - teamRed: The new list of players for the red team.
  ///   - teamBlue: The new list of players for the blue team.
  ///
  /// - Returns: A new TeamState instance with the updated values.
  TeamState copyWith({
    List<Player>? teamRed,
    List<Player>? teamBlue,
  }) {
    return TeamState(
      teamRed: teamRed ?? this.teamRed,
      teamBlue: teamBlue ?? this.teamBlue,
    );
  }
}

/// A state notifier for managing the team state.
class TeamNotifier extends StateNotifier<TeamState> {
  /// Creates a TeamNotifier with an initial empty team state.
  TeamNotifier() : super(TeamState.initial());

  /// Adds a player to the specified team.
  ///
  /// - Parameters:
  ///   - player: The player to add.
  ///   - teamColor: The color of the team ('red' or 'blue').
  void addPlayerToTeam(Player player, String teamColor) {
    if (teamColor == 'red') {
      state = state.copyWith(
        teamRed: [...state.teamRed, player],
      );
    } else if (teamColor == 'blue') {
      state = state.copyWith(
        teamBlue: [...state.teamBlue, player],
      );
    }
  }
}

/// Provides the team state notifier.
final teamProvider = StateNotifierProvider<TeamNotifier, TeamState>(
      (ref) => TeamNotifier(),
);