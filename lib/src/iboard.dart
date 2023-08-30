import 'package:tic_tac_toe_lib/src/GameInfo/piece.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/position.dart';
import 'package:tic_tac_toe_lib/src/board.dart';

abstract class IBoard {
  void placePiece(Position pos, Piece piece);
  List<List<Piece>> get board;
}
