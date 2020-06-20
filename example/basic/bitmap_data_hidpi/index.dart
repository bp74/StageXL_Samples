library texture_atlas_example;

import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Future main() async {
  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.AliceBlue;
  StageXL.bitmapDataLoadOptions.pixelRatios = <double>[1.00, 1.25, 1.50, 2.00, 3.00];

  // init the stage and render loop

  var canvas = html.querySelector('#stage');
  var stage = Stage(canvas, width: 300, height: 300);
  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);

  // adjust available pixelRatios depending on the stage scale

  //  var stageScaleX = stage.stageHeight / stage.sourceHeight;
  //  var stageScaleY = stage.stageWidth / stage.sourceWidth;
  //  var stageScale = math.min(stageScaleX, stageScaleY);
  //  var ratioScale = stageScale * StageXL.environment.devicePixelRatio;
  //  var pixelRatios = <double>[1.0, 1.25, 1.50, 2.0, 3.0];
  //  pixelRatios.removeWhere((r) => r < ratioScale && r != 3.0);
  //  StageXL.bitmapDataLoadOptions.pixelRatios = pixelRatios;

  // load the resources with a default size of @1.00x

  var resourceManager = ResourceManager();
  resourceManager.addBitmapData('background', 'images/background@1.00x.jpg');
  resourceManager.addTextureAtlas('atlas', 'images/atlas@1.00x.json');
  await resourceManager.load();

  // show the background and the walking boy

  var bitmapData = resourceManager.getBitmapData('background');
  var bitmap = Bitmap(bitmapData);
  stage.addChild(bitmap);

  var textureAtlas = resourceManager.getTextureAtlas('atlas');
  var bitmapDatas = textureAtlas.getBitmapDatas('frame');
  var flipbook = FlipBook(bitmapDatas, 10);
  flipbook.pivotX = 75;
  flipbook.pivotY = 125;
  flipbook.x = 150;
  flipbook.y = 150;
  flipbook.play();

  stage.addChild(flipbook);
  stage.juggler.add(flipbook);
}
