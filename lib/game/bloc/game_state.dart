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
  final int minesRemaining;

  Playing({@required GameConfiguration configuration, @required this.cells, @required this.minesRemaining})
      : super(configuration);

  @override
  List<Object> get props => super.props..add([cells, minesRemaining]);
}

class Finished extends GameState {
  final List<Cell> cells;
  final int minesRemaining;

  Finished({@required GameConfiguration configuration, @required this.cells, @required this.minesRemaining})
      : super(configuration);

  @override
  List<Object> get props => super.props..add([cells, minesRemaining]);
}
