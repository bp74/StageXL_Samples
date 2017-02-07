library example;

// Specials thanks to the creators of the Starling framework!
//
// http://gamua.com/starling
// https://github.com/PrimaryFeather/Memory3D

// This demo was originally created for the awesome Starling framework.
// The Starling framework also introduced the concept of Sprite3D first
// and therefore was a great inspiration for StageXL.

import 'dart:async';
import 'dart:html' as html;
import 'dart:math' hide Point, Rectangle;
import 'package:stagexl/stagexl.dart';

part 'src/card.dart';
part 'src/game.dart';
part 'src/playing_field.dart';

Future main() async {

  // configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.inputEventMode = InputEventMode.MouseAndTouch;
  StageXL.stageOptions.stageScaleMode = StageScaleMode.SHOW_ALL;
  StageXL.stageOptions.stageAlign = StageAlign.NONE;
  StageXL.stageOptions.backgroundColor = Color.Blue;

  // init Stage and RenderLoop

  var stage = new Stage(html.querySelector('#stage'), width:800, height:600);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load the resources

  var resourceManager = new ResourceManager();
  resourceManager.addTextureAtlas("atlas", "images/atlas.json");
  await resourceManager.load();

  // start the game

  var game = new Game(resourceManager);
  stage.addChild(game);
  stage.juggler.add(game);

}
