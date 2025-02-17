// lib/providers/team_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m2dfs_bauchot_pictionary/models/Player.dart';
class TeamState {
  final List<Player> teamRed;
  final List<Player> teamBlue;

  TeamState({
    required this.teamRed,
    required this.teamBlue,
  });

  factory TeamState.initial() {
    return TeamState(
      teamRed: [],
      teamBlue: [],
    );
  }

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

class TeamNotifier extends StateNotifier<TeamState> {
  TeamNotifier() : super(TeamState.initial());

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



final teamProvider = StateNotifierProvider<TeamNotifier, TeamState>(
      (ref) => TeamNotifier(),

);