library texture_atlas_example;

import 'dart:async';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

part "world.dart";

Future main() async {

  // init the stage and render loop, opt in for webGL

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, webGL: true, width: 1000, height: 600);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // init the resource manager and opt in for webp images
  // loading assets is an async operation!

  BitmapData.defaultLoadOptions.webp = true;

  var resourceManager = new ResourceManager();
  resourceManager.addTextureAtlas("atlas", "images/atlas.json");
  await resourceManager.load();

  // get the TextureAltas from the resource manager
  // create a new world and add it to the stage and juggler

  var textureAtlas = resourceManager.getTextureAtlas("atlas");
  var world = new World(textureAtlas);
  stage.addChild(world);
  stage.juggler.add(world);

}
