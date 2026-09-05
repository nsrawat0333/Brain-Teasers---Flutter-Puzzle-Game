import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/level.dart';
import '../../logic/game_provider.dart';

class SwipePuzzle extends StatefulWidget {
  final Level level;

  const SwipePuzzle({super.key, required this.level});

  @override
  State<SwipePuzzle> createState() => _SwipePuzzleState();
}

class _SwipePuzzleState extends State<SwipePuzzle> {
  Offset _position = Offset.zero;
  bool _isSwiped = false;

  @override
  Widget build(BuildContext context) {
    String direction = widget.level.metadata?['swipe_direction'] ?? "any";
    String assetPath = widget.level.metadata?['asset'] ?? 'assets/unzipped_assets/animals/PNG/Round/bear.png';
    String backgroundPath = widget.level.metadata?['background_asset'] ?? 'assets/unzipped_assets/animals/PNG/Round/cow.png';

    return Stack(
      children: [
        // Background target (what is revealed)
        Center(
          child: Image.asset(backgroundPath, width: 120, height: 120),
        ),
        
        // Swipable object
        if (!_isSwiped)
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 60 + _position.dx,
            top: MediaQuery.of(context).size.height / 3 - 60 + _position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _position += details.delta;
                });
                
                // Check if swiped far enough
                if (direction == "left" && _position.dx < -100) {
                   _triggerSuccess();
                } else if (direction == "any" && _position.distance > 100) {
                   _triggerSuccess();
                }
              },
              child: Image.asset(assetPath, width: 120, height: 120),
            ),
          ),
      ],
    );
  }

  void _triggerSuccess() {
    if (!_isSwiped) {
      setState(() {
        _isSwiped = true;
      });
      // The answer expected could be anything, using the one from Level model
      context.read<GameProvider>().checkAnswer(widget.level.expectedAnswer);
    }
  }
}
