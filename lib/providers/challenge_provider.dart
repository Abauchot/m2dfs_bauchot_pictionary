import 'package:flutter_riverpod/flutter_riverpod.dart';

// Providers pour les états de la création du challenge
final firstArticleProvider = StateProvider<String>((ref) => "UNE");
final prepositionProvider = StateProvider<String>((ref) => "SUR");
final secondArticleProvider = StateProvider<String>((ref) => "UN");
final firstWordProvider = StateProvider<String>((ref) => "");
final secondWordProvider = StateProvider<String>((ref) => "");
final forbiddenWordsProvider = StateProvider<List<String>>((ref) => []);

// Liste globale des challenges
final challengesProvider = StateNotifierProvider<ChallengesNotifier, List<String>>((ref) {
  return ChallengesNotifier();
});

class ChallengesNotifier extends StateNotifier<List<String>> {
  ChallengesNotifier() : super([]);

  void addChallenge(String challenge) {
    state = [...state, challenge];
  }

  void removeChallenge(int index) {
    state = [...state]..removeAt(index);
  }



}
