part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class InitializeGame extends GameEvent {
  const InitializeGame();
}

class CellClicked extends GameEvent {
  final int index;

  CellClicked(this.index);

  @override
  List<Object> get props => [index];
}

class CellLongClicked extends GameEvent {
  final int index;

  CellLongClicked(this.index);

  @override
  List<Object> get props => [index];
}

class TimeTick extends GameEvent {}
