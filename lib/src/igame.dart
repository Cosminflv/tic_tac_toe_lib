import 'package:tic_tac_toe_lib/src/board.dart';
import 'package:tic_tac_toe_lib/src/igame_listener.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/position.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/piece.dart';
import 'package:tic_tac_toe_lib/src/Strategy/IStrategy.dart';

abstract class IGame {
  void placePiece(Position p);
  void restart();
  Piece? at(Position p);
  void addListener(IGameListener listener);
  void removeListener(IGameListener listener);
  bool isOver();

  set strategy(IStrategy? strategy);
  Board get gameBoard;
}
