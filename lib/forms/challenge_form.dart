import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/challenge_provider.dart';


class ChallengeFormPopup extends ConsumerWidget {
  const ChallengeFormPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstArticle = ref.watch(firstArticleProvider);
    final preposition = ref.watch(prepositionProvider);
    final secondArticle = ref.watch(secondArticleProvider);
    final firstWord = ref.watch(firstWordProvider);
    final secondWord = ref.watch(secondWordProvider);
    final forbiddenWords = ref.watch(forbiddenWordsProvider);

    final forbiddenWordController = TextEditingController();

    void addForbiddenWord() {
      if (forbiddenWordController.text.isNotEmpty) {
        ref
            .read(forbiddenWordsProvider.notifier)
            .update((state) => [...state, forbiddenWordController.text]);
        forbiddenWordController.clear();
      }
    }

    void removeForbiddenWord(int index) {
      ref
          .read(forbiddenWordsProvider.notifier)
          .update((state) => state..removeAt(index));
    }

    void submitForm() {
      if (firstWord.isNotEmpty && secondWord.isNotEmpty) {
        final challenge =
            "$firstArticle $firstWord $preposition $secondArticle $secondWord";
        final forbiddenWordsList = List<String>.from(forbiddenWords);
        final fullChallenge =
            "$challenge | Interdits : ${forbiddenWordsList.join(', ')}";

        ref.read(challengesProvider.notifier).addChallenge(fullChallenge);
        Navigator.of(context).pop();
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
            // Premier bouton UN/UNE
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
            // Champ texte pour le premier mot
            TextField(
              onChanged: (value) =>
              ref.read(firstWordProvider.notifier).state = value,
              decoration: const InputDecoration(
                hintText: 'Votre premier mot',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Deuxième bouton SUR/DANS
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
            // Troisième bouton UN/UNE
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
            // Champ texte pour le deuxième mot
            TextField(
              onChanged: (value) =>
              ref.read(secondWordProvider.notifier).state = value,
              decoration: const InputDecoration(
                hintText: 'Votre deuxième mot',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Gestion des mots interdits
            const Text('Mots interdits'),
            Wrap(
              children: forbiddenWords
                  .asMap()
                  .entries
                  .map((entry) => Chip(
                label: Text(entry.value),
                onDeleted: () => removeForbiddenWord(entry.key),
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
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: addForbiddenWord,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Bouton Ajouter
            ElevatedButton(
              onPressed: submitForm,
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour construire un bouton de bascule
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
