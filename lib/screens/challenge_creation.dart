import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:m2dfs_bauchot_pictionary/providers/challenge_provider.dart';
import 'package:m2dfs_bauchot_pictionary/forms/challenge_form.dart';
import 'package:m2dfs_bauchot_pictionary/providers/game_status_provider.dart';
import 'package:m2dfs_bauchot_pictionary/screens/challenge_guess.dart' as guess;

/// A screen for managing and creating challenges in the game.
class ChallengesScreen extends ConsumerWidget {
  /// The ID of the game session.
  final String gameId;

  /// Creates a new ChallengesScreen instance.
  ///
  /// - Parameters:
  ///   - key: An optional key for the widget.
  ///   - gameId: The ID of the game session.
  const ChallengesScreen({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(challengesProvider);
    final gameStatusNotifier = ref.read(gameStatusProvider.notifier);

    Future(() {
      gameStatusNotifier.setChallengeStatus(gameId);
    });

    final gameStatus = ref.watch(gameStatusProvider);

    if (gameStatus.startsWith('error')) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: Center(child: Text(gameStatus, style: GoogleFonts.poppins())),
      );
    }

    /// Sends all challenges to the server and waits for the drawing phase.
    ///
    /// - Returns: A Future that completes when the operation is done.
    Future<void> sendAllChallenges() async {
      await gameStatusNotifier.setChallengeStatus(gameId);
      ref.read(challengesProvider.notifier).selectAndSendRandomChallenge(gameId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Challenges sent. Waiting for drawing phase...', style: GoogleFonts.poppins())),
      );

      await gameStatusNotifier.waitForDrawingPhase(gameId);

      final updatedStatus = ref.read(gameStatusProvider);

      if (updatedStatus == "drawing") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => guess.ChallengePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🚨 Error switching to drawing mode', style: GoogleFonts.poppins())),
        );
      }
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (challenges.isEmpty)
            Center(child: Text('No challenges added yet', style: GoogleFonts.poppins(fontSize: 16))),
          Expanded(
            child: ListView.builder(
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                return Card(
                  child: ListTile(
                    title: Text('Challenge #${index + 1}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${challenge.firstWord} ${challenge.secondWord} ${challenge.thirdWord} '
                          '${challenge.fourthWord} ${challenge.fifthWord}',
                      style: GoogleFonts.poppins(),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => ref.read(challengesProvider.notifier).removeChallenge(index),
                    ),
                  ),
                );
              },
            ),
          ),
          if (challenges.length >= 3)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: sendAllChallenges,
                child: Text('Send All Challenges', style: GoogleFonts.poppins(fontSize: 16)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => guess.ChallengePage()));
              },
              child: Text('Go to Challenge Guess Screen', style: GoogleFonts.poppins(fontSize: 16)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ChallengeFormPopup(gameId: gameId),
        ),
        child: const Icon(Icons.add),
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
      title: Text(
        'Challenge Creation',
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
    );
  }
}