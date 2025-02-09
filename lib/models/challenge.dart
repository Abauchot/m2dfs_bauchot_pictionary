class Challenge {
  final String firstWord;
  final String secondWord;
  final String thirdWord;
  final String fourthWord;
  final String fifthWord;
  final List<String> forbiddenWords;

  Challenge({
    required this.firstWord,
    required this.secondWord,
    required this.thirdWord,
    required this.fourthWord,
    required this.fifthWord,
    required this.forbiddenWords,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_word": firstWord,
      "second_word": secondWord,
      "third_word": thirdWord,
      "fourth_word": fourthWord,
      "fifth_word": fifthWord,
      "forbidden_words": forbiddenWords,
    };
  }
}