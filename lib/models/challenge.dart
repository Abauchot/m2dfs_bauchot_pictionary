class Challenge {
  final String firstWord;
  final String secondWord;
  final String description;
  final String forbidden1;
  final String forbidden2;
  final String forbidden3;
  final String errorMessage;

  Challenge({
    required this.firstWord,
    required this.secondWord,
    this.description = '',
    this.forbidden1 = '',
    this.forbidden2 = '',
    this.forbidden3 = '',
    this.errorMessage = '',
  });

  Challenge copyWith({
    String? firstWord,
    String? secondWord,
    String? description,
    String? forbidden1,
    String? forbidden2,
    String? forbidden3,
    String? errorMessage,
  }) {
    return Challenge(
      firstWord: firstWord ?? this.firstWord,
      secondWord: secondWord ?? this.secondWord,
      description: description ?? this.description,
      forbidden1: forbidden1 ?? this.forbidden1,
      forbidden2: forbidden2 ?? this.forbidden2,
      forbidden3: forbidden3 ?? this.forbidden3,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}