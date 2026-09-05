import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/game_provider.dart';

class BottomTools extends StatelessWidget {
  const BottomTools({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hint Button
          GestureDetector(
            onTap: () => context.read<GameProvider>().useHint(),
            child: _buildToolButton(Icons.search, Colors.lightBlue.shade700, '-5', isCost: true),
          ),
          
          _buildToolButton(Icons.card_giftcard, Colors.orange.shade700, ''),
          _buildToolButton(Icons.movie, Colors.purple.shade700, ''),
          
          // Skip Button
          GestureDetector(
            onTap: () => context.read<GameProvider>().skipLevel(),
            child: _buildToolButton(Icons.fast_forward, Colors.pink.shade700, 'SKIP'),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(IconData icon, Color color, String badgeText, {bool isCost = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 28, color: Colors.white),
        ),
        if (badgeText.isNotEmpty)
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCost) const Icon(Icons.star, color: Colors.orange, size: 14),
                  Text(
                    badgeText,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isCost ? Colors.red : Colors.black),
                  ),
                ],
              ),
            ),
          )
      ],
    );
  }
}
