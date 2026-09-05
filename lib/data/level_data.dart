import '../models/level.dart';

class LevelData {
  static const String _adventurerPath = "assets/unzipped_assets/toon_characters/Male adventurer/PNG/Poses/";
  static const String _swatPath = "assets/unzipped_assets/swat/SWAT_1/";
  static const String _zombiePath = "assets/unzipped_assets/zombie/Wild Zombie/";
  static const String _cratesPath = "assets/unzipped_assets/sokoban/PNG/Default size/Crates/";
  static const String _deluxeItemsPath = "assets/unzipped_assets/kenney_platformer-art-deluxe/Base pack/Items/";
  static const String _deluxeTilesPath = "assets/unzipped_assets/kenney_platformer-art-deluxe/Base pack/Tiles/";

  static List<Level> getLevels() {
    return [
      // Level 1: Save Soldier (Godot Level 1)
      Level(
        id: 1,
        question: "Save the soldier from zombies",
        type: PuzzleType.level1,
        expectedAnswer: "saved",
        metadata: {
          "soldier": "${_swatPath}Calm.png",
          "zombie_walk": "${_zombiePath}Walk.png",
          "zombie_eat": "${_zombiePath}Eating.png",
          "barrier": "${_adventurerPath}character_maleAdventurer_idle.png",
          "distractions": [
            "${_cratesPath}crate_02.png",
            "${_cratesPath}crate_03.png",
            "${_cratesPath}crate_04.png",
          ],
        },
        hintText: "Distract zombies by placing the barrier in front of them",
      ),

      // Level 2: Save the Beauty with Tank (Godot Level 2)
      Level(
        id: 2,
        question: "Save the beauty with the tank!",
        type: PuzzleType.level2,
        expectedAnswer: "saved",
        metadata: {
          "hint": "Place tank in front of zombies to fire bullet",
        },
        hintText: "Place tank on the ground between beauty and zombies",
      ),

      // Level 3: Unlock the Door to Unite Love Birds
      Level(
        id: 3,
        question: "Drag the yellow key to open the door and unite love birds!",
        type: PuzzleType.dragAndDrop,
        expectedAnswer: "key",
        metadata: {
          "draggable_items": [
            {
              "id": "key",
              "asset": "${_deluxeItemsPath}keyYellow.png"
            }
          ],
          "drop_targets": [
            {
              "id": "door",
              "asset": "${_deluxeTilesPath}door_closedMid.png"
            }
          ]
        },
        hintText: "Drag the key directly onto the door",
      ),

      // Level 4: Build the Bridge (Multi-Tap Crate)
      Level(
        id: 4,
        question: "Tap the crate 5 times to build the bridge step!",
        type: PuzzleType.multiTap,
        expectedAnswer: 5,
        metadata: {
          "target_asset": "${_cratesPath}crate_01.png",
          "required_taps": 5,
        },
        hintText: "Keep tapping the wooden crate fast",
      ),

      // Level 5: Horizontal Symmetric Bridge Reveal
      Level(
        id: 5,
        question: "Swipe the bush away to complete the horizontal bridge!",
        type: PuzzleType.swipe,
        expectedAnswer: "swiped",
        metadata: {
          "asset": "${_deluxeItemsPath}bush.png",
          "background_asset": "${_deluxeItemsPath}gemGreen.png",
          "swipe_direction": "any"
        },
        hintText: "Drag or swipe the green bush out of the way",
      ),
    ];
  }
}
