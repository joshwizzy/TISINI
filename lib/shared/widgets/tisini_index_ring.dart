import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tisini/core/constants/app_colors.dart';
import 'package:tisini/core/constants/app_typography.dart';

class TisiniIndexRing extends StatefulWidget {
  const TisiniIndexRing({
    required this.score,
    super.key,
    this.size = 200,
    this.showLabel = false,
  });

  final int score;
  final double size;
  final bool showLabel;

  static Color zoneColor(int score) {
    if (score <= 30) return AppColors.zoneRed;
    if (score <= 60) return AppColors.zoneAmber;
    return AppColors.zoneGreen;
  }

  @override
  State<TisiniIndexRing> createState() => _TisiniIndexRingState();
}

class _TisiniIndexRingState extends State<TisiniIndexRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.score.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void didUpdateWidget(TisiniIndexRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation =
          Tween<double>(
            begin: _animation.value,
            end: widget.score.toDouble(),
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMini = widget.size < 150;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final animatedScore = _animation.value;
            return SizedBox(
              width: widget.size,
              height: widget.size,
              child: CustomPaint(
                painter: _RingPainter(
                  score: animatedScore,
                  color: TisiniIndexRing.zoneColor(animatedScore.round()),
                ),
                child: Center(
                  child: Text(
                    '${animatedScore.round()}',
                    style: isMini
                        ? AppTypography.headlineMedium
                        : AppTypography.displayLarge.copyWith(fontSize: 48),
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.showLabel) ...[
          const SizedBox(height: 8),
          const Text(
            'Operational view (not a rating)',
            style: AppTypography.bodySmall,
          ),
        ],
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.score, required this.color});

  final double score;
  final Color color;

  static const _maxScore = 90.0;
  static const _sweepAngle = 270.0;
  // Start from bottom-left: 135 degrees (in radians)
  static const _startAngle = 135.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 16) / 2;
    const strokeWidth = 12.0;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // Background arc
    final bgPaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      _startAngle * math.pi / 180,
      _sweepAngle * math.pi / 180,
      false,
      bgPaint,
    );

    // Score arc
    final scoreSweep = (score.clamp(0, _maxScore) / _maxScore) * _sweepAngle;
    if (scoreSweep > 0) {
      final scorePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        _startAngle * math.pi / 180,
        scoreSweep * math.pi / 180,
        false,
        scorePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.score != score || oldDelegate.color != color;
}
