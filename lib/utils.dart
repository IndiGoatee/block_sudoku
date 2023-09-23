
import 'package:flame/components.dart';
import 'package:flame/palette.dart';

redMarkerDotAtPosition(Vector2 position){
  return CircleComponent(
    radius: 100.0,
    paint: BasicPalette.red.paint(),
    position: position,
    priority: 10,
  );
}