import 'package:flutter/material.dart';
import 'dart:math';

class LevelVictoryOverlay extends StatefulWidget {
  final VoidCallback onNextPressed;
  final int pointsEarned;

  const LevelVictoryOverlay({
    super.key,
    required this.onNextPressed,
    this.pointsEarned = 10,
  });

  @override
  State<LevelVictoryOverlay> createState() => _LevelVictoryOverlayState();
}

class _LevelVictoryOverlayState extends State<LevelVictoryOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _particleController;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Generate victory confetti particles
    final random = Random();
    for (int i = 0; i < 25; i++) {
      _particles.add(Particle(
        x: random.nextDouble() * 400 - 200,
        y: random.nextDouble() * 300 - 150,
        color: [
          Colors.amber,
          Colors.pinkAccent,
          Colors.cyanAccent,
          Colors.lightGreenAccent,
          Colors.purpleAccent
        ][random.nextInt(5)],
        size: random.nextDouble() * 8 + 4,
        speedY: random.nextDouble() * 2 + 1,
      ));
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.65),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Confetti Particles
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return Stack(
                children: _particles.map((p) {
                  final progress = _particleController.value;
                  final currentY = p.y + (progress * 150 * p.speedY);
                  return Positioned(
                    left: MediaQuery.of(context).size.width / 2 + p.x,
                    top: MediaQuery.of(context).size.height / 2 + (currentY % 300 - 150),
                    child: Opacity(
                      opacity: (1.0 - (progress % 1.0)),
                      child: Container(
                        width: p.size,
                        height: p.size,
                        decoration: BoxDecoration(
                          color: p.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: p.color.withOpacity(0.8), blurRadius: 6),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          // Main Elastic Popup Card
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Container(
              width: 380,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade900, Colors.deepPurple.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.amber.shade400, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Golden 3 Stars Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 48),
                      const SizedBox(width: 4),
                      Transform.translate(
                        offset: const Offset(0, -10),
                        child: const Icon(Icons.star_rounded, color: Colors.amber, size: 64),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 48),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // VICTORY Title Banner
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.yellowAccent, Colors.orangeAccent],
                    ).createShader(bounds),
                    child: const Text(
                      "LEVEL CLEARED!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Points Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.shade300, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "+${widget.pointsEarned} STARS EARNED!",
                          style: const TextStyle(
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Next Level Button
                  InkWell(
                    onTap: widget.onNextPressed,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.greenAccent.shade700, Colors.lightGreen.shade600],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "NEXT LEVEL",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Particle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double speedY;

  Particle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speedY,
  });
}
