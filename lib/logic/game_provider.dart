import 'package:flutter/material.dart';
import '../models/level.dart';
import '../data/level_data.dart';

class GameProvider extends ChangeNotifier {
  List<Level> _levels = [];
  int _currentLevelIndex = 0;
  bool _isLevelCompleted = false;
  int _points = 0; // Points system

  // Callback hooks for UI feedback
  Function(String)? onErrorFeedback;
  Function(String)? onHintFeedback;

  GameProvider() {
    _levels = LevelData.getLevels();
  }

  // Getters
  Level get currentLevel => _levels[_currentLevelIndex];
  bool get isLevelCompleted => _isLevelCompleted;
  int get currentLevelNumber => _currentLevelIndex + 1;
  int get totalLevels => _levels.length;
  int get points => _points;

  // Actions
  void checkAnswer(dynamic answer) async {
    if (_isLevelCompleted) return;

    if (answer == currentLevel.expectedAnswer) {
      _isLevelCompleted = true;
      _points += 10; // Add points on success
      notifyListeners();
      
      // Delay before moving to the next level automatically
      await Future.delayed(const Duration(milliseconds: 1500));
      nextLevel();
    } else {
      if (onErrorFeedback != null) {
        onErrorFeedback!("Wrong answer! Try again.");
      }
    }
  }

  void nextLevel() {
    if (_currentLevelIndex < _levels.length - 1) {
      _currentLevelIndex++;
      _isLevelCompleted = false;
      notifyListeners();
    } else {
      if (onErrorFeedback != null) {
        onErrorFeedback!("You finished all levels! Awesome!");
      }
    }
  }

  void skipLevel() {
    if (_currentLevelIndex < _levels.length - 1) {
      // Just skip, no points awarded
      nextLevel();
    }
  }

  void useHint() {
    if (_points >= 5) {
      _points -= 5;
      notifyListeners();
      
      String hintText = currentLevel.hintText ?? "No hint available for this level.";
      if (onHintFeedback != null) {
        onHintFeedback!(hintText);
      }
    } else {
      if (onErrorFeedback != null) {
        onErrorFeedback!("Not enough points for a hint!");
      }
    }
  }
}
