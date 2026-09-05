import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/game_provider.dart';
import '../../utils/app_theme.dart';

class LevelHeader extends StatelessWidget {
  const LevelHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Menu/Settings icons
          Row(
            children: [
              _buildIconButton(Icons.settings),
              const SizedBox(width: 10),
              _buildIconButton(Icons.menu),
            ],
          ),
          
          // Center: Level Text
          Consumer<GameProvider>(
            builder: (context, game, child) {
              return Text(
                'LEVEL ${game.currentLevelNumber}',
                style: AppTheme.headerText,
              );
            },
          ),
          
          // Right: Points Counter
          Consumer<GameProvider>(
            builder: (context, game, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Text(
                      '${game.points}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.star, color: Colors.orange, size: 20),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/unzipped_assets/ui/9-Slice/Colored/blue.png'),
          centerSlice: Rect.fromLTWH(10, 10, 28, 28),
          fit: BoxFit.fill,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Icon(icon, size: 24, color: Colors.white),
    );
  }
}
