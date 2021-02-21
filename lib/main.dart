import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/game/model/game_model.dart';
import 'package:flutter_minesweeper/game/view/game_screen.dart';
import 'package:flutter_minesweeper/menu/view/menu_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: MenuScreen.routeName,
      onGenerateRoute: (settings) {
        if (settings.name == GameScreen.routeName) {
          final configuration = settings.arguments as GameConfiguration;

          return MaterialPageRoute(builder: (context) {
            return GameScreen(configuration: configuration);
          });
        } else {
          return MaterialPageRoute(builder: (context) {
            return MenuScreen();
          });
        }
      },
    );
  }
}
