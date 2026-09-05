enum PuzzleType {
  tap,
  dragAndDrop,
  multiTap,
  swipe,
  level1, // Save the soldier from zombies
  level2, // Save the beauty with tank
  level3, // Unite the two love birds
  level4, // Build the Truss Bridge
  level5, // Horizontal Symmetric Bridge
}

class Level {
  final int id;
  final String question;
  final PuzzleType type;
  final dynamic expectedAnswer;
  final Map<String, dynamic>? metadata;
  final String? hintText;

  Level({
    required this.id,
    required this.question,
    required this.type,
    required this.expectedAnswer,
    this.metadata,
    this.hintText,
  });
}
