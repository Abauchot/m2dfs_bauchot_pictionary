//lib/models/Player.dart
class Player {
  final String id;
  final String name;

  Player({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'Player{id: $id, name: $name}';
  }
}