import 'package:tic_tac_toe_lib/src/GameInfo/position.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/turn.dart';

import 'GameInfo/game_state.dart';
import 'GameInfo/piece.dart';

abstract class IGameListener {
  void onPiecePlaced(Position p, Piece piece);
  void onGameOver(GameState state);
  void onRestart();
  void onTimerChange();
  void onSwitchTurn(Turn turn);
}
