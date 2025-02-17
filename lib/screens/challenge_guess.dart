//challenge_guess.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/challenge.dart';

final challengesProvider = StateProvider<List<Challenge>>((ref) => []);

class ChallengePage extends ConsumerWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(challengesProvider);
    //final currentChallenge = challenges.isNotEmpty ? challenges.first : null;
    final currentChallenge = challenges.isNotEmpty ? challenges.firstWhere(
            (challenge) => challenge.imageUrl != null,
        orElse: () => challenges.first
    ) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chrono 300', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Challenge Section
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Column(
                children: [
                  Text('Votre challenge:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(currentChallenge?.generatePrompt() ?? 'Aucun challenge',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildCategoryButton('Poulet'),
                      _buildCategoryButton('Volaille'),
                      _buildCategoryButton('Oiseau'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Image Section
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: currentChallenge?.imageUrl != null
                    ? CachedNetworkImage(
                  imageUrl: currentChallenge!.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
                    : Center(child: Text('Aucune image disponible')),
              ),
            ),
            SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.refresh),
                  label: Text('Redraw (-50pts)'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.send),
                  label: Text('Sent'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Description
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text, style: TextStyle(color: Colors.white)),
    );
  }
}