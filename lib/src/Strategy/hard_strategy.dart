import 'package:tic_tac_toe_lib/src/Strategy/IStrategy.dart';
import 'package:tic_tac_toe_lib/src/board.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/piece.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/position.dart';

class MinimaxInfo {
  final Pair<Position, int> data;

  MinimaxInfo(Position position, int value) : data = Pair(position, value);

  Position get position => data.x;
  int get value => data.y;
}

class Hard with MinimaxMixin implements IStrategy {
  Hard();

  static int max(int x, int y) => x >= y ? x : y;
  static int min(int x, int y) => x > y ? y : x;

  @override
  Position bestMove(Board board) {
    if (board.emptyPositions().isNotEmpty) {
      return minimax(board, 0).position;
    }
    return Position(-1, -1);
  }
}

mixin MinimaxMixin {
  MinimaxInfo minimax(Board board, int level) {
    var emptyLocations = board.emptyPositions();

    final bool isCompPlayer = level.isEven;

    const int winScore = 5;
    const int drawScore = 0;

    var bestLocation = Position(-1, -1);
    var bestValue = -10;

    for (final pos in emptyLocations) {
      int currentOptionValue = 0;
      Board currentBoard = board.copyBoard();
      currentBoard.placePiece(pos, isCompPlayer ? Piece.Zero : Piece.Cross);

      if (currentBoard.isDraw()) {
        currentOptionValue = drawScore;
      } else if (currentBoard.isOverWon(Piece.Cross) || currentBoard.isOverWon(Piece.Zero)) {
        currentOptionValue = winScore;
      } else {
        currentOptionValue = -minimax(currentBoard, level + 1).value;
      }

      if (currentOptionValue > bestValue) {
        bestValue = currentOptionValue;
        bestLocation = pos;

        if (bestValue == winScore) {
          break;
        }
      }
    }

    return MinimaxInfo(bestLocation, bestValue);
  }
}
