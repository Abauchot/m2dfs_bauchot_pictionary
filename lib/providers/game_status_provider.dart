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
      final apiUri = dotenv.env['API_URI'];
      final response = await http.get(Uri.parse('$apiUri/game_sessions/$gameId/status'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = data['status'];
        print('Fetched game status: $state');
      } else {
        state = 'error: Failed to fetch game status';
        print(state);
      }
    } catch (e) {
      state = 'error: ${e.toString()}';
      print(state);
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
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = data['status'];
        print('Game session started: $state');
      } else {
        state = 'error: Failed to start game session';
        print(state);
      }
    } catch (e) {
      state = 'error: ${e.toString()}';
      print(state);
    }
  }

  void setChallengeStatus() {
    state = 'challenge';
    print('Status set to challenge');
  }

  void setDrawingStatus() {
    state = 'drawing';
    print('Status set to drawing');
  }
}