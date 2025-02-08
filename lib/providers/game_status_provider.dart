// lib/providers/game_status_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final gameStatusProvider = StateNotifierProvider<GameStatusNotifier, String>((ref) {
  return GameStatusNotifier();
});

class GameStatusNotifier extends StateNotifier<String> {
  GameStatusNotifier() : super('lobby');

  Future<void> fetchGameStatus(String gameId) async {
    try {
      final apiUri = dotenv.env['API_URI'];
      final response = await http.get(Uri.parse('$apiUri/game_sessions/$gameId/status'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = data['status'];
      } else {
        state = 'error: Failed to fetch game status';
      }
    } catch (e) {
      state = 'error: ${e.toString()}';
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
      if (apiUri == null) {
        throw Exception('API_URL is not set in the environment variables');
      }
      print('Starting game session with $apiUri/game_sessions/$gameId/start');
      final response = await http.post(
        Uri.parse('$apiUri/game_sessions/$gameId/start'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );
      print('Request headers: ${response.request?.headers}');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data');
        state = data['status'];
      } else {
        state = 'error: Failed to start game session';
      }
    } catch (e) {
      state = 'error: ${e.toString()}';
    }
  }

  void setChallengeStatus() {
    state = 'challenge';
  }
}