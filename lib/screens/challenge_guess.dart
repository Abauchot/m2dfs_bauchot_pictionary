import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/challenge.dart';

/// Provides the list of challenges.
final challengesProvider = StateProvider<List<Challenge>>((ref) => []);

/// A screen for displaying and managing challenge guesses.
class ChallengePage extends ConsumerWidget {
  /// Creates a new ChallengePage instance.
  ///
  /// - Parameters:
  ///   - key: An optional key for the widget.
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(challengesProvider);
    final currentChallenge = challenges.isNotEmpty
        ? challenges.firstWhere(
            (challenge) => challenge.imageUrl != null,
        orElse: () => challenges.first)
        : null;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Challenge Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Column(
                children: [
                  Text('Your challenge:',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(currentChallenge?.generatePrompt() ?? 'No challenge available',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildCategoryButton('Chicken'),
                      _buildCategoryButton('Poultry'),
                      _buildCategoryButton('Bird'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Image Section
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: currentChallenge?.imageUrl != null
                    ? CachedNetworkImage(
                  imageUrl: currentChallenge!.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
                    : Center(
                  child: Text(
                    'No image available',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh),
                  label: Text('Redraw (-50pts)', style: GoogleFonts.poppins()),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                  label: Text('Send', style: GoogleFonts.poppins()),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: TextField(
                decoration: const InputDecoration(border: InputBorder.none),
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
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
      title: Text(
        'Chrono 300',
        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
    );
  }

  /// Builds a category button with the given text.
  ///
  /// - Parameters:
  ///   - text: The text to display on the button.
  ///
  /// - Returns: A Widget representing the category button.
  Widget _buildCategoryButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text, style: GoogleFonts.poppins(color: Colors.white)),
    );
  }
}