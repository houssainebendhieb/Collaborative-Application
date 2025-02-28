import 'package:flutter/material.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Canvas Screen")),
        body: Column(
          children: [
            CustomPaint(
              size: const Size(300, 300),
              painter: TextPainterExample(),
            )
          ],
        ));
  }
}

class TextPainterExample extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a text style
    TextStyle textStyle =const  TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );

    // Create a text span with the desired text and style
    TextSpan textSpan = TextSpan(
      text: 'Hello, Canvas!',
      style: textStyle,
    );

    // Create a paragraph builder to render the text
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    // Layout the text on the canvas (it calculates the size of the text)
    textPainter.layout();

    // Draw the text on the canvas at the desired position
    textPainter.paint(canvas, Offset(50, 50));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
