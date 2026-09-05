import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/level.dart';
import '../../logic/game_provider.dart';

class TapPuzzle extends StatelessWidget {
  final Level level;

  const TapPuzzle({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> choices = level.metadata?['choices'] ?? [];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            level.question,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        
        Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: choices.map((choice) {
            return GestureDetector(
              onTap: () {
                context.read<GameProvider>().checkAnswer(choice['id']);
              },
              child: Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                  ],
                ),
                alignment: Alignment.center,
                child: Image.asset(choice['asset'], fit: BoxFit.contain),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
