import 'package:flutter/material.dart';
import 'package:flutter_minesweeper/game/model/game_model.dart';

import '../../assets.dart';

class CellView extends StatelessWidget {
  final Cell cell;
  final Function onClick;
  final Function onLongPress;

  const CellView({
    Key key,
    @required this.cell,
    @required this.onClick,
    @required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      onLongPress: onLongPress,
      child: Image.asset(_imageForCell(cell)),
    );
  }

  String _imageForCell(Cell cell) {
    if (cell is CellClosed) {
      if (cell.isFlagged) {
        return Assets.cellFlagged;
      }
      return Assets.cellClosed;
    } else {
      return Assets.openedCells[cell.content.index];
    }
  }
}
