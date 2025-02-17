// lib/providers/game_status_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final gameStatusProvider = StateNotifierProvider<GameStatusNotifier, String>((ref) {
  return GameStatusNotifier();
});

// lib/providers/game_status_provider.dart
class GameStatusNotifier extends StateNotifier<String> {
  GameStatusNotifier() : super('lobby');

  Future<void> fetchGameStatus(String gameId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('userToken') ?? '';
      if (userToken.isEmpty) {
        throw Exception('User token not found');
      }

      final apiUri = dotenv.env['API_URL'];

      final response = await http.get(
        Uri.parse('$apiUri/game_sessions/$gameId/status'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = data['status'];
      } else {
      }
    } catch (e) {
      print('Error fetching game status: ${e.toString()}');
    }
  }




  Future<void> startGameSession(String gameId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('userToken') ?? '';
      if (userToken.isEmpty) {
        throw Exception('User token not found');
      }

      final apiUri = dotenv.env['API_URL'];

      final response = await http.post(
        Uri.parse('$apiUri/game_sessions/$gameId/start'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = data['status'];
      } else {
      }
    } catch (e) {
      print('Error starting game session: ${e.toString()}');
    }
  }

  Future<void> startGameAndWaitForChallengePhase(String gameId) async {
    await startGameSession(gameId);

    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(seconds: 2));
      await fetchGameStatus(gameId);

      if (state == "challenge") {
        return;
      }
    }
  }

  Future<void> setDrawingStatus(String gameId) async {
    final apiUri = dotenv.env['API_URL'];
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      return;
    }

    final uri = Uri.parse('$apiUri/game_sessions/$gameId/status');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': 'drawing'}),
    );

    if (response.statusCode == 200) {
      state = 'drawing';
    } else {
      return;
    }
  }

  Future<void> setChallengeStatus(String gameId) async {
    final apiUri = dotenv.env['API_URL'];
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      return;
    }

    final url = '$apiUri/game_sessions/$gameId/start';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );


    if (response.statusCode == 200) {
      state = "challenge";
    } else {
    }
  }


  Future<void> waitForDrawingPhase(String gameId) async {
    final apiUri = dotenv.env['API_URL'];
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      return;
    }

    final uri = Uri.parse('$apiUri/game_sessions/$gameId/status');

    while (true) {
      await Future.delayed(const Duration(seconds: 2));

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'drawing') {
          state = 'drawing';
          return;
        }
      } else {
        return;
      }
    }
  }



}