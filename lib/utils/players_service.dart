import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayersService {
  Future<Map<String, dynamic>> createGame() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('User token not found. Please log in again.');
    }

    final String url = '${dotenv.env['API_URL']}/game_sessions';
    print('Creating game with URL: $url');
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({}),
    );

    print('Response status code: ${response.statusCode}');
    if (response.statusCode == 201) {
      print('Game created successfully');
      return jsonDecode(response.body);
    } else {
      print('Failed to create game: ${response.body}');
      throw Exception('Failed to create game. Please try again.');
    }
  }

  Future<Map<String, dynamic>> joinGame(String gameId, String team) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('User token not found. Please log in again.');
    }

    final String url = '${dotenv.env['API_URL']}/game_sessions/$gameId/join';
    print('Joining game with URL: $url and team: $team');
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

    print('Response status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Joined game successfully');
      final responseData = jsonDecode(response.body);
      return {
        'player_id': responseData['player_id'].toString(),
        'player_name': responseData['player_name'] ?? 'Unknown Player',
      };
    } else {
      print('Failed to join game: ${response.body}');
      throw Exception('Failed to join game. Please try again.');
    }
  }

  Future<void> leaveGame(String gameId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      throw Exception('User token not found. Please log in again.');
    }

    final String url = '${dotenv.env['API_URL']}/game_sessions/$gameId/leave';
    print('Leaving game with URL: $url');
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Left game successfully');
    } else {
      print('Failed to leave game: ${response.body}');
      throw Exception('Failed to leave game. Please try again.');
    }
  }
}