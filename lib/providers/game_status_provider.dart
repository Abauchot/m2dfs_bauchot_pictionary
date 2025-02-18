import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provides the game status state notifier.
final gameStatusProvider = StateNotifierProvider<GameStatusNotifier, String>((ref) {
  return GameStatusNotifier();
});

/// A state notifier for managing the game status.
class GameStatusNotifier extends StateNotifier<String> {
  /// Creates a GameStatusNotifier with an initial status of 'lobby'.
  GameStatusNotifier() : super('lobby');

  /// Fetches the game status from the server.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game session.
  ///
  /// - Returns: A Future that completes when the operation is done.
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
        // Handle error
      }
    } catch (e) {
      print('Error fetching game status: ${e.toString()}');
    }
  }

  /// Starts the game session.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game session.
  ///
  /// - Returns: A Future that completes when the operation is done.
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
        // Handle error
      }
    } catch (e) {
      print('Error starting game session: ${e.toString()}');
    }
  }

  /// Starts the game session and waits for the challenge phase.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game session.
  ///
  /// - Returns: A Future that completes when the operation is done.
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

  /// Sets the game status to 'drawing'.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game session.
  ///
  /// - Returns: A Future that completes when the operation is done.
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
      // Handle error
    }
  }

  /// Sets the game status to 'challenge'.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game session.
  ///
  /// - Returns: A Future that completes when the operation is done.
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
      // Handle error
    }
  }

  /// Waits for the game status to change to 'drawing'.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game session.
  ///
  /// - Returns: A Future that completes when the operation is done.
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
        // Handle error
        return;
      }
    }
  }
}