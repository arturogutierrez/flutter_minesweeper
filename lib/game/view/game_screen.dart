import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_minesweeper/colors.dart';
import 'package:flutter_minesweeper/game/bloc/game_bloc.dart';
import 'package:flutter_minesweeper/game/model/game_model.dart';

import 'game_cell.dart';

class GameScreen extends StatelessWidget {
  static const routeName = '/game';
  static const configurationKey = 'configuration';

  final GameConfiguration configuration;

  const GameScreen({Key key, @required this.configuration}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(configuration)..add(InitializeGame()),
      child: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('MineSweeper'),
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    BlocProvider.of<GameBloc>(context).add(InitializeGame());
                  },
                ),
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.topCenter,
                  colors: [
                    kBackgroundStartColor,
                    kBackgroundEndColor,
                  ],
                ),
              ),
              child: _getContent(state, context),
            ),
          );
        },
      ),
    );
  }

  Widget _getContent(GameState state, BuildContext context) {
    if (state is Playing) {
      return _gameContent(
        context,
        state.gameConfiguration,
        state.cells,
        state.minesRemaining,
        state.timeElapsed,
        false,
      );
    } else if (state is Finished) {
      return _gameContent(
        context,
        state.gameConfiguration,
        state.cells,
        state.minesRemaining,
        state.timeElapsed,
        state.isWinner,
      );
    }
    return _loading();
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _gameContent(
    BuildContext context,
    GameConfiguration configuration,
    List<Cell> cells,
    int minesRemaining,
    int timeElapsed,
    bool isWinner,
  ) {
    final bloc = BlocProvider.of<GameBloc>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                timeElapsed.toString(),
                style: Theme.of(context).primaryTextTheme.headline5,
              ),
              Spacer(),
              Text(
                minesRemaining.toString(),
                style: Theme.of(context).primaryTextTheme.headline5,
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: configuration.width,
          ),
          itemCount: cells.length,
          itemBuilder: (context, index) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 150),
              child: CellView(
                key: ObjectKey(cells[index]),
                cell: cells[index],
                onLongPress: () {
                  final event = CellLongClicked(index);
                  bloc.add(event);
                },
                onClick: () {
                  final event = CellClicked(index);
                  bloc.add(event);
                },
              ),
            );
          },
        ),
        if (isWinner)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'CONGRATULATIONS',
              style: Theme.of(context).primaryTextTheme.headline4,
            ),
          ),
      ],
    );
  }
}
