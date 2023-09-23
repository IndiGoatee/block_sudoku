import 'package:block_sudoku/block_sudoku_game.dart';
import 'package:block_sudoku/components/square_painter.dart';
import 'package:flame/components.dart';

import '../colors.dart';

class BlockHolderBoard extends CustomPainterComponent with HasGameRef<BlockSudokuGame> {
  final Vector2 holderSize;
  final Vector2 holderPosition;
  final Anchor holderAnchor;

  BlockHolderBoard({
    required this.holderSize,
    required this.holderPosition,
    this.holderAnchor = Anchor.center
  }) : super(
      size: holderSize,
      position: holderPosition,
      anchor: holderAnchor,
      priority: -2
  );

  late PositionComponent blockHolderPosition1Component;
  late PositionComponent blockHolderPosition2Component;
  late PositionComponent blockHolderPosition3Component;


  @override
  bool get debugMode => true;


  @override
  Future<void> onLoad() async {
    painter = CustomRectanglePainter(colorAppPrimary, cornerRadius: size.x * 0.02);
    return super.onLoad();
  }
}