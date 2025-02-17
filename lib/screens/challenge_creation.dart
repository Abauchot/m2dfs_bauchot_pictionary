// lib/screens/challenge_creation.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m2dfs_bauchot_pictionary/providers/challenge_provider.dart';
import 'package:m2dfs_bauchot_pictionary/forms/challenge_form.dart';
import 'package:m2dfs_bauchot_pictionary/providers/game_status_provider.dart';
import 'package:m2dfs_bauchot_pictionary/screens/challenge_guess.dart' as guess;

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
      gameStatusNotifier.setChallengeStatus(gameId);
    });

    final gameStatus = ref.watch(gameStatusProvider);


    if (gameStatus.startsWith('error')) {
      return Scaffold(
        appBar: AppBar(title: const Text('Saisie des challenges')),
        body: Center(child: Text(gameStatus)),
      );
    }


    Future<void> sendAllChallenges() async {
      final gameStatusNotifier = ref.read(gameStatusProvider.notifier);

      // ✅ Passer en mode challenge
      await gameStatusNotifier.setChallengeStatus(gameId);

      ref.read(challengesProvider.notifier).selectAndSendRandomChallenge(gameId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Challenges envoyés. Attente du mode dessin...')),
      );

      // ✅ Attendre que la session passe en mode "drawing"
      await gameStatusNotifier.waitForDrawingPhase(gameId);

      // 🔹 Vérifier le statut avant de naviguer
      final updatedStatus = ref.read(gameStatusProvider);

      if (updatedStatus == "drawing") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => guess.ChallengePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('🚨 Erreur lors du passage en mode dessin')),
        );
      }
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
                    subtitle: Text('${challenge.firstWord} ${challenge.secondWord} ${challenge.thirdWord} ${challenge.fourthWord} ${challenge.fifthWord}'),
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
          builder: (context) => const ChallengeFormPopup(gameId: 'gameId',),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}