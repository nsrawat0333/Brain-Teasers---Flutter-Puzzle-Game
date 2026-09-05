import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/level.dart';
import '../../logic/game_provider.dart';

class MultiTapPuzzle extends StatefulWidget {
  final Level level;

  const MultiTapPuzzle({super.key, required this.level});

  @override
  State<MultiTapPuzzle> createState() => _MultiTapPuzzleState();
}

class _MultiTapPuzzleState extends State<MultiTapPuzzle> with SingleTickerProviderStateMixin {
  int _tapCount = 0;
  late int _requiredTaps;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _requiredTaps = widget.level.metadata?['required_taps'] ?? 3;
    
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _tapCount++;
    });
    
    // Quick shake animation on tap
    _shakeController.forward(from: 0.0);

    if (_tapCount >= _requiredTaps) {
      context.read<GameProvider>().checkAnswer(_requiredTaps);
    }
  }

  @override
  Widget build(BuildContext context) {
    String targetAsset = widget.level.metadata?['target_asset'] ?? 'assets/unzipped_assets/animals/PNG/Round/bear.png';

    return Center(
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            final dx = _shakeController.isAnimating ? (1.0 - _shakeController.value) * 10 * (_tapCount % 2 == 0 ? 1 : -1) : 0.0;
            return Transform.translate(
              offset: Offset(dx, 0),
              child: child,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(targetAsset, width: 150, height: 150),
              const SizedBox(height: 20),
              Text(
                "$_tapCount / $_requiredTaps",
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
