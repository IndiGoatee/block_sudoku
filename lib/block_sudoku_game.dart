import 'package:block_sudoku/game_world.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';

class BlockSudokuGame extends FlameGame with SingleGameInstance {
  static const double gridCellSquareSize = 1000.0;
  static const double gridCellSquareSizeSmall = 700.0;
  static const double blockSize = 3 * gridCellSquareSizeSmall;
  static const double percentCellGapSpacing = 0.1; // As a percent of a cell width or  height
  static const double gridCellGap = percentCellGapSpacing * gridCellSquareSize; // As a percent of a cell width or  height
  static const double cellCornerRadius = 30.0;
  static const double cellCornerRadiusSmall = 15.0;
  static final Vector2 gridCellSize = Vector2.all(gridCellSquareSize);

  // Grid and block holder pile
  static const double gameGridBoardWidth = (9 * gridCellSquareSize) + (8 * gridCellGap) + (2 * gridCellGap);
  static const double gameGridBoardHeight = gameGridBoardWidth;
  static const double blockHolderBoardWidth = gameGridBoardWidth;
  static const double blockHolderBoardSpacing = (blockHolderBoardWidth - 3*blockSize)/4;
  static const double blockHolderBoardHeight = 5 * gridCellSquareSizeSmall;

  // World Size
  static const gamePadding = 8 * gridCellGap; // Padding for each side, top, left, right, bottom etc
  static const gameSectionsSpacing = 2 * gamePadding;
  static const gameWorldWith = gameGridBoardWidth + (2 * gamePadding); // Added Extra spacing for padding, left and right
  static const  gameWorldHeight = gameGridBoardHeight + gameSectionsSpacing
      + blockHolderBoardHeight + 2 * gamePadding;

  late GameWorld gameWorld;

  @override
  Color backgroundColor() => const Color(0xFFE1E1E1);

  @override
  Future<void> onLoad() async {
    var gameWorldSize = Vector2(gameWorldWith, gameWorldHeight);
    var gameWorldCenterPosition = Vector2(gameWorldWith/2, 0); // Where you consider to be the center of the game world

    // World
    gameWorld = GameWorld(gameWorldSize: gameWorldSize,);
    add(gameWorld);

    // Camera
    final camera = CameraComponent(world: gameWorld)
      ..viewfinder.visibleGameSize = gameWorldSize // Place center
      ..viewfinder.position = gameWorldCenterPosition // World Center to be placed at center of viewport
      ..viewfinder.anchor = Anchor.topCenter; // Center of the viewport
    add(camera);

    return super.onLoad();
  }
}