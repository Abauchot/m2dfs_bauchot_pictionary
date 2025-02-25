//challenge_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge.dart';
import '../providers/challenge_provider.dart';

/// A widget that displays a popup dialog for adding a challenge.
class ChallengeFormPopup extends ConsumerWidget {
  /// The ID of the game for which the challenge is being added.
  final String gameId;

  /// Creates a ChallengeFormPopup widget.
  const ChallengeFormPopup({super.key, required this.gameId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the state of various providers.
    final firstArticle = ref.watch(firstArticleProvider);
    final preposition = ref.watch(prepositionProvider);
    final secondArticle = ref.watch(secondArticleProvider);
    final firstWord = ref.watch(firstWordProvider);
    final secondWord = ref.watch(secondWordProvider);
    final forbiddenWords = ref.watch(forbiddenWordsProvider);

    // Controller for the forbidden words text field.
    final forbiddenWordController = TextEditingController();

    /// Adds a forbidden word to the list.
    void addForbiddenWord() {
      if (forbiddenWordController.text.isNotEmpty) {
        ref
            .read(forbiddenWordsProvider.notifier)
            .update((state) => [...state, forbiddenWordController.text]);
        forbiddenWordController.clear();
      }
    }

    /// Removes a forbidden word from the list at the specified index.
    void removeForbiddenWord(WidgetRef ref, int index) {
      ref.read(forbiddenWordsProvider.notifier).update((state) => [...state]..removeAt(index));
    }

    /// Submits the form and adds a challenge.
    void submitForm(String gameId) {
      if (firstWord.isNotEmpty && secondWord.isNotEmpty) {
        final challenge = Challenge(
          firstWord: firstArticle,
          secondWord: firstWord,
          thirdWord: preposition,
          fourthWord: secondArticle,
          fifthWord: secondWord,
          forbiddenWords: forbiddenWords.length >= 3
              ? List<String>.from(forbiddenWords)
              : ["motInterdit1", "motInterdit2", "motInterdit3"],
        );

        ref.read(challengesProvider.notifier).addChallenge(challenge);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez remplir tous les champs'),
          ),
        );
      }
    }

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ajout d’un challenge',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // First toggle button for UN/UNE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildToggleButton("UN", firstArticle == "UN", () {
                  ref.read(firstArticleProvider.notifier).state = "UN";
                }),
                _buildToggleButton("UNE", firstArticle == "UNE", () {
                  ref.read(firstArticleProvider.notifier).state = "UNE";
                }),
              ],
            ),
            const SizedBox(height: 8),
            // Text field for the first word
            TextField(
              onChanged: (value) =>
              ref.read(firstWordProvider.notifier).state = value,
              decoration: const InputDecoration(
                hintText: 'Votre premier mot',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            // Second toggle button for SUR/DANS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildToggleButton("SUR", preposition == "SUR", () {
                  ref.read(prepositionProvider.notifier).state = "SUR";
                }),
                _buildToggleButton("DANS", preposition == "DANS", () {
                  ref.read(prepositionProvider.notifier).state = "DANS";
                }),
              ],
            ),
            const SizedBox(height: 8),
            // Third toggle button for UN/UNE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildToggleButton("UN", secondArticle == "UN", () {
                  ref.read(secondArticleProvider.notifier).state = "UN";
                }),
                _buildToggleButton("UNE", secondArticle == "UNE", () {
                  ref.read(secondArticleProvider.notifier).state = "UNE";
                }),
              ],
            ),
            const SizedBox(height: 8),
            // Text field for the second word
            TextField(
              onChanged: (value) =>
              ref.read(secondWordProvider.notifier).state = value,
              decoration: const InputDecoration(
                hintText: 'Votre deuxième mot',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.black), // Black color
            ),
            const SizedBox(height: 16),
            // Forbidden words management
            const Text('Mots interdits'),
            Wrap(
              children: forbiddenWords
                  .asMap()
                  .entries
                  .map((entry) => Chip(
                label: Text(entry.value),
                onDeleted: () => removeForbiddenWord(ref,entry.key),
              ))
                  .toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: forbiddenWordController,
                    decoration: const InputDecoration(
                      hintText: 'Ajouter un mot interdit',
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(color: Colors.black), // Black color
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addForbiddenWord,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Add button
            ElevatedButton(
              onPressed: () => submitForm(gameId),
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a toggle button with the specified label, selection state, and tap callback.
  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}