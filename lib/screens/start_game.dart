import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:m2dfs_bauchot_pictionary/screens/team_building.dart';
import 'package:m2dfs_bauchot_pictionary/components/qr_code_popup.dart';
import 'package:m2dfs_bauchot_pictionary/utils/players_service.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:m2dfs_bauchot_pictionary/models/Player.dart';
import 'package:m2dfs_bauchot_pictionary/providers/team_provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

/// A widget that represents the start game screen.
class StartGame extends ConsumerStatefulWidget {
  /// Creates a new StartGame instance.
  ///
  /// - Parameters:
  ///   - key: An optional key for the widget.
  const StartGame({super.key});

  @override
  _StartGameState createState() => _StartGameState();
}

/// The state for the StartGame widget.
class _StartGameState extends ConsumerState<StartGame> {
  /// Service for managing players.
  final PlayersService _playersService = PlayersService();

  /// The selected team for the player.
  String _selectedTeam = 'blue';

  /// Creates a new game and shows a QR code for joining.
  ///
  /// - Returns: A Future that completes when the operation is done.
  Future<void> _createGame() async {
    try {
      final data = await _playersService.createGame();
      final String gameId = data['id'].toString();
      final String playerName = data['player_name'];
      await _playersService.joinGame(gameId, _selectedTeam);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          final qrData = gameId;
          return AlertDialog(
            title: const Text('Game QR Code'),
            content: PrettyQrView.data(data: qrData),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeamBuilding(
                        gameId: gameId,
                        playerName: playerName,
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating game: $e')),
      );
    }
  }

  /// Joins an existing game session with the given game ID.
  ///
  /// - Parameters:
  ///   - gameId: The ID of the game to join.
  ///
  /// - Returns: A Future that completes when the operation is done.
  Future<void> _joinGameSession(String gameId) async {
    try {
      final playerData = await _playersService.joinGame(gameId, _selectedTeam);

      if (!mounted) return;

      final teamNotifier = ref.read(teamProvider.notifier);
      teamNotifier.addPlayerToTeam(
        Player(id: playerData['player_id'], name: playerData['player_name']),
        _selectedTeam,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeamBuilding(
            gameId: gameId,
            playerName: playerData['player_name'],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error joining game: $e')),
      );
    }
  }

  /// Prompts the user to enter a game code and joins the game.
  ///
  /// - Returns: A Future that completes when the operation is done.
  Future<void> _joinGame() async {
    final String? code = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => const QRCodePopup(),
    );

    if (code != null) {
      await _joinGameSession(code);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No game code provided')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimationLimiter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(child: widget),
                  ),
                  children: <Widget>[
                    Text(
                      'Hello, ready to play? 🎨',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Piction.ai.ry is a game for 4 players in 2 teams. One player draws an image without '
                          'using forbidden words while the other guesses. Roles change every round. '
                          'The game ends when all challenges are solved or time runs out. Each correct word earns points!',
                      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    DropdownButton<String>(
                      dropdownColor: Colors.white,
                      value: _selectedTeam,
                      items: <String>['blue', 'red'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: GoogleFonts.poppins(fontSize: 16, color: Colors.black)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedTeam = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildButton(
                      onTap: _createGame,
                      icon: Icons.group,
                      label: 'Create a new game',
                    ),
                    const SizedBox(height: 20),
                    _buildButton(
                      onTap: _joinGame,
                      icon: Icons.qr_code,
                      label: 'Join a game',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a button widget.
  ///
  /// - Parameters:
  ///   - onTap: The callback to invoke when the button is tapped.
  ///   - icon: The icon to display on the button.
  ///   - label: The text to display on the button.
  ///
  /// - Returns: A Widget representing the button.
  Widget _buildButton({required VoidCallback onTap, required IconData icon, required String label}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}