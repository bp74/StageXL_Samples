library texture_atlas_example;

import 'dart:async';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

part "world.dart";

Future main() async {

  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.bitmapDataLoadOptions.webp = true;

  // init the stage and render loop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 1000, height: 600);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // init the resource manager and wait for completion.

  var resourceManager = new ResourceManager();
  resourceManager.addTextureAtlas("atlas", "images/atlas.json");
  await resourceManager.load();

  // get the TextureAtlas from the resource manager
  // create a new world and add it to the stage and juggler

  var textureAtlas = resourceManager.getTextureAtlas("atlas");
  var world = new World(textureAtlas);
  stage.addChild(world);
  stage.juggler.add(world);
}
