class Challenge {
  String firstWord;
  String secondWord;
  String description;
  String forbidden1;
  String forbidden2;
  String forbidden3;

  Challenge({
    required this.firstWord,
    required this.secondWord,
    this.description = '',
    this.forbidden1 = '',
    this.forbidden2 = '',
    this.forbidden3 = '',
  });


  String validate() {
    if (firstWord.isEmpty || secondWord.isEmpty) {
      return "Words can't be empty.";
    }
    if ([forbidden1, forbidden2, forbidden3].contains(firstWord) ||
        [forbidden1, forbidden2, forbidden3].contains(secondWord)) {
      return "Forbidden words can't be the same as the main word.";
    }
    return '';
  }
}
