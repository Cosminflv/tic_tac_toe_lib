import 'package:tic_tac_toe_lib/src/board.dart';
import 'package:tic_tac_toe_lib/src/GameExceptions/cannot_place_exception.dart';
import 'package:tic_tac_toe_lib/src/GameExceptions/game_over_exception.dart';
import 'package:tic_tac_toe_lib/src/GameExceptions/out_of_the_table_exception.dart';
import 'package:tic_tac_toe_lib/tic_tac_toe_lib.dart';
import 'package:test/test.dart';

void main() {
  group('Group of BoardTests', () {
    test('Row full of crosses', () {
      final boardTest = Board.fromString('x x x\n- o o\no - -\n');
      expect(boardTest.checkRow(0, Piece.Cross), true);
    });

    test('Column full of zeros', () {
      final boardTest = Board.fromString('x o x\n- o x\n- o -\n');
      expect(boardTest.checkColumn(1, Piece.Zero), true);
    });

    test('False column of crosses', () {
      final boardTest = Board.fromString('x o x\n- o x\n- o -\n');
      expect(boardTest.checkColumn(0, Piece.Cross), false);
    });

    test('Primary diagonal full of crosses', () {
      final boardTest = Board.fromString('x o x\n- x o\no - x\n');
      expect(boardTest.checkPrimaryDiagonal(Piece.Cross), true);
    });

    test('Secondary diagonal full of zeros', () {
      final boardTest = Board.fromString('o x o\n- o x\no - x\n');
      expect(boardTest.checkSecondaryDiagonal(Piece.Zero), true);
    });

    test('Place piece test1', () {
      final boardTest = Board();
      boardTest.placePiece(Position(0, 0), Piece.Cross);
      expect(boardTest.at(Position(0, 0)), Piece.Cross);
    });

    test('Place piece test2', () {
      final boardTest = Board();
      boardTest.placePiece(Position(0, 0), Piece.Cross);
      expect(() => boardTest.placePiece(Position(0, 0), Piece.Zero), throwsA(isA<CannotPlaceException>()));
    });

    test('Place piece test3', () {
      final boardTest = Board();
      expect(() => boardTest.placePiece(Position(9, 8), Piece.Cross), throwsA(isA<OutOfTableException>()));
    });
  });

  group('Group of placePiece Tests', () {
    test('Piece placed correctly', () {
      var g = Game.produce();
      expect(() => g.placePiece(Position(0, 0)), returnsNormally);
      expect(() => g.placePiece(Position(1, 1)), returnsNormally);
      expect(g.at(Position(0, 0)), Piece.Cross);
      expect(g.at(Position(1, 1)), Piece.Zero);
    });

    test('Is game over', () {
      var g = Game.produceFromString('x o x\nx o x\no x -\n');
      expect(() => g.placePiece(Position(2, 2)), returnsNormally);
      expect(g.isOver(), true);
    });

    test('Is not game over', () {
      var g = Game.produceFromString('x o x\nx o x\no - -\n');
      expect(() => g.placePiece(Position(2, 1)), returnsNormally);
      expect(g.isOver(), false);
    });

    test('Restart test', () {
      var g = Game.produceFromString('x o x\nx o x\no x -\n');
      expect(() => g.placePiece(Position(2, 2)), returnsNormally);
      expect(() => g.restart(), returnsNormally);
      expect(g.isOver(), false);
    });

    test('Turn test', () {
      var g = Game.produce();
      expect(() => g.placePiece(Position(1, 1)), returnsNormally);
      expect(g.pieceBasedOnTurn(), Piece.Zero);
      expect(() => g.placePiece(Position(0, 0)), returnsNormally);
      expect(g.pieceBasedOnTurn(), Piece.Cross);
    });

    test('Move after game ended test ', () {
      var g = Game.produceFromString('x o x\nx o x\no x -\n');
      expect(() => g.placePiece(Position(2, 2)), returnsNormally);
      expect(() => g.placePiece(Position(2, 2)), throwsA(isA<GameOverException>()));
    });

    test('Draw test', () {
      var g = Game.produceFromString('x o x\nx o x\no x -\n');
      expect(() => g.placePiece(Position(2, 2)), returnsNormally);
      expect(g.isDraw(), false);
    });

    test('isOver test', () {
      var g = Game.produceFromString('x o x\nx o x\no x -\n');
      expect(() => g.placePiece(Position(2, 2)), returnsNormally);
      expect(g.isOver(), true);
    });

    test('Minimax plays game correctly1', () {
      var g = Game();
      g.strategy = (IStrategy.difficulty(Difficulty.hard));

      expect(() => g.placePiece(Position(2, 2)), returnsNormally);
      expect(() => g.placePiece(Position(0, 0)), returnsNormally);
      expect(() => g.placePiece(Position(2, 1)), returnsNormally);
      expect(() => g.placePiece(Position(0, 2)), returnsNormally);
      expect(() => g.placePiece(Position(1, 0)), returnsNormally);

      expect(g.at(Position(1, 1)), Piece.Zero);
      expect(g.at(Position(0, 1)), Piece.Zero);
      expect(g.at(Position(2, 0)), Piece.Zero);
      expect(g.at(Position(1, 2)), Piece.Zero);
    });

    test('Minimax plays game correctly2', () {
      var g = Game();
      g.strategy = (IStrategy.difficulty(Difficulty.hard));

      expect(() => g.placePiece(Position(0, 2)), returnsNormally);
      expect(() => g.placePiece(Position(2, 2)), returnsNormally);
      expect(() => g.placePiece(Position(1, 0)), returnsNormally);
      expect(() => g.placePiece(Position(2, 1)), returnsNormally);
      expect(() => g.placePiece(Position(0, 1)), returnsNormally);

      expect(g.at(Position(1, 1)), Piece.Zero);
      expect(g.at(Position(1, 2)), Piece.Zero);
      expect(g.at(Position(0, 0)), Piece.Zero);
      expect(g.at(Position(2, 0)), Piece.Zero);
    });
  });
}
