import 'dart:ui';

import 'package:block_sudoku/components/block_shape.dart';
import 'package:block_sudoku/utils.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import 'block_sudoku_game.dart';
import 'components/grid_board.dart';
import 'components/holding_board.dart';

class GameWorld extends World with HasGameRef<BlockSudokuGame>, HasCollisionDetection {
  final Vector2 gameWorldSize;

  GameWorld({required this.gameWorldSize});

  static final defaultFillPainter = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xffc2bcbc);

  static final defaultBorderPainter = Paint()
    ..style = PaintingStyle.stroke
    ..color = const Color(0xff8c7171)
    ..strokeWidth = 6.0;

  late final GameGridBoard gameGrid;
  late final BlockHolderBoard _blockHolderBoard;

  late final _holderBlocksList = <BlockShape>[];
  late final _blockHolderPositions = <Vector2>[];

  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {

    // GRID <--------------------------------------------------------------------------------
    // Grid board, grid board container, holds all the cells
    var gridSize = Vector2(BlockSudokuGame.gameGridBoardWidth, BlockSudokuGame.gameGridBoardHeight);
    var gridBoxPosition = Vector2(0, BlockSudokuGame.gamePadding);

    gameGrid = GameGridBoard(
        gridSize: gridSize,
        gridAnchor: Anchor.topLeft,
        gridPosition: Vector2(BlockSudokuGame.gamePadding, BlockSudokuGame.gamePadding),
    );
    add(gameGrid);
    // ---------------------------------------------------------------------------------------

    // BLOCK SHAPE HOLDER AND HOLDER POSITIONS <----------------------------------------------
    // Piece Holder, the board or containment area that holds pieces
    var blockHoldingPadY = gameGrid.size.y
        + BlockSudokuGame.gamePadding + BlockSudokuGame.gamePadding;
    _blockHolderBoard = BlockHolderBoard(
      holderSize: Vector2(BlockSudokuGame.blockHolderBoardWidth, BlockSudokuGame.blockHolderBoardHeight),
      holderPosition: Vector2(BlockSudokuGame.gamePadding, blockHoldingPadY),
      holderAnchor: Anchor.topLeft,
    );
    add(_blockHolderBoard);

    _blockHolderPositions.addAll([
      _blockHolderBoard.center,
      _blockHolderBoard.center - Vector2(BlockSudokuGame.blockHolderBoardSpacing
          + BlockSudokuGame.blockSize, 0),
      _blockHolderBoard.center + Vector2(BlockSudokuGame.blockHolderBoardSpacing
          + BlockSudokuGame.blockSize, 0),
    ]);

    if(!debugMode){
      for (var position in _blockHolderPositions) {
        add(redMarkerDotAtPosition(position));
      }
    }

    // Add block pieces
    addHolderShapeBlockSet();
    // ---------------------------------------------------------------------------------------

    super.onLoad();
  }

  onBlockPieceDragEnded() {
    var dragActiveBlock = getDraggingActiveShapeBlock();
    debugPrint('onBlockPieceDragStarted(), dragActiveBlock: ${dragActiveBlock.position}');
    // Acquire the block shape in the grid and disable it if it was acquired
    // successfully by the game grid and wait to refresh
    var wasBlockAcquired = gameGrid.acquireBlockCellsAtActivatedGridCells();
    if(wasBlockAcquired) { dragActiveBlock.isEnabled = false; } // Disable, already returned to holder

    // Refill blocks with new unique shapes if required
    Future.delayed(const Duration(milliseconds: 100),() {
      refillHolderBlocks();
    });
  }

  getDraggingActiveShapeBlock() {
    return _holderBlocksList.firstWhere((blockShape) {
      return blockShape.isDragged;
    });
  }

  void addHolderShapeBlockSet() {
    var blocks = <BlockShape>[];
    for (int i = 0; i < _blockHolderPositions.length; i++) {
      blocks.add(BlockShape(blockPosition: _blockHolderPositions[i], isEnabled: true));
    }
    _holderBlocksList.addAll(blocks);
    addAll(_holderBlocksList);
  }

  bool refillHolderBlocks() {
    var requiresRefill = true;
    for (var i = 0; i < _holderBlocksList.length; i++) {
      // Check has alt least 1 enabled block
      if(_holderBlocksList[i].isEnabled) {
        requiresRefill = false;
      }
    }

    if(requiresRefill) {
      for (var i = 0; i < _holderBlocksList.length; i++) {
        _holderBlocksList[i].setNewUniqueBlockShape();
      }
    }
    return requiresRefill;
  }
}