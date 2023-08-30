import 'package:tic_tac_toe_lib/src/Strategy/easy_strategy.dart';
import 'package:tic_tac_toe_lib/src/Strategy/medium_strategy.dart';
import 'package:tic_tac_toe_lib/src/Strategy/hard_strategy.dart';
import 'package:tic_tac_toe_lib/src/board.dart';

import '../GameInfo/position.dart';

enum Difficulty { easy, medium, hard }

abstract class IStrategy {
  Position bestMove(Board board);

  factory IStrategy.difficulty(Difficulty d) {
    switch (d) {
      case Difficulty.easy:
        {
          return Easy();
        }
      case Difficulty.medium:
        {
          return Medium();
        }
      case Difficulty.hard:
        {
          return Hard();
        }
    }
  }
}
