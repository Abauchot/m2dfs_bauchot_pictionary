/// A class representing a player with an ID and a name.
class Player {
  /// The unique identifier of the player.
  final String id;

  /// The name of the player.
  final String name;

  /// Creates a new Player instance.
  ///
  /// - Parameters:
  ///   - id: The unique identifier of the player.
  ///   - name: The name of the player.
  Player({
    required this.id,
    required this.name,
  });

  @override
  String toString() {
    return 'Player{id: $id, name: $name}';
  }
}