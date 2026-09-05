import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/level.dart';
import '../../logic/game_provider.dart';

class DragDropPuzzle extends StatefulWidget {
  final Level level;

  const DragDropPuzzle({super.key, required this.level});

  @override
  State<DragDropPuzzle> createState() => _DragDropPuzzleState();
}

class _DragDropPuzzleState extends State<DragDropPuzzle> {
  bool _isDropped = false;

  @override
  Widget build(BuildContext context) {
    final draggableItem = widget.level.metadata?['draggable_items']?[0];
    final dropTarget = widget.level.metadata?['drop_targets']?[0];

    return Stack(
      children: [
        // Target Area
        Positioned(
          top: 200,
          right: 50,
          child: DragTarget<String>(
            builder: (context, candidateData, rejectedData) {
              return Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: candidateData.isNotEmpty ? Colors.green : Colors.transparent, 
                    width: 3,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(dropTarget['asset'], width: 100, height: 100),
                    if (_isDropped)
                      Image.asset(draggableItem['asset'], width: 60, height: 60), // Shows dropped item inside
                  ],
                ),
              );
            },
            onWillAcceptWithDetails: (details) => details.data == draggableItem['id'],
            onAcceptWithDetails: (details) {
              setState(() {
                _isDropped = true;
              });
              context.read<GameProvider>().checkAnswer(widget.level.expectedAnswer);
            },
          ),
        ),

        // Draggable Item
        if (!_isDropped)
          Positioned(
            top: 50,
            left: 50,
            child: Draggable<String>(
              data: draggableItem['id'],
              feedback: _buildDraggable(draggableItem['asset'], opacity: 0.8),
              childWhenDragging: _buildDraggable(draggableItem['asset'], opacity: 0.3),
              child: _buildDraggable(draggableItem['asset']),
            ),
          ),
      ],
    );
  }

  Widget _buildDraggable(String assetPath, {double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Image.asset(assetPath, width: 80, height: 80),
    );
  }
}
