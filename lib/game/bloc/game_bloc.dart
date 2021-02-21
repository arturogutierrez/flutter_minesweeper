import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/game/model/game_model.dart';

part 'game_event.dart';

part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameConfiguration configuration;

  Timer _timer;

  GameBloc(this.configuration) : super(GameInitial(configuration));

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    final currentState = state;

    if (event is InitializeGame) {
      yield* _mapInitializeGame();
    }

    if (currentState is Playing) {
      if (event is CellLongClicked) {
        yield* _mapCellLongClicked(currentState, event.index);
      } else if (event is CellClicked) {
        yield* _mapCellClicked(currentState, event.index);
      } else if (event is TimeTick) {
        yield* _mapTimeTick(currentState);
      }
    }
  }

  Stream<GameState> _mapInitializeGame() async* {
    final numberOfCells = configuration.width * configuration.height;
    final allCellIndexes = List.generate(numberOfCells, (index) => index)..shuffle();
    final bombIndexes = allCellIndexes.sublist(0, configuration.numberOfMines);

    final emptyCellWithBomb = List.generate(numberOfCells, (index) {
      if (bombIndexes.contains(index)) {
        return CellClosed(content: CellContent.bomb);
      }
      return CellClosed(content: CellContent.zero);
    });
    final cells = emptyCellWithBomb.mapIndexed((index, item) {
      return _calculateContent(emptyCellWithBomb, index, item);
    }).toList();

    yield Playing(
      configuration: configuration,
      cells: cells,
      minesRemaining: configuration.numberOfMines,
      timeElapsed: 0,
    );

    _startTimer();
  }

  Cell _calculateContent(List<CellClosed> emptyCellWithBomb, int index, Cell cell) {
    if (cell.content == CellContent.bomb) {
      return cell;
    }

    final x = index % configuration.width;
    final y = index ~/ configuration.width;

    var bombsAround = 0;
    // Left
    if (x > 0 && _isBomb(emptyCellWithBomb, index - 1)) {
      bombsAround++;
    }
    // Right
    if (x < configuration.width - 1 && _isBomb(emptyCellWithBomb, index + 1)) {
      bombsAround++;
    }
    if (y > 0) {
      // Top Left
      if (x > 0 && _isBomb(emptyCellWithBomb, index - 1 - configuration.width)) {
        bombsAround++;
      }
      // Top Center
      if (_isBomb(emptyCellWithBomb, index - configuration.width)) {
        bombsAround++;
      }
      // Top Right
      if (x < configuration.width - 1 && _isBomb(emptyCellWithBomb, index + 1 - configuration.width)) {
        bombsAround++;
      }
    }

    if (y < configuration.height - 1) {
      // Bottom Left
      if (x > 0 && _isBomb(emptyCellWithBomb, index - 1 + configuration.width)) {
        bombsAround++;
      }
      // Bottom Center
      if (_isBomb(emptyCellWithBomb, index + configuration.width)) {
        bombsAround++;
      }
      // Bottom Right
      if (x < configuration.width - 1 && _isBomb(emptyCellWithBomb, index + 1 + configuration.width)) {
        bombsAround++;
      }
    }

    return CellClosed(content: CellContent.values[bombsAround]);
  }

  bool _isBomb(List<CellClosed> cells, int index) {
    return cells[index].content == CellContent.bomb;
  }

  Stream<GameState> _mapCellLongClicked(Playing state, int index) async* {
    final currentCells = state.cells;
    final cellClicked = currentCells[index];
    if (cellClicked is CellClosed && state.minesRemaining >= 0) {
      final newCells = List.of(currentCells);
      final isFlagged = !cellClicked.isFlagged;
      newCells[index] = CellClosed(
        content: cellClicked.content,
        isFlagged: isFlagged,
      );
      final minesRemaining = isFlagged ? state.minesRemaining - 1 : state.minesRemaining + 1;

      if (minesRemaining == 0 && _isWinner(newCells)) {
        yield _createWinnerState(newCells, state.timeElapsed);
        _stopTimer();
      } else {
        yield Playing(
          configuration: configuration,
          cells: newCells,
          minesRemaining: minesRemaining,
          timeElapsed: state.timeElapsed,
        );
      }
    }
  }

  Stream<GameState> _mapCellClicked(Playing state, int index) async* {
    final currentCells = state.cells;
    final cellClicked = currentCells[index];
    if (cellClicked is CellClosed && !cellClicked.isFlagged) {
      if (cellClicked.content == CellContent.bomb) {
        final newCells = currentCells.map((e) {
          return CellOpened(content: e.content);
        }).toList();

        yield Finished(
          configuration: configuration,
          cells: newCells,
          minesRemaining: state.minesRemaining,
          isWinner: false,
          timeElapsed: state.timeElapsed,
        );

        _stopTimer();
      } else {
        final newCells = List.of(currentCells);
        _openCell(newCells, index);
        yield Playing(
          configuration: configuration,
          cells: newCells,
          minesRemaining: state.minesRemaining,
          timeElapsed: state.timeElapsed,
        );
      }
    }
  }

  void _openCell(List<Cell> cells, int index) {
    if (index < 0 || index >= cells.length) return;

    final cellClicked = cells[index];
    if (cellClicked is CellClosed) {
      cells[index] = CellOpened(content: cellClicked.content);

      final x = index % configuration.width;
      if (cellClicked.content == CellContent.zero) {
        if (x > 0) {
          // Left
          _openCell(cells, index - 1);
          // Top Left
          _openCell(cells, index - 1 - configuration.width);
          // Bottom Left
          _openCell(cells, index - 1 + configuration.width);
        }
        if (x < configuration.width - 1) {
          // Right
          _openCell(cells, index + 1);
          // Top Right
          _openCell(cells, index + 1 - configuration.width);
          // Bottom Right
          _openCell(cells, index + 1 + configuration.width);
        }
        // Top
        _openCell(cells, index - configuration.width);
        // Bottom
        _openCell(cells, index + configuration.width);
      }
    }
  }

  bool _isWinner(List<Cell> cells) {
    return cells.fold(true, (previousValue, cell) {
      if (cell is CellClosed && cell.isFlagged) {
        return previousValue && cell.content == CellContent.bomb;
      }
      return previousValue;
    });
  }

  Finished _createWinnerState(List<Cell> cells, int timeElapsed) {
    final resultCells = cells.map((c) {
      if (c is CellClosed && c.isFlagged) {
        return c;
      }
      return CellOpened(content: c.content);
    }).toList();

    return Finished(
      configuration: configuration,
      cells: resultCells,
      minesRemaining: 0,
      isWinner: true,
      timeElapsed: timeElapsed,
    );
  }

  void _startTimer() {
    _stopTimer();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      add(TimeTick());
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Stream<GameState> _mapTimeTick(Playing currentState) async* {
    yield Playing(
      configuration: currentState.gameConfiguration,
      cells: currentState.cells,
      minesRemaining: currentState.minesRemaining,
      timeElapsed: currentState.timeElapsed + 1,
    );
  }
}

extension _MapIndexed on Iterable {
  Iterable<E> mapIndexed<E, T>(E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in this) {
      yield f(index, item);
      index++;
    }
  }
}
