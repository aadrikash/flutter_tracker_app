import 'package:flutter/material.dart';
import 'dart:math';

class PieChartWidget extends StatefulWidget {
  final double income;
  final double expense;

  PieChartWidget({required this.income, required this.expense});

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.income + widget.expense;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size(180, 180),
          painter: PieChartPainter(
            income: widget.income,
            expense: widget.expense,
            animationValue: controller.value,
          ),
        );
      },
    );
  }
}

class PieChartPainter extends CustomPainter {
  final double income;
  final double expense;
  final double animationValue;

  PieChartPainter({
    required this.income,
    required this.expense,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double total = income + expense;
    if (total == 0) return;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25;

    double startAngle = -pi / 2;
    double sweepIncome = (income / total) * 2 * pi * animationValue;
    double sweepExpense = (expense / total) * 2 * pi * animationValue;

    // Income
    paint.color = Colors.green;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle,
      sweepIncome,
      false,
      paint,
    );

    // Expense
    paint.color = Colors.red;
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      startAngle + sweepIncome,
      sweepExpense,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
