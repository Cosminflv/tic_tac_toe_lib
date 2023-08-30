import 'dart:math';

import 'package:tic_tac_toe_lib/src/Strategy/IStrategy.dart';
import 'package:tic_tac_toe_lib/src/board.dart';
import 'package:tic_tac_toe_lib/src/Strategy/hard_strategy.dart';
import 'package:tic_tac_toe_lib/src/Strategy/easy_strategy.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/position.dart';

class Medium with MinimaxMixin, EasyMixin implements IStrategy {
  Medium();

  @override
  Position bestMove(Board board) {
    Random rand = Random();

    if (rand.nextInt(2) == 1) {
      return randomMove(board);
    } else {
      final result = minimax(board, 0);
      return result.position;
    }
  }
}
