import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../block_sudoku_game.dart';
import '../colors.dart';
import 'block_cell.dart';
import 'cell_painter.dart';

class GridCell extends CustomPainterComponent with CollisionCallbacks, HasGameRef<BlockSudokuGame> {
  final Vector2 cellPosition;
  final Anchor cellAnchor;
  final Vector2 cellSize;
  bool isOccupied;
  bool isTriggered;
  bool isHighlighted;

  GridCell({
    required this.cellPosition,
    required this.cellSize,
    this.cellAnchor = Anchor.center,
    this.isOccupied = false,
    this.isTriggered = false,
    this.isHighlighted = false
  }) : super(position: cellPosition, size: cellSize, anchor: cellAnchor, priority: -1);

  static final RRect cellRRect = RRect.fromRectAndRadius(
    Vector2.all(BlockSudokuGame.gridCellSquareSize).toRect(),
    const Radius.circular(BlockSudokuGame.cellCornerRadius),
  );

  late final CustomCellRectanglePainter _painter;

  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    _painter = CustomCellRectanglePainter(colorAppPrimary);
    painter = _painter;
    add(RectangleHitbox.relative(Vector2.all(0.52), parentSize: size, isSolid: true));
    // add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateValues();
    super.update(dt);
  }

  _updateValues() {
    if(isOccupied) {_painter.color = colorAppTertiary; }
    else if(isHighlighted) {
      if(isOccupied) { /* Todo check that is highlighted and occupied */ }
      _painter.color = colorAppPrimary2;
    }
    else{ _painter.color = colorAppPrimary; }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is BlockCell) {
      // debugPrint('Collision Started on gridCell');
      isTriggered = true;
      game.gameWorld.gameGrid.checkCanAcquireDraggingActiveBlock();
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (other is BlockCell) {
      debugPrint('Collision has Ended on gridCell');
      isTriggered = false;
      isHighlighted = false;
    }
  }
}