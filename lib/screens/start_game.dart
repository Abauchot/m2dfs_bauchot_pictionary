import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m2dfs_bauchot_pictionary/screens/team_building.dart';
import 'package:m2dfs_bauchot_pictionary/utils/theme.dart';
import 'package:m2dfs_bauchot_pictionary/components/qr_code_popup.dart';
import 'package:m2dfs_bauchot_pictionary/utils/players_service.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:m2dfs_bauchot_pictionary/models/Player.dart';
import 'package:m2dfs_bauchot_pictionary/providers/team_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class StartGame extends ConsumerStatefulWidget {
  @override
  _StartGameState createState() => _StartGameState();
}

class _StartGameState extends ConsumerState<StartGame> {
  final PlayersService _playersService = PlayersService();
  String _selectedTeam = 'blue';

  Future<void> _createGame() async {
    try {
      final data = await _playersService.createGame();
      final String gameId = data['id'].toString();
      final String playerName = data['player_name'];
      await _playersService.joinGame(gameId, _selectedTeam);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Game created and joined successfully!'),
        ),
      );

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
                    MaterialPageRoute(builder: (context) => TeamBuilding(
                      gameId: gameId,
                      playerName: playerName,
                    )),
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error creating or joining game: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _joinGameSession(String gameId) async {
    try {
      final playerData = await _playersService.joinGame(gameId, _selectedTeam);

      if (!mounted) return;

      final teamNotifier = ref.read(teamProvider.notifier);
      teamNotifier.addPlayerToTeam(
        Player(id: playerData['player_id'], name: playerData['player_name']),
        _selectedTeam,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TeamBuilding(
            gameId: gameId,
            playerName: playerData['player_name'],
        )),
      );
    } catch (e) {
      print('Error joining game session: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _joinGame() async {
    final String? code = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const QRCodePopup(),
    );

    if (code != null) {
      await _joinGameSession(code);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No game code provided'),
        ),
      );
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
          child: AnimationLimiter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
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
        ),
      ),
    );
  }
}