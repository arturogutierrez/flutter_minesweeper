part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  final GameConfiguration gameConfiguration;

  const GameState(this.gameConfiguration);

  @override
  List<Object> get props => [gameConfiguration];
}

class GameInitial extends GameState {
  GameInitial(GameConfiguration gameConfiguration) : super(gameConfiguration);
}

class Playing extends GameState {
  final List<Cell> cells;

  Playing({
    GameConfiguration configuration,
    this.cells,
  }) : super(configuration);

  @override
  List<Object> get props => super.props..add(cells);
}
