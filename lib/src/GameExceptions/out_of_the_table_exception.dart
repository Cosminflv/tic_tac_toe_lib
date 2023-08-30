import 'package:tic_tac_toe_lib/src/GameExceptions/game_exceptions.dart';

class OutOfTableException extends GameException {
  OutOfTableException(super.message);
}
