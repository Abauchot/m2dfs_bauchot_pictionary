import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A page that displays the summary of the game.
class GameSummaryPage extends StatelessWidget {
  /// Creates a new GameSummaryPage instance.
  ///
  /// - Parameters:
  ///   - key: An optional key for the widget.
  const GameSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Victory Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.star, size: 48, color: Colors.black),
                  const SizedBox(height: 8),
                  Text(
                    'Victory for the RED team!',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Game Summary
            Expanded(
              child: ListView(
                children: [
                  _buildTeamSummary('Summary of the Red Team\'s game', Colors.redAccent),
                  _buildTeamSummary('Summary of the Blue Team\'s game', Colors.blueAccent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the app bar for the screen.
  ///
  /// - Returns: A PreferredSizeWidget representing the app bar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
      centerTitle: true,
      title: Text(
        'Game Summary',
        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  /// Builds the summary section for a team.
  ///
  /// - Parameters:
  ///   - title: The title of the summary section.
  ///   - color: The color associated with the team.
  ///
  /// - Returns: A Widget representing the team summary section.
  Widget _buildTeamSummary(String title, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        _buildChallengeItem(),
        _buildChallengeItem(),
        _buildChallengeItem(),
      ],
    );
  }

  /// Builds a widget representing a challenge item.
  ///
  /// - Returns: A Widget representing a challenge item.
  Widget _buildChallengeItem() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/image.png', width: 60, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A hen on a wall',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text('+25', style: GoogleFonts.poppins(color: Colors.green, fontSize: 14)),
                      const SizedBox(width: 8),
                      Text('-8', style: GoogleFonts.poppins(color: Colors.red, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}