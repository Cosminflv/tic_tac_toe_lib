export 'cannot_place_exception.dart';
export 'game_over_exception.dart';
export 'out_of_the_table_exception.dart';

class GameException implements Exception {
  GameException(this.message);
  final String message;
}
