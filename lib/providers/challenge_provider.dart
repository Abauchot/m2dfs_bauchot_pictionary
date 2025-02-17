//challenges_provider.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/challenge.dart';
import 'package:http/http.dart' as http;
import 'dart:math';



final firstArticleProvider = StateProvider<String>((ref) => "UNE");
final prepositionProvider = StateProvider<String>((ref) => "SUR");
final secondArticleProvider = StateProvider<String>((ref) => "UN");
final firstWordProvider = StateProvider<String>((ref) => "");
final secondWordProvider = StateProvider<String>((ref) => "");
final forbiddenWordsProvider = StateProvider<List<String>>((ref) => []);


final challengesProvider = StateNotifierProvider<ChallengesNotifier, List<Challenge>>((ref) {
  return ChallengesNotifier();
});


class ChallengesNotifier extends StateNotifier<List<Challenge>> {
  ChallengesNotifier() : super([]);

  void addChallenge(Challenge challenge) {
    state = [...state, challenge];
  }

  void removeChallenge(int index) {
    state = [...state]..removeAt(index);
  }

  Future<void> selectAndSendRandomChallenge(String gameId) async {

    final apiUrl = dotenv.env['API_URL'];
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      return;
    }

    // 🔹 Vérifier le statut de la session
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
    }
  }


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