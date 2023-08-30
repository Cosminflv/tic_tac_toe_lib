import 'dart:math';

import 'package:tic_tac_toe_lib/src/Strategy/IStrategy.dart';
import 'package:tic_tac_toe_lib/src/board.dart';

import 'package:tic_tac_toe_lib/src/GameInfo/position.dart';

class Easy with EasyMixin implements IStrategy {
  @override
  Position bestMove(
    Board board,
  ) {
    return randomMove(board);
  }
}

mixin EasyMixin {
  Position randomMove(Board board) {
    List<Position> emptyPositions = board.emptyPositions();

    Random random = Random();

    int randomValue = random.nextInt(emptyPositions.length);

    return emptyPositions[randomValue];
  }
}
