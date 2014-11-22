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

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

void main() {

  stage = new Stage(html.querySelector('#stage'), webGL: true, width:800, height:600);
  stage.backgroundColor = Color.Blue;
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  Multitouch.inputMode = Multitouch.supportsTouchEvents
      ? MultitouchInputMode.TOUCH_POINT
      : MultitouchInputMode.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  resourceManager = new ResourceManager();
  resourceManager.addTextureAtlas("atlas", "images/atlas.json", TextureAtlasFormat.JSONARRAY);
  resourceManager.load().then((_) {
    var game = new Game();
    stage.addChild(game);
    stage.juggler.add(game);
  });
}
