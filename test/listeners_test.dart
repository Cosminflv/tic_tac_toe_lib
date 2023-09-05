import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/piece.dart';
import 'package:tic_tac_toe_lib/src/Strategy/IStrategy.dart';

import 'listener.mocks.dart';

import 'package:tic_tac_toe_lib/src/game.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/game_state.dart';
import 'package:tic_tac_toe_lib/src/igame_listener.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/position.dart';

@GenerateNiceMocks([MockSpec<IGameListener>()])
void main() {
  test('When placePiece is called two times, then onPiecePlaces is called twice', () {
    Game g = Game.produce();
    var listenerMock = MockIGameListener();

    g.addListener(listenerMock);

    g.placePiece(Position(1, 0));
    g.placePiece(Position(0, 0));

    verify(listenerMock.onPiecePlaced(any, any)).called(4);

    g.removeListener(listenerMock);
  });

  test('When the last piece is placed, then the game ends', () {
    Game g = Game.produceFromString('x x o\nx x o\no o -\n');
    var listenerMock = MockIGameListener();

    g.addListener(listenerMock);

    g.placePiece(Position(2, 2));

    verify(listenerMock.onGameOver(GameState.CrossWon));

    g.removeListener(listenerMock);
  });

  test('When there are three crosses in a line, cross player wins', () {
    Game g = Game.produceFromString('x o o\no x o\n- o -\n');
    var listenerMock = MockIGameListener();

    g.addListener(listenerMock);

    g.placePiece(Position(2, 2));

    verify(listenerMock.onGameOver(GameState.CrossWon));

    g.removeListener(listenerMock);
  });

  test('When its tried to place a piece over another, then onPiecePlaces is never called', () {
    Game g = Game.produceFromString('x o o\no x o\n- o -\n');
    var listenerMock = MockIGameListener();

    g.addListener(listenerMock);

    g.placePiece(Position(0, 0));

    verifyNever(listenerMock.onPiecePlaced(any, any));

    g.removeListener(listenerMock);
  });

  test('When restart is called, onRestart is called', () {
    Game g = Game.produceFromString('x o o\no x o\n- o -\n');
    var listenerMock = MockIGameListener();

    g.addListener(listenerMock);

    g.restart();

    verify(listenerMock.onRestart());

    g.removeListener(listenerMock);
  });

  test('When player places a piece, the computer places after', () {
    Game g = Game();

    g.strategy = IStrategy.difficulty(Difficulty.hard);
    var listenerMock = MockIGameListener();

    g.addListener(listenerMock);

    g.placePiece(Position(0, 0));
    g.placePiece(Position(2, 0));

    verify(listenerMock.onPiecePlaced(Position(0, 0), Piece.Cross));
    verify(listenerMock.onPiecePlaced(Position(1, 1), Piece.Zero));

    verify(listenerMock.onPiecePlaced(Position(2, 0), Piece.Cross));
    verify(listenerMock.onPiecePlaced(Position(1, 0), Piece.Zero));

    g.removeListener(listenerMock);
  });
}
