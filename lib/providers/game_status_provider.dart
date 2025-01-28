// lib/providers/game_status_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

  void setChallengeStatus() {
    state = 'challenge';
  }
}