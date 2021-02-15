import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_minesweeper/game/model/game_model.dart';

part 'game_event.dart';

part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameConfiguration configuration;

  GameBloc(this.configuration) : super(GameInitial(configuration));

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    final currentState = state;

    if (event is InitializeGame) {
      yield* _mapInitializeGame();
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
    );
  }

  Cell _calculateContent(List<CellClosed> emptyCellWithBomb, int index, Cell cell) {
    if (cell.content == CellContent.bomb) {
      return cell;
    }

    final x = index % configuration.height;
    final y = index ~/ configuration.height;

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

    return CellOpened(content: CellContent.values[bombsAround]);
  }

  bool _isBomb(List<CellClosed> cells, int index) {
    return cells[index].content == CellContent.bomb;
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
