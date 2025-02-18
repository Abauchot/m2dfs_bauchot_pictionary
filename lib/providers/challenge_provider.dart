//challenges_provider.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/challenge.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

/// Provides the first article state.
final firstArticleProvider = StateProvider<String>((ref) => "UNE");

/// Provides the preposition state.
final prepositionProvider = StateProvider<String>((ref) => "SUR");

/// Provides the second article state.
final secondArticleProvider = StateProvider<String>((ref) => "UN");

/// Provides the first word state.
final firstWordProvider = StateProvider<String>((ref) => "");

/// Provides the second word state.
final secondWordProvider = StateProvider<String>((ref) => "");

/// Provides the forbidden words state.
final forbiddenWordsProvider = StateProvider<List<String>>((ref) => []);

/// Provides the challenges state notifier.
final challengesProvider = StateNotifierProvider<ChallengesNotifier, List<Challenge>>((ref) {
  return ChallengesNotifier();
});

/// A state notifier for managing a list of challenges.
class ChallengesNotifier extends StateNotifier<List<Challenge>> {
  /// Creates a ChallengesNotifier with an initial empty list of challenges.
  ChallengesNotifier() : super([]);

  /// Adds a challenge to the list.
  ///
  /// - Parameters:
  ///   - challenge: The challenge to add.
  void addChallenge(Challenge challenge) {
    state = [...state, challenge];
  }

  /// Removes a challenge from the list by index.
  ///
  /// - Parameters:
  ///   - index: The index of the challenge to remove.
  void removeChallenge(int index) {
    state = [...state]..removeAt(index);
  }

  /// Selects a random challenge and sends it to the server.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game session.
  ///
  /// - Returns: A Future that completes when the operation is done.
  Future<void> selectAndSendRandomChallenge(String gameId) async {
    final apiUrl = dotenv.env['API_URL'];
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      return;
    }

    // Check the status of the session
    final statusUri = Uri.parse('$apiUrl/game_sessions/$gameId/status');
    final statusResponse = await http.get(statusUri, headers: {'Authorization': 'Bearer $token'});

    if (statusResponse.statusCode != 200) {
      return;
    }

    final statusData = jsonDecode(statusResponse.body);
    final String gameStatus = statusData['status'];

    if (gameStatus != "drawing") {
      return;
    }

    final myChallengesUri = Uri.parse('$apiUrl/game_sessions/$gameId/myChallenges');
    final myChallengesResponse = await http.get(
      myChallengesUri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (myChallengesResponse.statusCode != 200) {
      return;
    }

    final myChallengesData = jsonDecode(myChallengesResponse.body);
    if (myChallengesData.isEmpty) {
      return;
    }

    final chosenChallengeData = myChallengesData[Random().nextInt(myChallengesData.length)];
    final chosenChallenge = Challenge(
      id: chosenChallengeData['id'].toString(),
      firstWord: chosenChallengeData['first_word'],
      secondWord: chosenChallengeData['second_word'],
      thirdWord: chosenChallengeData['third_word'],
      fourthWord: chosenChallengeData['fourth_word'],
      fifthWord: chosenChallengeData['fifth_word'],
      forbiddenWords: List<String>.from(jsonDecode(chosenChallengeData['forbidden_words'])),
    );

    final drawUri = Uri.parse('$apiUrl/game_sessions/$gameId/challenges/${chosenChallenge.id}/draw');
    final drawResponse = await http.post(
      drawUri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"prompt": chosenChallenge.generatePrompt()}),
    );

    if (drawResponse.statusCode == 200) {
      final responseData = jsonDecode(drawResponse.body);
      chosenChallenge.imageUrl = responseData['image_url'];
    } else {
      // Handle error
    }
  }

  /// Registers a challenge with the server.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game session.
  ///   - challenge: The challenge to register.
  ///
  /// - Returns: A Future that completes with the registered challenge or null if registration failed.
  Future<Challenge?> registerChallenge(String gameId, Challenge challenge) async {
    final apiUrl = dotenv.env['API_URL'];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      return null;
    }

    final uri = Uri.parse('$apiUrl/game_sessions/$gameId/challenges');

    final body = jsonEncode({
      'first_word': challenge.firstWord,
      'second_word': challenge.secondWord,
      'third_word': challenge.thirdWord,
      'fourth_word': challenge.fourthWord,
      'fifth_word': challenge.fifthWord,
      'forbidden_words': challenge.forbiddenWords,
    });

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return Challenge(
        id: responseData['id'].toString(),
        firstWord: challenge.firstWord,
        secondWord: challenge.secondWord,
        thirdWord: challenge.thirdWord,
        fourthWord: challenge.fourthWord,
        fifthWord: challenge.fifthWord,
        forbiddenWords: challenge.forbiddenWords,
      );
    } else {
      return null;
    }
  }

  /// Ensures the game is in the challenge phase.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game session.
  ///
  /// - Returns: A Future that completes with true if the game is in the challenge phase, false otherwise.
  Future<bool> ensureChallengePhase(String gameId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    final apiUri = dotenv.env['API_URL'];
    final response = await http.get(
      Uri.parse('$apiUri/game_sessions/$gameId/status'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'challenge') {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}