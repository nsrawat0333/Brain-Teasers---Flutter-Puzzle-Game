import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../models/level.dart';
import '../../logic/game_provider.dart';
import 'sprite_animator.dart';

class Level1Puzzle extends StatefulWidget {
  final Level level;

  const Level1Puzzle({super.key, required this.level});

  @override
  State<Level1Puzzle> createState() => _Level1PuzzleState();
}

class _Level1PuzzleState extends State<Level1Puzzle> with SingleTickerProviderStateMixin {
  late AnimationController _zombieAnimController;
  late Animation<double> _zombiePositionAnim;
  
  bool _isSaved = false;
  bool _isBarrierPlacedCorrectly = false;
  Offset? _barrierPos;
  Offset? _soldierPos;
  final List<Offset> _confusionOffsets = [];

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
        
        final size = MediaQuery.of(context).size;
        final zombieX = size.width * _zombiePositionAnim.value;
        
        if (_isBarrierPlacedCorrectly && !_isSaved && _barrierPos != null) {
          final barrierX = _barrierPos!.dx;
          if (zombieX <= barrierX + 70) {
            _zombieAnimController.stop();
            _isSaved = true;
            context.read<GameProvider>().checkAnswer("saved");
            context.read<GameProvider>().onHintFeedback?.call("Smart move!");
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
    if (_confusionOffsets.isEmpty) {
      final size = MediaQuery.of(context).size;
      final random = Random();
      final distractions = widget.level.metadata!["distractions"] as List;
      
      for (var _ in distractions) {
        _confusionOffsets.add(Offset(
          random.nextDouble() * (size.width * 0.6) + (size.width * 0.2),
          random.nextDouble() * (size.height * 0.25) + 60,
        ));
      }
      
      _barrierPos = Offset(size.width * 0.45, size.height * 0.2); 
      _soldierPos = Offset(size.width * 0.08, size.height * 0.75 - 70);
    }
  }

  @override
  void dispose() {
    _zombieAnimController.dispose();
    super.dispose();
  }

  void _onWrongInteraction() {
    if (_isSaved) return;
    context.read<GameProvider>().onErrorFeedback?.call("Think differently! Place the barrier in front of zombies.");
  }

  void _checkBarrierPlacement(Offset position) {
    if (_isSaved) return;
    setState(() {
      _barrierPos = position;
    });
    
    final size = MediaQuery.of(context).size;
    final barrierX = position.dx;
    final barrierY = position.dy;
    final zombieX = size.width * _zombiePositionAnim.value;
    
    // Check if it's placed horizontally correct AND dragged down towards the ground
    if (barrierY > size.height * 0.5 && barrierX > size.width * 0.08 && barrierX < zombieX) {
      _isBarrierPlacedCorrectly = true;
    } else {
      _isBarrierPlacedCorrectly = false;
      _onWrongInteraction();
    }
  }

  @override
  Widget build(BuildContext context) {
    final soldierAsset = widget.level.metadata!["soldier"];
    final zombieAssetWalk = widget.level.metadata!["zombie_walk"];
    final zombieAssetEat = widget.level.metadata!["zombie_eat"];
    final barrierAsset = widget.level.metadata!["barrier"];
    final distractions = widget.level.metadata!["distractions"] as List;
    
    final currentZombieAsset = _isSaved ? zombieAssetEat : zombieAssetWalk;
    final int zombieFrameCount = _isSaved ? 11 : 10;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final localWidth = constraints.maxWidth;
        final localHeight = constraints.maxHeight;
        
        final groundY = localHeight * 0.75;
        final defaultSoldierLeft = localWidth * 0.08;
        final defaultSoldierTop = groundY - 70;
        
        final actualSoldierPos = _soldierPos ?? Offset(defaultSoldierLeft, defaultSoldierTop);

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

                // Soldier (Draggable)
                Positioned(
                  left: actualSoldierPos.dx,
                  top: actualSoldierPos.dy,
                  child: Draggable(
                    feedback: Material(
                      color: Colors.transparent,
                      child: Opacity(
                        opacity: 0.8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(soldierAsset, width: 70, height: 70, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(soldierAsset, width: 70, height: 70, fit: BoxFit.contain),
                      ),
                    ),
                    onDragEnd: (details) {
                      final RenderBox renderBox = context.findRenderObject() as RenderBox;
                      final Offset localPosition = renderBox.globalToLocal(details.offset);
                      setState(() {
                        _soldierPos = localPosition;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(soldierAsset, width: 70, height: 70, fit: BoxFit.contain),
                    ),
                  ),
                ),
                
                // Distraction Objects
                ...List.generate(distractions.length, (index) {
                  return Positioned(
                    left: _confusionOffsets[index].dx,
                    top: _confusionOffsets[index].dy,
                    child: Draggable(
                      feedback: Material(
                        color: Colors.transparent,
                        child: Opacity(
                          opacity: 0.8,
                          child: Image.asset(distractions[index], width: 60, height: 60, fit: BoxFit.contain),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: Image.asset(distractions[index], width: 60, height: 60, fit: BoxFit.contain),
                      ),
                      onDragEnd: (details) {
                        final RenderBox renderBox = context.findRenderObject() as RenderBox;
                        final Offset localPosition = renderBox.globalToLocal(details.offset);
                        setState(() {
                          _confusionOffsets[index] = localPosition;
                        });
                      },
                      child: Image.asset(distractions[index], width: 60, height: 60, fit: BoxFit.contain),
                    ),
                  );
                }),

                // Draggable Barrier Object
                if (_barrierPos != null)
                  Positioned(
                    left: _barrierPos!.dx,
                    top: _isSaved ? _barrierPos!.dy + 15 : _barrierPos!.dy,
                    child: _isSaved 
                      ? Transform.rotate(
                          angle: -pi / 2,
                          child: Image.asset(barrierAsset, width: 70, height: 70, fit: BoxFit.contain),
                        )
                      : Draggable(
                          feedback: Material(
                            color: Colors.transparent,
                            child: Opacity(
                              opacity: 0.8,
                              child: Image.asset(barrierAsset, width: 70, height: 70, fit: BoxFit.contain),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: Image.asset(barrierAsset, width: 70, height: 70, fit: BoxFit.contain),
                          ),
                          onDragEnd: (details) {
                            final RenderBox renderBox = context.findRenderObject() as RenderBox;
                            final Offset localPosition = renderBox.globalToLocal(details.offset);
                            _checkBarrierPlacement(localPosition);
                          },
                          child: Image.asset(barrierAsset, width: 70, height: 70, fit: BoxFit.contain),
                        ),
                  ),

                // Zombies (Moving horizontally along the ground)
                Positioned(
                  left: localWidth * _zombiePositionAnim.value,
                  top: groundY - 75,
                  child: GestureDetector(
                    onTap: _onWrongInteraction,
                    onPanStart: (_) => _onWrongInteraction(),
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
