import 'package:flutter/material.dart';
import 'package:m2dfs_bauchot_pictionary/screens/team_building.dart';
import 'package:m2dfs_bauchot_pictionary/utils/theme.dart';
import 'package:m2dfs_bauchot_pictionary/components/qr_code_popup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';


class StartGame extends StatefulWidget {
  @override
  _StartGameState createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
  Future<void> _createGame() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User token not found. Please log in again.'),
          ),
        );
      }
      return;
    }

    print('User token: $token'); // Debugging token

    final String url = '${dotenv.env['API_URL']}/game_sessions';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        // Add your game creation parameters here
      }),
    );

    print('Request headers: ${response.request?.headers}'); // Debugging headers

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final String gameId = data['id'].toString(); // Assuming the response contains the game ID

      print('Game created successfully with ID: $gameId');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Game created successfully!'),
          ),
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final qrData = '${dotenv.env['API_URL']}/game_sessions/$gameId';
            print('QR Code Data: $qrData');
            return AlertDialog(
              title: const Text('Game QR Code'),
              content: PrettyQr(
                data: qrData,
                size: 200,
                roundEdges: true,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TeamBuilding(gameId: gameId)),
                    );
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      print('Failed to create game: ${response.body}'); // Debugging response body
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create game. Please try again.'),
          ),
        );
      }
    }
  }

  Future<void> _joinGame() async {
    final String? code = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const QRCodePopup(),
    );

    if (code != null) {
      print('QR Code: $code');
      await _joinGameSession(code);
    } else {
      print('No QR code scanned');
    }
  }

  Future<void> _joinGameSession(String gameId) async {
    // Extraire uniquement l'ID de la partie si une URL complète est fournie
    if (gameId.startsWith('http')) {
      final uri = Uri.parse(gameId);
      gameId = uri.pathSegments.last; // Récupère la dernière partie de l'URL
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');

    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User token not found. Please log in again.'),
          ),
        );
      }
      return;
    }

    final String url = '${dotenv.env['API_URL']}/game_session/$gameId/join';
    print('Joining game with ID: $gameId');
    print('Request URL: $url');
    print('User token: $token');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TeamBuilding(gameId: gameId)),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to join game. Please try again.'),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piction-ai-ry'),
        backgroundColor: AppTheme.primaryBlue,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Hello, ready to play ? 🎨',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Piction.ai.ry is a game for 4 players in 2 teams, where one player must draw '
                    'an image without using forbidden words, and the other must guess the challenge. '
                    'Roles change every round, and the game continues until all challenges are solved '
                    'or time runs out. Mistakes cost points, and each correct word earns points.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _createGame,
                icon: const Icon(Icons.group),
                label: Text(
                  'Create a new game',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _joinGame,
                icon: const Icon(Icons.qr_code),
                label: Text(
                  'Join a game',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
