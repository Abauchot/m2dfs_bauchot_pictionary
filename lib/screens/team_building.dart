// lib/screens/team_building.dart

import 'package:flutter/material.dart';

class TeamBuilding extends StatelessWidget {
  final String gameId;

  const TeamBuilding({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Building'),
      ),
      body: Center(
        child: Text('Game ID: $gameId'),
      ),
    );
  }
}