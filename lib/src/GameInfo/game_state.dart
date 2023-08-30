// ignore: file_names
// ignore_for_file: constant_identifier_names

enum GameState {
  Playing,
  CrossWon,
  ZeroWon,
  Tie;

  GameState updateState(GameState other) {
    return other;
  }
}
