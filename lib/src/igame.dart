import 'package:tic_tac_toe_lib/src/GameInfo/piece.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/position.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/turn.dart';
import 'package:tic_tac_toe_lib/src/Strategy/IStrategy.dart';

import 'package:tic_tac_toe_lib/src/game.dart';
import 'package:tic_tac_toe_lib/src/igame_listener.dart';

abstract class IGame {
  void placePiece(Position p);
  void restart();
  Piece? at(Position p);
  void addListener(IGameListener listener);
  void removeListener(IGameListener listener);
  bool isOver();

  set strategy(IStrategy? strategy);
  set difficulty(Difficulty difficulty);
  List<List<Piece?>>? get gameBoard;

  Turn get turn;
  Stopwatch get stopWatch;

  factory IGame.produce() => Game();
}
