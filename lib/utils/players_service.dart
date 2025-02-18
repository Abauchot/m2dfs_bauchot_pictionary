import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service class to handle player-related operations such as creating, joining, and leaving games.
class PlayersService {
  /// Creates a new game session.
  ///
  /// Retrieves the user token from shared preferences and sends a POST request to the API to create a new game session.
  ///
  /// Throws an [Exception] if the user token is not found or if the game creation fails.
  ///
  /// Returns a [Map] containing the game ID, player ID, and player name.
  Future<Map<String, dynamic>> createGame() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('User token not found. Please log in again.');
    }

    final String url = '${dotenv.env['API_URL']}/game_sessions';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return {
        'id': responseData['id'].toString(),
        'player_id': responseData['player_id'].toString(),
        'player_name': responseData['player_name'] ?? 'Unknown Player',
      };
    } else {
      throw Exception('Failed to create game. Please try again.');
    }
  }

  /// Joins an existing game session.
  ///
  /// Retrieves the user token from shared preferences and sends a POST request to the API to join a game session.
  ///
  /// Throws an [Exception] if the user token is not found or if joining the game fails.
  ///
  /// Returns a [Map] containing the player ID and player name.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game to join.
  ///   - team: The team color to join.
  Future<Map<String, dynamic>> joinGame(String gameId, String team) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('User token not found. Please log in again.');
    }

    final String url = '${dotenv.env['API_URL']}/game_sessions/$gameId/join';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'color': team,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return {
        'player_id': responseData['player_id'].toString(),
        'player_name': responseData['player_name'] ?? 'Unknown Player',
      };
    } else {
      throw Exception('Failed to join game. Please try again.');
    }
  }

  /// Leaves an existing game session.
  ///
  /// Retrieves the user token from shared preferences and sends a GET request to the API to leave a game session.
  ///
  /// Throws an [Exception] if the user token is not found or if leaving the game fails.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game to leave.
  Future<void> leaveGame(String gameId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('User token not found. Please log in again.');
    }

    final String url = '${dotenv.env['API_URL']}/game_sessions/$gameId/leave';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to leave game. Please try again.');
    }
  }
}