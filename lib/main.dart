import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'block_sudoku_game.dart';

void main() {
  final game = BlockSudokuGame();
  runApp(SafeArea(child: GameWidget(game: game)));
}