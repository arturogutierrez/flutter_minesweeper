import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_minesweeper/colors.dart';
import 'package:flutter_minesweeper/game/bloc/game_bloc.dart';
import 'package:flutter_minesweeper/game/model/game_model.dart';

import 'game_cell.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final configuration = GameConfiguration(
      width: 8,
      height: 8,
      numberOfMines: 10,
    );

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
              child: state is Playing ? _gameContent(context, state) : _loading(),
            ),
          );
        },
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _gameContent(BuildContext context, Playing state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '00',
                style: Theme.of(context).primaryTextTheme.headline5,
              ),
              Spacer(),
              Text(
                '10',
                style: Theme.of(context).primaryTextTheme.headline5,
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: state.gameConfiguration.width,
          ),
          itemCount: state.cells.length,
          itemBuilder: (context, index) {
            return CellView(cell: state.cells[index]);
          },
        ),
      ],
    );
  }
}
