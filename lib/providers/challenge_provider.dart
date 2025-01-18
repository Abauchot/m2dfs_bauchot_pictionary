import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge.dart';

class ChallengeNotifier extends StateNotifier<Challenge> {
  ChallengeNotifier() : super(Challenge(firstWord: '', secondWord: ''));

  void updateFirstWord(String value) {
    state = state.copyWith(firstWord: value);
  }

  void updateSecondWord(String value) {
    state = state.copyWith(secondWord: value);
  }

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  void updateForbidden1(String value) {
    state = state.copyWith(forbidden1: value);
  }

  void updateForbidden2(String value) {
    state = state.copyWith(forbidden2: value);
  }

  void updateForbidden3(String value) {
    state = state.copyWith(forbidden3: value);
  }

  void setErrorMessage(String value) {
    state = state.copyWith(errorMessage: value);
  }
}

final challengeProvider = StateNotifierProvider<ChallengeNotifier, Challenge>((ref) {
  return ChallengeNotifier();
});