import 'dart:async';

import 'package:tic_tac_toe_lib/src/igame.dart';
import 'package:tic_tac_toe_lib/src/Strategy/IStrategy.dart';
import 'package:tic_tac_toe_lib/src/igame_listener.dart';
import 'package:tic_tac_toe_lib/src/logs/logging.dart';
import 'package:tic_tac_toe_lib/src/GameInfo/position.dart';

import 'GameInfo/turn.dart';
import 'board.dart';
import 'GameInfo/piece.dart';
import 'GameInfo/game_state.dart';
import 'GameExceptions/game_exceptions.dart';

typedef ListenerList = List<IGameListener>;

class Game implements IGame {
  final log = logger(Game);

  Game({bool? wantTimer}) {
    _mGameBoard = Board();
    _mTurn = Turn.crossTurn;
    _mState = GameState.Playing;
    _mStrategy = null;
    if (wantTimer == true) {
      _stopWatch.start();
      _stopWatchLimited.start();
      stopWatchRefresh();
    }
  }

  Game.boardString(String matrixInString)
      : _mGameBoard = Board.fromString(matrixInString),
        _mTurn = Turn.crossTurn,
        _mState = GameState.Playing;

  factory Game.produce() => Game();
  factory Game.produceFromString(String matrixInString) => Game.boardString(matrixInString);

  Board _mGameBoard = Board();
  Turn _mTurn = Turn.crossTurn;
  GameState _mState = GameState.Playing;
  ListenerList listeners = [];
  IStrategy? _mStrategy;
  late Timer _timer;
  final Stopwatch _stopWatch = Stopwatch();
  final Stopwatch _stopWatchLimited = Stopwatch();

  void stopWatchRefresh() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (Timer t) async {
      notifyTimerChange();
      if (!isOver()) {
        if (_stopWatchLimited.elapsedMilliseconds > 10000) {
          if (_mTurn == Turn.crossTurn) {
            _mState = GameState.ZeroWon;
          } else {
            _mState = GameState.CrossWon;
          }
          notifyGameOver(_mState);
          _timer.cancel();
          _stopWatchLimited.stop();
        }
      }

      if (isOver()) {
        _stopWatch.stop();
        _timer.cancel();
      } else {
        notifyTimerChange();
      }
    });
  }

  @override
  Turn get turn => _mTurn;

  @override
  void placePiece(Position p) {
    if (_mState != GameState.Playing) {
      log.e('GameOverException thrown!');
      throw GameOverException("The game has ended!\n");
    }

    try {
      log.i('placePiece(p, pieceBasedOnTurn()) has been called');
      _mGameBoard.placePiece(p, pieceBasedOnTurn());
      log.i('notifyPiecePlaced(p, pieceBasedOnTurn()) has been called');
      notifyPiecePlaced(p, pieceBasedOnTurn());
      _stopWatchLimited.reset();
      _stopWatchLimited.start();
      if (_mGameBoard.isOverWon(pieceBasedOnTurn())) {
        _mState = pieceBasedOnTurn() == Piece.Cross ? GameState.CrossWon : GameState.ZeroWon;
        log.i('notifyGameOver(_mState) called');
        notifyGameOver(_mState);
        return;
      }

      if (_mGameBoard.isDraw()) {
        _mState = GameState.Tie;
        log.i('notifyGameOver(_mState) called');
        notifyGameOver(GameState.Tie);
      }

      if (_mStrategy != null && _mState == GameState.Playing) {
        log.i('bestMove(_mGameBoard) called');
        Position toPlacePosition = _mStrategy!.bestMove(_mGameBoard);
        log.i('placePiece(toPlacePosition, pieceBasedOnTurn() + 1) called');
        _mGameBoard.placePiece(toPlacePosition, pieceBasedOnTurn() + 1);

        log.i('notifyPiecePlaced(toPlacePosition, Piece.Zero) called');
        notifyPiecePlaced(toPlacePosition, Piece.Zero);

        if (_mGameBoard.isOverWon(Piece.Zero)) {
          _mState = pieceBasedOnTurn() == Piece.Cross ? GameState.ZeroWon : GameState.CrossWon;
          log.i('notifyGameOver(GameState.ZeroWon) called');
          notifyGameOver(GameState.ZeroWon);
        }

        if (_mGameBoard.isDraw()) {
          _mState = GameState.Tie;
          log.i('notifyGameOver(GameState.Tie) called');
          notifyGameOver(GameState.Tie);
        }
      } else if (_mState == GameState.Playing) {
        log.i('switchTurn called');
        notifyPiecePlaced(p, pieceBasedOnTurn());
        _mTurn = switchTurn();
      }
    } on GameException catch (e) {
      print(e.message);
    }
  }

  @override
  void restart() {
    _mGameBoard = Board();
    _mTurn = Turn.crossTurn;
    _mState = GameState.Playing;
    log.e('Game has restarted');
    _timer.cancel();
    _stopWatchLimited.reset();
    _stopWatchLimited.start();
    _stopWatch.reset();
    _stopWatch.start();
    stopWatchRefresh();
    notifyRestart();
  }

  @override
  void addListener(IGameListener listenerToAdd) => listeners.add(listenerToAdd);

  @override
  void removeListener(IGameListener listenerToRemove) => listeners.remove(listenerToRemove);

  @override
  Piece? at(Position p) {
    return _mGameBoard[p.x][p.y];
  }

  factory Game.create() {
    return Game();
  }

  Turn switchTurn() {
    if (_mTurn == Turn.crossTurn) {
      notifySwitchTurn(Turn.zeroTurn);
      _stopWatchLimited.reset();
      _stopWatchLimited.start();
      return Turn.zeroTurn;
    } else {
      notifySwitchTurn(Turn.crossTurn);
      _stopWatchLimited.reset();
      _stopWatchLimited.start();
      return Turn.crossTurn;
    }
  }

  @override
  bool isOver() {
    return _mState == GameState.CrossWon || _mState == GameState.ZeroWon || _mState == GameState.Tie;
  }

  @override
  List<List<Piece?>> get gameBoard {
    List<List<Piece?>> result = List.generate(3, (index) => List.generate(3, (index) => null));
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        result[i][j] = _mGameBoard.at(Position(i, j));
      }
    }
    return result;
  }

  @override
  set strategy(IStrategy? strategy) => _mStrategy = strategy;
  IStrategy? get strategy => _mStrategy;

  @override
  set difficulty(Difficulty difficulty) => _mStrategy = IStrategy.difficulty(difficulty);

  void notifyPiecePlaced(Position p, Piece piece) {
    for (var curr in listeners) {
      curr.onPiecePlaced(p, piece);
    }
  }

  void notifyGameOver(GameState state) {
    for (var curr in listeners) {
      curr.onGameOver(state);
    }
  }

  void notifyRestart() {
    for (var curr in listeners) {
      curr.onRestart();
    }
  }

  void notifyTimerChange() {
    for (var curr in listeners) {
      curr.onTimerChange();
    }
  }

  void notifySwitchTurn(Turn turn) {
    for (var curr in listeners) {
      curr.onSwitchTurn(turn);
    }
  }

  Piece pieceBasedOnTurn() {
    return _mTurn == Turn.crossTurn ? Piece.Cross : Piece.Zero;
  }

  bool isDraw() {
    return _mState == GameState.Tie;
  }

  @override
  Stopwatch get stopWatch => _stopWatch;

  @override
  Stopwatch get stopWatchLimited => _stopWatchLimited;
}
