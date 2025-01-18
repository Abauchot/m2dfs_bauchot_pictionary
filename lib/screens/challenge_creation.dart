import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:m2dfs_bauchot_pictionary/forms/challenge_form.dart';
import 'package:m2dfs_bauchot_pictionary/providers/challenge_provider.dart';
import 'package:m2dfs_bauchot_pictionary/utils/theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piction-ai-ry',
      home: ChallengeCreation(),
      theme: AppTheme.lightTheme, // Use the custom theme
    );
  }
}

class ChallengeCreation extends ConsumerStatefulWidget {
  @override
  _ChallengeCreationState createState() => _ChallengeCreationState();
}

class _ChallengeCreationState extends ConsumerState<ChallengeCreation> {
  final List<Map<String, String>> _challenges = [];

  void _addChallenge() {
    final form = ChallengeForm();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Ajout d\'un challenge',
            style: TextStyle(color: Colors.black), // Set text color to black
          ),
          content: SingleChildScrollView(
            child: form,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final challenge = ref.read(challengeProvider);
                if (challenge.firstWord.isEmpty || challenge.secondWord.isEmpty || challenge.description.isEmpty) {
                  ref.read(challengeProvider.notifier).setErrorMessage('Veuillez remplir tous les champs requis.');
                } else {
                  setState(() {
                    int challengeNumber = _challenges.length + 1;
                    _challenges.add({
                      'title': 'Challenge#$challengeNumber',
                      'description': '${challenge.firstWord} ${challenge.description} ${challenge.secondWord}',
                      'forbidden1': challenge.forbidden1,
                      'forbidden2': challenge.forbidden2,
                      'forbidden3': challenge.forbidden3,
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() {}); // Ensure the state is updated after the dialog is closed
    });
  }

  void _removeChallenge(int index) {
    setState(() {
      _challenges.removeAt(index);
    });
  }

  void _sendChallenge(int index) {
    // Placeholder function to send the challenge to the other team
    print('Challenge sent: ${_challenges[index]}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Piction-ai-ry'),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _challenges.length,
              itemBuilder: (context, index) {
                final challenge = _challenges[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge['title']!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          challenge['description']!,
                          style: const TextStyle(color: Colors.black), // Set text color to black
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Mots interdits:',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${challenge['forbidden1']}, ${challenge['forbidden2']}, ${challenge['forbidden3']}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeChallenge(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.blue),
                              onPressed: () => _sendChallenge(index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _addChallenge,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un nouveau challenge'),
            ),
          ),
        ],
      ),
    );
  }
}