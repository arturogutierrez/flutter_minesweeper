import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/game/model/game_model.dart';
import 'package:flutter_minesweeper/game/view/game_screen.dart';

class MenuScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MineSweeper'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
              child: Text('EASY'),
              onPressed: () => _onEasyClicked(context),
            ),
            SizedBox(height: 24),
            RaisedButton(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
              child: Text('NORMAL'),
              onPressed: () => _onNormalClicked(context),
            ),
            SizedBox(height: 24),
            RaisedButton(
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
              child: Text('HARD'),
              onPressed: () => _onHardClicked(context),
            ),
          ],
        ),
      ),
    );
  }

  _onEasyClicked(BuildContext context) {
    final configuration = GameConfiguration(
      width: 8,
      height: 8,
      numberOfMines: 10,
    );

    _navigateToGame(context, configuration);
  }

  _onNormalClicked(BuildContext context) {
    final configuration = GameConfiguration(
      width: 10,
      height: 11,
      numberOfMines: 15,
    );

    _navigateToGame(context, configuration);
  }

  _onHardClicked(BuildContext context) {
    final configuration = GameConfiguration(
      width: 12,
      height: 18,
      numberOfMines: 25,
    );

    _navigateToGame(context, configuration);
  }

  void _navigateToGame(BuildContext context, GameConfiguration configuration) {
    Navigator.pushNamed(
      context,
      GameScreen.routeName,
      arguments: configuration,
    );
  }
}
