import 'package:flutter/material.dart';

class BoPainter extends CustomPainter {
  Map<String, dynamic>? detectedObjects;
  // List<String>? detectedClasses;
  final Color color;
  double? strokeWidth, scaleX, scaleY;

  BoPainter({this.scaleX = 1.0, this.scaleY= 1.0, this.detectedObjects = null, this.color = Colors.red, this.strokeWidth = 2.0});
  @override
  void paint(Canvas canvas, Size size) {
    print("In paint method");
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth!;
 
    if (detectedObjects != null)
    {
      detectedObjects!.forEach((key, value) {
        if (value != null && value['xywh'] != null && value['xywh'].length == 4) {
          List<dynamic> box = value['xywh'];
          var rect = Rect.fromLTWH(
            box[0].toDouble() * scaleX, // x
            box[1].toDouble() * scaleY, // y
            box[2].toDouble() * scaleX , // width
            box[3].toDouble() * scaleY, // height
          );
          // String label = Text('data');
          canvas.drawRect(rect, paint);
          
          // Draw the class name above the bounding box
          if (value['className'] != null) {
            String className = value['className'];
            var textSpan = TextSpan(
              text: className,
              style: TextStyle(color: color, fontSize: 16),
            );
            var textPainter = TextPainter(
              text: textSpan,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
            );
            textPainter.layout(
              minWidth: 0,
              maxWidth: size.width +400,
            );
            double yOffset = box[1].toDouble() - box[3].toDouble() - 230 - textPainter.height;
            double xOffset = box[0].toDouble() - box[2].toDouble() + 250;
            textPainter.paint(
              canvas,
              Offset(box[0].toDouble() * scaleX, box[1].toDouble() * scaleY),
            );
          }
        }
      });
    } 
  }

  @override
  bool shouldRepaint(covariant BoPainter oldDelegate) {
    print("In shouldRepaint method");
    return oldDelegate.detectedObjects != detectedObjects;
  }
}
