import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/game/model/game_model.dart';

import '../../assets.dart';

class CellView extends StatelessWidget {
  final Cell cell;

  const CellView({
    Key key,
    @required this.cell,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onClick,
      child: Image.asset(_imageForCell(cell)),
    );
  }

  void _onClick() {}

  String _imageForCell(Cell cell) {
    if (cell is CellClosed) {
      return Assets.cellClosed;
    } else {
      return Assets.openedCells[cell.content.index];
    }
  }
}
