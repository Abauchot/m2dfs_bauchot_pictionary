//challenge model
import 'dart:convert';

import 'package:uuid/uuid.dart';

class Challenge {
  final String id;
  final String firstWord;
  final String secondWord;
  final String thirdWord;
  final String fourthWord;
  final String fifthWord;
  final List<String> forbiddenWords;
  String? imageUrl;

  Challenge({
    String? id,
    required this.firstWord,
    required this.secondWord,
    required this.thirdWord,
    required this.fourthWord,
    required this.fifthWord,
    required dynamic forbiddenWords,
    this.imageUrl,
  }) : id = id ?? const Uuid().v4(),
       forbiddenWords = _parseForbiddenWords(forbiddenWords);

  static List<String> _parseForbiddenWords(dynamic input) {
    if (input is String) {
      try {
        return List<String>.from(jsonDecode(input));
      } catch (e) {
        return [];
      }
    } else if (input is List) {
      return List<String>.from(input);
    }
    return [];
  }

  String generatePrompt() {
    return '$firstWord $secondWord $thirdWord $fourthWord $fifthWord';
  }

  String generateCleanPrompt() {
    String prompt = '$firstWord $secondWord $thirdWord $fourthWord $fifthWord'.toLowerCase();

    for (String word in forbiddenWords) {
      String lowerWord = word.toLowerCase();
      if (prompt.contains(lowerWord)) {
        prompt = prompt.replaceAll(RegExp("\\b$lowerWord\\b", caseSensitive: false), "***");
      }
    }
    return prompt;
  }

}
