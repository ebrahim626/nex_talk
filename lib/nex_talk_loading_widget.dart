import 'dart:math';
import 'package:flutter/material.dart';

class NexTalkLoadingWidget extends StatefulWidget {
  const NexTalkLoadingWidget({super.key});

  @override
  State<NexTalkLoadingWidget> createState() => _NexTalkLoadingWidgetState();
}

class _NexTalkLoadingWidgetState extends State<NexTalkLoadingWidget>
    with TickerProviderStateMixin {
  static const Color _brand = Color(0xff6c63ff);

  // Slow rotation for the dashed orbit ring
  late final AnimationController _orbitCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  // Pulse for the logo
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  late final Animation<double> _pulse = Tween<double>(
    begin: 0.90,
    end: 1.05,
  ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

  // Travelling dot along the orbit
  late final Animation<double> _dot = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _orbitCtrl, curve: Curves.linear));

  @override
  void dispose() {
    _orbitCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Orbit ring + travelling dot
          AnimatedBuilder(
            animation: _orbitCtrl,
            builder: (_, __) {
              return CustomPaint(
                size: const Size(100, 100),
                painter: _OrbitPainter(
                  progress: _dot.value,
                  color: _brand,
                ),
              );
            },
          ),

          // Pulsing logo
          AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (_, __) {
              return Transform.scale(
                scale: _pulse.value,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: _brand,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: _brand.withOpacity(
                          0.25 + 0.25 * _pulseCtrl.value,
                        ),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png', // 👈 your logo
                      width: 30,
                      height: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final double progress;
  final Color color;

  const _OrbitPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Dashed ring
    final dashPaint = Paint()
      ..color = color.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const dashCount = 20;
    const dashAngle = (2 * pi) / dashCount;
    const gapRatio = 0.45;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      final sweepAngle = dashAngle * (1 - gapRatio);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        dashPaint,
      );
    }

    // Travelling glowing dot
    final angle = 2 * pi * progress - pi / 2;
    final dotOffset = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );

    // Glow
    canvas.drawCircle(
      dotOffset,
      7,
      Paint()
        ..color = color.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Core dot
    canvas.drawCircle(
      dotOffset,
      3.5,
      Paint()..color = color,
    );

    // Trailing arc
    final trailPaint = Paint()
      ..shader = SweepGradient(
        startAngle: angle - 1.2,
        endAngle: angle,
        colors: [Colors.transparent, color.withOpacity(0.5)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      angle - 1.2,
      1.2,
      false,
      trailPaint,
    );
  }

  @override
  bool shouldRepaint(_OrbitPainter old) => old.progress != progress;
}