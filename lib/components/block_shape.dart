import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../block_sudoku_game.dart';
import '../constants_global.dart';
import 'block_cell.dart';

class BlockShape extends PositionComponent
    with DragCallbacks, CollisionCallbacks, HasGameRef<BlockSudokuGame>{

  final Vector2 blockPosition;
  bool isEnabled;

  late final Vector2 _initialPosition;
  late final Vector2 _offsetPosition;
  late final Vector2 _initialScale;
  late final Vector2 _scaleOnDrag;

  final int _initialPriority = 1;
  final int _priorityOnDrag = 10;

  BlockShape({
    required this.blockPosition,
    this.isEnabled = true,
  }) : super(size: Vector2.all(BlockSudokuGame.blockSize), position: blockPosition, anchor: Anchor.center);

  final _cells = <BlockCell>[];

  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    _initialPosition = blockPosition;
    _offsetPosition = position - Vector2(size.x/2, size.y);
    _initialScale = absoluteScale; // Current scale, note scaling is done from the anchor point
    _scaleOnDrag = Vector2.all(2.1); // Scale when item is being dragged

    var cells = _generateRandomShapeBlockCells();
    _cells.addAll(cells);
    addAll(_cells);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateValues();
    super.update(dt);
  }

  @override
  void onDragStart(DragStartEvent event) {
    if(isEnabled) {
      super.onDragStart(event);
      priority = _priorityOnDrag;
      position = _offsetPosition; // temporary Offset
      scale = _scaleOnDrag;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if(isEnabled) {
      // Return block shape to starting position, disabled it and return it,
      priority = _initialPriority;
      scale = _initialScale;
      position = _initialPosition;
      game.gameWorld.onBlockPieceDragEnded();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) { if(isEnabled) { position +=  event.delta * 35; }}

  getShapeBlockCellsCount() { return _cells.length; }

  _updateValues() {
    var hasAnEnabledCell = _hasAnEnabledCell();
    if(!isEnabled && hasAnEnabledCell){
      for (var i = 0; i < _cells.length; i++) {
        _cells[i].isEnabled = false;
      }
    } else {
      for (var i = 0; i < _cells.length; i++) {
        _cells[i].isEnabled = true;
      }
    }
  }

  _hasAnEnabledCell() {
    var isEnabled = false;
    for (var i = 0; i < _cells.length; i++) {
      if(_cells[i].isEnabled) { isEnabled = true; }
    }
    return isEnabled;
  }

  void setNewUniqueBlockShape() {
    var newCells = _generateRandomShapeBlockCells();
    _cells.clear();
    _cells.addAll(newCells);
    addAll(_cells);
    if(!isEnabled) isEnabled = true;
  }

  _generateRandomShapeBlockCells() {
    var random = Random();
    var randomInt = random.nextInt(constBlockShapesList.length);

    var blockShapeArray = constBlockShapesList[randomInt]; // A 2 x 2 Array of the shape, each shape is 4 x 4
    var shapeBlockSquareWidth = size.x; // Same as block height, e.g 4 x 4 square
    var shapeMaxDimens = blockShapeArray.length;

    var totalSpacing = shapeBlockSquareWidth * BlockSudokuGame.percentCellGapSpacing; // As a percentage of total width or height of block
    var spacing = totalSpacing/(shapeMaxDimens - 1); // 3 spaces between 4 cells, no padding i.e spacing at the edges
    var cellWidth = (shapeBlockSquareWidth - totalSpacing)/shapeMaxDimens; // 4 cells, 3 spaces between the 4 cells, vertical and horizontal, no padding
    var cellHalfWidth = cellWidth/2;

    xPositionValue(int rowIndex) { // Starting from (0, 0) at top left alignment
      return rowIndex == 0 ? cellHalfWidth
          : rowIndex * (spacing + cellWidth) + cellHalfWidth;
    }

    yPositionValue(int columnIndex){
      return columnIndex == 0 ? cellHalfWidth
          : columnIndex * (spacing + cellWidth) + cellHalfWidth;
    }

    var blockCellsList = <BlockCell>[];
    for (int rowIndex = 0; rowIndex < blockShapeArray.length; rowIndex++) {
      var row = blockShapeArray[rowIndex];
      for (int columnIndex = 0; columnIndex < blockShapeArray.length; columnIndex++) {
        var blockValue = row[columnIndex];
        if(blockValue != 0){
          blockCellsList.add(BlockCell(
              cellPosition: Vector2(xPositionValue(rowIndex), yPositionValue(columnIndex)),
              cellSize: Vector2.all(cellWidth),
          ));
        }
      }
    }
    return blockCellsList;
  }
}