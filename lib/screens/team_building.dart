import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:m2dfs_bauchot_pictionary/screens/start_game.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:m2dfs_bauchot_pictionary/utils/theme.dart';
import 'package:m2dfs_bauchot_pictionary/models/Player.dart';
import 'package:m2dfs_bauchot_pictionary/providers/team_provider.dart';
import 'package:m2dfs_bauchot_pictionary/utils/players_service.dart';
import 'package:m2dfs_bauchot_pictionary/screens/challenge_creation.dart';
import 'package:m2dfs_bauchot_pictionary/providers/game_status_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// A widget that represents the team building screen.
class TeamBuilding extends ConsumerWidget {
  /// The ID of the game.
  final String gameId;

  /// The name of the player.
  final dynamic playerName;

  /// Creates a new TeamBuilding instance.
  ///
  /// - Parameters:
  ///   - key: An optional key for the widget.
  ///   - gameId: The ID of the game.
  ///   - playerName: The name of the player.
  const TeamBuilding({
    super.key,
    required this.gameId,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamState = ref.watch(teamProvider);
    final gameStatusNotifier = ref.read(gameStatusProvider.notifier);
    final PlayersService playersService = PlayersService();

    ref.listen(gameStatusProvider, (previous, next) {
      if (next == 'lobby') {
        gameStatusNotifier.fetchGameStatus(gameId);
      }
    });

    final gameStatus = ref.watch(gameStatusProvider);

    if (gameStatus.startsWith('error')) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: Center(child: Text(gameStatus)),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimationLimiter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: <Widget>[
                    Text(
                      'Team Building',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: PrettyQr(
                        data: gameId,
                        errorCorrectLevel: QrErrorCorrectLevel.M,
                        size: 200,
                        roundEdges: true,
                        elementColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTeamContainer('Red Team', teamState.teamRed, Colors.red),
                    const SizedBox(height: 20),
                    _buildTeamContainer('Blue Team', teamState.teamBlue, Colors.blue),
                    const SizedBox(height: 20),
                    Text(
                      'Waiting for players to join... 🕒\n'
                          'Share the game code with your friends to invite them to join your team!',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Button "Create a Challenge"
                    _buildButton(
                      label: 'Create a Challenge',
                      icon: Icons.play_arrow,
                      color: AppTheme.primaryBlue,
                      onTap: () async {
                        try {
                          await gameStatusNotifier.startGameSession(gameId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChallengesScreen(gameId: gameId)),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    // Button "Leave Game"
                    _buildButton(
                      label: 'Leave Game',
                      icon: Icons.exit_to_app,
                      color: Colors.red,
                      onTap: () async {
                        try {
                          await playersService.leaveGame(gameId);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const StartGame()),
                                (route) => false,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the app bar for the screen.
  ///
  /// - Returns: A PreferredSizeWidget representing the app bar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => debugPrint('Back disabled'),
      ),
      title: Text(
        'Team Building',
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
    );
  }

  /// Builds a container widget for a team.
  ///
  /// - Parameters:
  ///   - teamName: The name of the team.
  ///   - teamMembers: The list of team members.
  ///   - color: The color associated with the team.
  ///
  /// - Returns: A Widget representing the team container.
  Widget _buildTeamContainer(String teamName, List<Player> teamMembers, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
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
            style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          ...teamMembers.map((player) => Text(
            player.name,
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
          )),
        ],
      ),
    );
  }

  /// Builds a button widget.
  ///
  /// - Parameters:
  ///   - label: The text to display on the button.
  ///   - icon: The icon to display on the button.
  ///   - color: The background color of the button.
  ///   - onTap: The callback to invoke when the button is tapped.
  ///
  /// - Returns: A Widget representing the button.
  Widget _buildButton({required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}