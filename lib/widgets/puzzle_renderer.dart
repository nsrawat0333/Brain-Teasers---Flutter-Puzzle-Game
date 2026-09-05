import 'package:flutter/material.dart';
import '../models/level.dart';
import 'puzzles/tap_puzzle.dart';
import 'puzzles/drag_drop_puzzle.dart';
import 'puzzles/multi_tap_puzzle.dart';
import 'puzzles/swipe_puzzle.dart';
import 'puzzles/level1_puzzle.dart';
import 'puzzles/level2_puzzle.dart';

class PuzzleRenderer extends StatelessWidget {
  final Level level;

  const PuzzleRenderer({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    switch (level.type) {
      case PuzzleType.tap:
        return TapPuzzle(level: level);
      case PuzzleType.dragAndDrop:
        return DragDropPuzzle(level: level);
      case PuzzleType.multiTap:
        return MultiTapPuzzle(level: level);
      case PuzzleType.swipe:
        return SwipePuzzle(level: level);
      case PuzzleType.level1:
        return Level1Puzzle(level: level);
      case PuzzleType.level2:
        return Level2Puzzle(level: level);
      case PuzzleType.level3:
      case PuzzleType.level4:
      case PuzzleType.level5:
        return Level1Puzzle(level: level); // Fallback to Level 1 style
    }
  }
}
