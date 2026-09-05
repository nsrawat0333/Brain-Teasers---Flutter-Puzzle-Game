import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/level.dart';
import '../../logic/game_provider.dart';
import 'sprite_animator.dart';

class Level2Puzzle extends StatefulWidget {
  final Level level;

  const Level2Puzzle({super.key, required this.level});

  @override
  State<Level2Puzzle> createState() => _Level2PuzzleState();
}

class _Level2PuzzleState extends State<Level2Puzzle> with SingleTickerProviderStateMixin {
  late AnimationController _zombieAnimController;
  late Animation<double> _zombiePositionAnim;
  
  bool _isSaved = false;
  bool _tankPlaced = false;
  bool _bulletFired = false;
  double _bulletX = 0.0;
  
  Offset? _tankPos;
  Offset? _ladyPos;

  static const String ladyAsset = "assets/unzipped_assets/toon_characters/Female person/PNG/Poses/character_femalePerson_idle.png";
  static const String zombieWalkAsset = "assets/unzipped_assets/zombie/Wild Zombie/Walk.png";
  static const String zombieEatAsset = "assets/unzipped_assets/zombie/Wild Zombie/Eating.png";
  static const String tankAsset = "assets/unzipped_assets/sokoban/PNG/Default size/Crates/crate_01.png";
  static const String bulletAsset = "assets/unzipped_assets/kenney_platformer-art-deluxe/Base pack/Items/fireball.png";

  @override
  void initState() {
    super.initState();
    _zombieAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    );

    _zombiePositionAnim = Tween<double>(begin: 0.95, end: 0.08).animate(_zombieAnimController)
      ..addListener(() {
        if (!mounted) return;
        setState(() {});
        
        if (_bulletFired && !_isSaved) {
          _bulletX += 25.0;
          final size = MediaQuery.of(context).size;
          final zombieX = size.width * _zombiePositionAnim.value;
          
          if (_bulletX >= zombieX) {
            _zombieAnimController.stop();
            _isSaved = true;
            context.read<GameProvider>().checkAnswer("saved");
            context.read<GameProvider>().onHintFeedback?.call("Tank destroyed the zombies! Beauty saved!");
          }
        } else if (_zombiePositionAnim.value < 0.12 && !_isSaved) {
           _zombieAnimController.reset();
           _zombieAnimController.forward();
        }
      });
      
    _zombieAnimController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_tankPos == null) {
      final size = MediaQuery.of(context).size;
      _tankPos = Offset(size.width * 0.45, size.height * 0.2); 
      _ladyPos = Offset(size.width * 0.08, size.height * 0.75 - 70);
    }
  }

  @override
  void dispose() {
    _zombieAnimController.dispose();
    super.dispose();
  }

  void _onWrongInteraction() {
    if (_isSaved) return;
    context.read<GameProvider>().onErrorFeedback?.call("Place the tank in front of zombies to fire!");
  }

  void _checkTankPlacement(Offset position) {
    if (_isSaved || _tankPlaced) return;
    setState(() {
      _tankPos = position;
    });
    
    final size = MediaQuery.of(context).size;
    final tankX = position.dx;
    final tankY = position.dy;
    final zombieX = size.width * _zombiePositionAnim.value;
    
    // Check if placed horizontally correct AND dragged down towards the ground
    if (tankY > size.height * 0.5 && tankX > size.width * 0.08 && tankX < zombieX) {
      _tankPlaced = true;
      _bulletFired = true;
      _bulletX = tankX + 50;
    } else {
      _onWrongInteraction();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentZombieAsset = _isSaved ? zombieEatAsset : zombieWalkAsset;
    final int zombieFrameCount = _isSaved ? 11 : 10;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final localWidth = constraints.maxWidth;
        final localHeight = constraints.maxHeight;
        
        final groundY = localHeight * 0.75;
        final defaultLadyLeft = localWidth * 0.08;
        final defaultLadyTop = groundY - 70;
        
        final actualLadyPos = _ladyPos ?? Offset(defaultLadyLeft, defaultLadyTop);

        return GestureDetector(
          onTap: _onWrongInteraction,
          child: Container(
            color: Colors.transparent,
            width: localWidth,
            height: localHeight,
            child: Stack(
              children: [
                // Ground Line
                Positioned(
                  left: 0,
                  top: groundY,
                  child: Container(
                    width: localWidth,
                    height: 5,
                    color: Colors.brown.shade600,
                  ),
                ),

                // Lady (Beauty)
                Positioned(
                  left: actualLadyPos.dx,
                  top: actualLadyPos.dy,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(ladyAsset, width: 70, height: 70, fit: BoxFit.contain),
                  ),
                ),

                // Draggable Tank / Defense Item
                if (_tankPos != null)
                  Positioned(
                    left: _tankPos!.dx,
                    top: _tankPlaced ? groundY - 60 : _tankPos!.dy,
                    child: Draggable(
                      feedback: Material(
                        color: Colors.transparent,
                        child: Opacity(
                          opacity: 0.8,
                          child: Image.asset(tankAsset, width: 75, height: 75, fit: BoxFit.contain),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: Image.asset(tankAsset, width: 75, height: 75, fit: BoxFit.contain),
                      ),
                      onDragEnd: (details) {
                        final RenderBox renderBox = context.findRenderObject() as RenderBox;
                        final Offset localPosition = renderBox.globalToLocal(details.offset);
                        _checkTankPlacement(localPosition);
                      },
                      child: Image.asset(tankAsset, width: 75, height: 75, fit: BoxFit.contain),
                    ),
                  ),

                // Fireball / Bullet Fired from Tank
                if (_bulletFired && !_isSaved)
                  Positioned(
                    left: _bulletX,
                    top: groundY - 50,
                    child: Image.asset(bulletAsset, width: 40, height: 40, fit: BoxFit.contain),
                  ),

                // Zombies (Moving horizontally along the ground)
                Positioned(
                  left: localWidth * _zombiePositionAnim.value,
                  top: groundY - 75,
                  child: GestureDetector(
                    onTap: _onWrongInteraction,
                    child: Transform.scale(
                      scaleX: -1,
                      child: Row(
                        children: [
                          SpriteAnimator(imagePath: currentZombieAsset, frameCount: zombieFrameCount, width: 75, height: 75),
                          const SizedBox(width: 4),
                          SpriteAnimator(imagePath: currentZombieAsset, frameCount: zombieFrameCount, width: 75, height: 75),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
