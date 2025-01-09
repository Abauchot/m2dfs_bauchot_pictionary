import 'package:flutter/material.dart';
import 'package:m2dfs_bauchot_pictionary/screens/team_building.dart';
import 'package:m2dfs_bauchot_pictionary/utils/theme.dart';
import 'package:m2dfs_bauchot_pictionary/components/qr_code_popup.dart';
import 'package:m2dfs_bauchot_pictionary/utils/players_service.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class StartGame extends StatefulWidget {
  @override
  _StartGameState createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
  final PlayersService _playersService = PlayersService();
  String _selectedTeam = 'blue';

  Future<void> _createGame() async {
    try {
      final data = await _playersService.createGame();
      final String gameId = data['id'].toString();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Game created successfully!'),
          ),
        );
// lib/screens/start_game.dart

        showDialog(
          context: context,
          builder: (BuildContext context) {
            final qrData = gameId;
            return AlertDialog(
              title: const Text('Game QR Code'),
              content: PrettyQrView.data(
                data: qrData,
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  Future<void> _joinGameSession(String gameId) async {
    try {
      await _playersService.joinGame(gameId, _selectedTeam);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TeamBuilding(gameId: gameId)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
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
      await _joinGameSession(code);
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
              DropdownButton<String>(
                value: _selectedTeam,
                items: <String>['blue', 'red'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTeam = newValue!;
                  });
                },
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