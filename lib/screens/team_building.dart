// lib/screens/team_building.dart

import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class TeamBuilding extends StatelessWidget {
  final String gameId;

  const TeamBuilding({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qrData = gameId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Team Building'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game ID: $gameId'),
            SizedBox(height: 20),
            PrettyQrView.data(
              data: qrData,
            ),
          ],
        ),
      ),
    );
  }
}