import 'package:flutter/material.dart';

// 矢印ボタン
class ArrowButton extends StatelessWidget {
  final double size;
  final Color color;
  final VoidCallback onPressed;
  final bool isButtonEnabled; // 条件によってボタンを有効/無効にするためのプロパティ

  const ArrowButton({
    super.key,
    required this.size,
    required this.color,
    required this.onPressed,
    required this.isButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isButtonEnabled ? onPressed : null, // 条件に応じてボタンを有効/無効にする
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: Size(1.7 * size, size),
            painter: ArrowButtonPainter(color),
          ),
          const Text(
            'Next',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowButtonPainter extends CustomPainter {
  final Color color;

  ArrowButtonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double arrowWidth = size.width;
    final double arrowHeight = size.height;

    final Path path = Path()
      ..moveTo(0, 0.15 * arrowHeight)
      ..lineTo(0.66 * arrowWidth, 0.15 * arrowHeight)
      ..lineTo(0.66 * arrowWidth, 0)
      ..lineTo(size.width, 0.5 * arrowHeight)
      ..lineTo(0.66 * arrowWidth, size.height)
      ..lineTo(0.66 * arrowWidth, 0.85 * size.height)
      ..lineTo(0, 0.85 * arrowHeight)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// 矢印ボタン
class AntiArrowButton extends StatelessWidget {
  final double size;
  final Color color;
  final VoidCallback onPressed;
  final bool isButtonEnabled; // 条件によってボタンを有効/無効にするためのプロパティ

  const AntiArrowButton({
    super.key,
    required this.size,
    required this.color,
    required this.onPressed,
    required this.isButtonEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isButtonEnabled ? onPressed : null, // 条件に応じてボタンを有効/無効にする
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: Size(1.7 * size, size),
            painter: AntiArrowButtonPainter(color),
          ),
          const Text(
            'Next',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class AntiArrowButtonPainter extends CustomPainter {
  final Color color;

  AntiArrowButtonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double arrowWidth = size.width;
    final double arrowHeight = size.height;

    final Path path = Path()
      ..moveTo(size.width, 0.15 * arrowHeight)
      ..lineTo(0.33 * arrowWidth, 0.15 * arrowHeight)
      ..lineTo(0.33 * arrowWidth, 0)
      ..lineTo(0, 0.5 * arrowHeight)
      ..lineTo(0.33 * arrowWidth, size.height)
      ..lineTo(0.33 * arrowWidth, 0.85 * size.height)
      ..lineTo(size.width, 0.85 * arrowHeight)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
