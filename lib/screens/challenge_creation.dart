// lib/screens/challenge_creation.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m2dfs_bauchot_pictionary/providers/challenge_provider.dart';
import 'package:m2dfs_bauchot_pictionary/forms/challenge_form.dart';
import 'package:m2dfs_bauchot_pictionary/providers/game_status_provider.dart';
import 'package:m2dfs_bauchot_pictionary/screens/challenge_guess.dart' as guess; // Import the challenge_guess.dart file

class ChallengesScreen extends ConsumerWidget {
  final String gameId;

  const ChallengesScreen({
    super.key,
    required this.gameId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(challengesProvider);
    final gameStatusNotifier = ref.read(gameStatusProvider.notifier);

    Future(() {
      gameStatusNotifier.setChallengeStatus();
    });

    final gameStatus = ref.watch(gameStatusProvider);

    print('Building Challenges screen with gameId: $gameId');
    print('Current challenges: $challenges');
    print('Current game status: $gameStatus');

    if (gameStatus.startsWith('error')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Saisie des challenges')),
        body: Center(child: Text(gameStatus)),
      );
    }

    void sendAllChallenges() {
      print('Sending all challenges...');
      gameStatusNotifier.setDrawingStatus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All challenges sent')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => guess.ChallengePage()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Saisie des challenges')),
      body: challenges.isEmpty
          ? const Center(child: Text('Aucun challenge ajouté'))
          : Column(
        children: [
          if (challenges.length < 3)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'You need to enter at least 3 challenges to start the game',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                return Card(
                  child: ListTile(
                    title: Text('Challenge #${index + 1}'),
                    subtitle: Text(challenge),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        ref
                            .read(challengesProvider.notifier)
                            .removeChallenge(index);
                      },
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
                child: const Text('Send All Challenges'),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => guess.ChallengePage()),
                );
              },
              child: const Text('Go to Challenge Guess Screen'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const ChallengeFormPopup(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}