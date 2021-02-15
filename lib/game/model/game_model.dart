import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

enum CellContent {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  bomb,
}

abstract class Cell extends Equatable {
  final CellContent content;

  Cell({
    @required this.content,
  });

  @override
  List<Object> get props => [content];
}

class CellClosed extends Cell {
  final bool isFlagged;

  CellClosed({
    @required CellContent content,
    this.isFlagged,
  }) : super(content: content);

  @override
  List<Object> get props => super.props..add(isFlagged);
}

class CellOpened extends Cell {
  CellOpened({
    @required CellContent content,
  }) : super(content: content);
}

class GameConfiguration {
  final int width;
  final int height;
  final int numberOfMines;

  GameConfiguration({
    @required this.width,
    @required this.height,
    @required this.numberOfMines,
  });
}
