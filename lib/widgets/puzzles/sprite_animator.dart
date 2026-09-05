import 'dart:async';
import 'package:flutter/material.dart';

class SpriteAnimator extends StatefulWidget {
  final String imagePath;
  final int frameCount;
  final int fps;
  final double width;
  final double height;

  const SpriteAnimator({
    super.key,
    required this.imagePath,
    required this.frameCount,
    this.fps = 10,
    required this.width,
    required this.height,
  });

  @override
  State<SpriteAnimator> createState() => _SpriteAnimatorState();
}

class _SpriteAnimatorState extends State<SpriteAnimator> {
  int _currentFrame = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void didUpdateWidget(SpriteAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imagePath != widget.imagePath) {
      _currentFrame = 0;
    }
  }

  void _startAnimation() {
    _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ widget.fps), (timer) {
      if (!mounted) return;
      setState(() {
        _currentFrame = (_currentFrame + 1) % widget.frameCount;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Uses Align and fraction to show only one frame of the sprite sheet.
    // The sprite sheet is horizontal.
    // Alignment X goes from -1.0 (leftmost) to 1.0 (rightmost).
    // If there are N frames, there are N-1 intervals.
    // The fraction for frame i is i / (N - 1) * 2 - 1.0
    double alignmentX = 0;
    if (widget.frameCount > 1) {
      alignmentX = -1.0 + (_currentFrame / (widget.frameCount - 1)) * 2.0;
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: widget.width * widget.frameCount,
          maxHeight: widget.height,
          alignment: Alignment(alignmentX, 0.0),
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
