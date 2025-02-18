//challenge model
import 'dart:convert';

import 'package:uuid/uuid.dart';

/// A class representing a challenge with words and forbidden words.
class Challenge {
  /// The unique identifier of the challenge.
  final String id;

  /// The first word of the challenge.
  final String firstWord;

  /// The second word of the challenge.
  final String secondWord;

  /// The third word of the challenge.
  final String thirdWord;

  /// The fourth word of the challenge.
  final String fourthWord;

  /// The fifth word of the challenge.
  final String fifthWord;

  /// The list of forbidden words for the challenge.
  final List<String> forbiddenWords;

  /// The URL of the image associated with the challenge.
  String? imageUrl;

  /// Creates a new Challenge instance.
  ///
  /// If [id] is not provided, a new unique identifier is generated.
  /// The [forbiddenWords] parameter can be a JSON string or a list of strings.
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

  /// Parses the forbidden words from a JSON string or a list.
  ///
  /// Returns an empty list if the input is invalid.
  ///
  /// - Parameters:
  ///   - input: The input to parse, which can be a JSON string or a list.
  ///
  /// - Returns: A list of forbidden words.
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

  /// Generates a prompt string by concatenating the five words.
  ///
  /// - Returns: A string containing the five words separated by spaces.
  String generatePrompt() {
    return '$firstWord $secondWord $thirdWord $fourthWord $fifthWord';
  }

  /// Generates a clean prompt string by replacing forbidden words with "***".
  ///
  /// The prompt is converted to lowercase, and each forbidden word is replaced
  /// with "***" if it is found in the prompt.
  ///
  /// - Returns: A string containing the clean prompt.
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