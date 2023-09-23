import 'package:block_sudoku/block_sudoku_game.dart';
import 'package:block_sudoku/components/grid_cell.dart';
import 'package:block_sudoku/components/square_painter.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../colors.dart';

class GameGridBoard extends CustomPainterComponent with HasGameRef<BlockSudokuGame> {
  final Vector2 gridSize;
  final Vector2 gridPosition;
  final Anchor gridAnchor;

  GameGridBoard({
    required this.gridSize,
    required this.gridPosition,
    required this.gridAnchor,
  }) : super(size: gridSize, position: gridPosition, anchor: gridAnchor, priority: -2);

  final List<GridCell> _gridCells = [];

  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    painter = CustomRectanglePainter(colorAppPrimary2, cornerRadius: size.x * 0.02);
    debugPrint('Board is at position: $position, '
        '\nhas size: $size, '
        '\nthe center is at: $center'
        '\nisAnchored at $anchor'
    );

    var cells = _generateGridCellList(
        cellSpacing: BlockSudokuGame.gridCellGap,
        cellSize: BlockSudokuGame.gridCellSize
    );

    _gridCells.addAll(cells);
    addAll(_gridCells);
    return super.onLoad();
  }

  bool checkIsGameOver(){
    return false;
  }

  // Acquires the activating block where they activated grid cells
  bool acquireBlockCellsAtActivatedGridCells() {
    var canAcquireBlock = checkCanAcquireDraggingActiveBlock();
    debugPrint('canAcquireBlock: ${canAcquireBlock.toString()}');
    if(canAcquireBlock) {
      for (var i = 0; i < _gridCells.length; i++) {
        if(_gridCells[i].isHighlighted) {
          // debugPrint('There are activated cells at index: $i');
          _gridCells[i].isOccupied = true;
        }
      }
    }
    return canAcquireBlock;
  }

  bool checkCanAcquireDraggingActiveBlock() {
    var draggingActiveBlock = game.gameWorld.getDraggingActiveShapeBlock();
    if(draggingActiveBlock == null) return false;

    var numOfActiveBlockCells = draggingActiveBlock.getShapeBlockCellsCount();
    var numOfTriggeredUnoccupiedGridCells = getTriggeredGridCellsCount();

    var canAcquireBlock = (numOfActiveBlockCells == numOfTriggeredUnoccupiedGridCells);
    if(canAcquireBlock) { // Highlight grid cells that can acquire block cells
      for (var i = 0; i < _gridCells.length ; i++) {
        if(_gridCells[i].isTriggered) {
          _gridCells[i].isHighlighted = true;
        }
      }
    }
    return canAcquireBlock;
  }

  int getTriggeredGridCellsCount() {
    int numOfTriggeredGridCells = 0;
    for (var i = 0; i < _gridCells.length; i++) {
      if(_gridCells[i].isTriggered && !_gridCells[i].isOccupied) {
        numOfTriggeredGridCells ++;
      }
    }
    return numOfTriggeredGridCells;
  }

  int getHighlightedGridCellsCount() {
    int numOfHighlightedGridCells = 0;
    for (var i = 0; i < _gridCells.length; i++) {
      if(_gridCells[i].isHighlighted) { numOfHighlightedGridCells ++; }
    }
    return numOfHighlightedGridCells;
  }

  _generateGridCellList({
    required double cellSpacing,
    required Vector2 cellSize,
  }){
    var cells = <GridCell>[];
    List.generate(9, (yIndex) {
      var cellYPosition = yIndex == 0 ? cellSpacing : yIndex * cellSize.y + (yIndex + 1) * cellSpacing;
      List.generate(9, (xIndex) {
        var cellXPosition = xIndex == 0 ? cellSpacing : xIndex * cellSize.x + (xIndex + 1) * cellSpacing;
        var cellPosition = Vector2(cellXPosition, cellYPosition);
        cells.add(GridCell(
            cellPosition: cellPosition,
            cellSize: cellSize,
            cellAnchor: Anchor.topLeft,
        ));
      });
    });
    return cells;
  }
}