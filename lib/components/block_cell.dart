import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

import '../colors.dart';
import 'cell_painter.dart';

class BlockCell extends CustomPainterComponent with CollisionCallbacks {
  bool isEnabled;
  Vector2 cellSize;
  final Vector2 cellPosition;

  BlockCell({
    this.isEnabled = true,
    required this.cellPosition,
    required this.cellSize,
  }) : super(position: cellPosition, size: cellSize, anchor: Anchor.center);

  static final Paint cellFillPaint = Paint()
    ..color = colorBlock
    ..style = PaintingStyle.fill;

  late final CustomCellRectanglePainter _painter;

  @override
  bool get debugMode => false;

  @override
  Future<void> onLoad() async {
    _painter = CustomCellRectanglePainter(colorAppTertiary);
    painter = _painter;
    add(RectangleHitbox.relative(Vector2.all(0.52), parentSize: size, isSolid: true));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateValues();
    super.update(dt);
  }

  _updateValues() {
    _painter.isEnabled = isEnabled;
    if(!isEnabled) { removeFromParent();  }
  }
}