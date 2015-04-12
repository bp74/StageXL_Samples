library texture_atlas_example;

import 'dart:async';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Future main() async {

  // init the stage and render loop, opt in for webGL

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, webGL: true, width: 300, height: 300);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load the resources with a default size of @1x

  BitmapData.defaultLoadOptions.maxPixelRatio = 3;

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData("background", "images/background@1x.jpg");
  resourceManager.addTextureAtlas("atlas", "images/atlas@1x.json");
  await resourceManager.load();

  // show the background and the walking boy

  var bitmapData = resourceManager.getBitmapData("background");
  var bitmap = new Bitmap(bitmapData);
  stage.addChild(bitmap);

  var textureAtlas = resourceManager.getTextureAtlas("atlas");
  var bitmapDatas = textureAtlas.getBitmapDatas("frame");
  var flipbook = new FlipBook(bitmapDatas, 10);
  flipbook.pivotX = 75;
  flipbook.pivotY = 125;
  flipbook.x = 150;
  flipbook.y = 150;
  flipbook.play();

  stage.addChild(flipbook);
  stage.juggler.add(flipbook);




}
