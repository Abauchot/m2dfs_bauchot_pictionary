// lib/screens/team_building.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:m2dfs_bauchot_pictionary/utils/theme.dart';
import 'package:m2dfs_bauchot_pictionary/models/Player.dart';
import 'package:m2dfs_bauchot_pictionary/providers/team_provider.dart';

class TeamBuilding extends ConsumerWidget {
  final String gameId;

  const TeamBuilding({
    super.key,
    required this.gameId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamState = ref.watch(teamProvider);
    print('Building TeamBuilding screen with gameId: $gameId');
    print('Current team state: $teamState');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Building'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Team Building',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 10),
              PrettyQr(
                data: gameId,
                errorCorrectLevel: QrErrorCorrectLevel.M,
                size: 200,
                roundEdges: true,
                elementColor: AppTheme.whiteText,
              ),
              const SizedBox(height: 20),
              _buildTeamContainer(
                context,
                'Red Team',
                teamState.teamRed,
                Colors.red,
              ),
              const SizedBox(height: 20),
              _buildTeamContainer(
                context,
                'Blue Team',
                teamState.teamBlue,
                Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                'Waiting for players to join... 🕒\n'
                    'Share the game code with your friends to invite them to join your team!',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamContainer(
      BuildContext context,
      String teamName,
      List<Player> teamMembers,
      Color color,
      ) {
    print('Building team container for $teamName with members: $teamMembers');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            teamName,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppTheme.whiteText,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          ...teamMembers.map((player) => Text(
            player.name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.whiteText,
              fontSize: 18,
            ),
          )),
        ],
      ),
    );
  }
}