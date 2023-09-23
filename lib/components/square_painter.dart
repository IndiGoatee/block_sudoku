import 'package:flutter/widgets.dart';

class CustomRectanglePainter extends CustomPainter {
  Color color;
  double? cornerRadius;

  CustomRectanglePainter(this.color, {this.cornerRadius});

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width/2, size.height/2);
    var roundedRectangle = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: size.width, height: size.height),
      Radius.circular(cornerRadius ?? size.width * 0.1),
    );
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawRRect(roundedRectangle, paint);
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(CustomRectanglePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.cornerRadius != cornerRadius;
  }
}
