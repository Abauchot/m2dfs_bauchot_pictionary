import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m2dfs_bauchot_pictionary/providers/challenge_provider.dart';

class ChallengeForm extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenge = ref.watch(challengeProvider);
    final challengeNotifier = ref.read(challengeProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Premier mot'),
          style: const TextStyle(color: Colors.black), // Set text color to black
          onChanged: (value) {
            challengeNotifier.updateFirstWord(value);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                challengeNotifier.updateDescription('${challenge.description} UN');
              },
              style: Theme.of(context).elevatedButtonTheme.style,
              child: const Text('UN'), // Apply the custom style
            ),
            ElevatedButton(
              onPressed: () {
                challengeNotifier.updateDescription('${challenge.description} UNE');
              },
              style: Theme.of(context).elevatedButtonTheme.style,
              child: const Text('UNE'), // Apply the custom style
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                challengeNotifier.updateDescription('SUR');
              },
              style: Theme.of(context).elevatedButtonTheme.style,
              child: const Text('SUR'), // Apply the custom style
            ),
            ElevatedButton(
              onPressed: () {
                challengeNotifier.updateDescription('DANS');
              },
              style: Theme.of(context).elevatedButtonTheme.style,
              child: const Text('DANS'), // Apply the custom style
            ),
          ],
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Deuxième mot'),
          style: const TextStyle(color: Colors.black), // Set text color to black
          onChanged: (value) {
            challengeNotifier.updateSecondWord(value);
          },
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Mot interdit 1'),
          style: const TextStyle(color: Colors.black), // Set text color to black
          onChanged: (value) {
            challengeNotifier.updateForbidden1(value);
          },
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Mot interdit 2'),
          style: const TextStyle(color: Colors.black), // Set text color to black
          onChanged: (value) {
            challengeNotifier.updateForbidden2(value);
          },
        ),
        TextField(
          decoration: const InputDecoration(labelText: 'Mot interdit 3'),
          style: const TextStyle(color: Colors.black), // Set text color to black
          onChanged: (value) {
            challengeNotifier.updateForbidden3(value);
          },
        ),
        if (challenge.errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              challenge.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}