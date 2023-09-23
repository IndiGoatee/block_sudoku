import 'dart:ui';

// Colors
const colorAppPrimary = Color(0xffd2cece);
const colorAppPrimary2 = Color(0xffa49898);
const colorSecondary = Color(0xff8c7171);
const colorAppTertiary = Color(0xff4f3c3c);

const colorGridCell = Color(0xffc2bcbc);
const colorBlock = colorSecondary;
const colorBlockBorder = colorAppTertiary;


// Painters
final gridCellInactivePainter = Paint()
  ..style = PaintingStyle.fill
  ..color = colorAppPrimary;

final gridCellActivePainter = Paint()
  ..style = PaintingStyle.fill
  ..color = colorAppPrimary2;

final gridCellOccupiedPainter = Paint()
  ..style = PaintingStyle.fill
  ..color = colorSecondary;