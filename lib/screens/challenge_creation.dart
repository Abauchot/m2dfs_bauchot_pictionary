import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m2dfs_bauchot_pictionary/providers/challenge_provider.dart';
import 'package:m2dfs_bauchot_pictionary/forms/challenge_form.dart';

class ChallengesScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(challengesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saisie des challenges')),
      body: challenges.isEmpty
          ? const Center(child: Text('Aucun challenge ajouté'))
          : ListView.builder(
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
                  ref.read(challengesProvider.notifier).removeChallenge(index);
                },
              ),
            ),
          );
        },
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