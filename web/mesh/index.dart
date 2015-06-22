library mesh_example;

import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';

Future main() async {

  // configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.stageScaleMode = StageScaleMode.SHOW_ALL;
  StageXL.stageOptions.stageAlign = StageAlign.NONE;
  StageXL.bitmapDataLoadOptions.webp = true;

  // init the Stage and RenderLoop

  var stage = new Stage(html.querySelector('#stage'), width: 800, height: 800);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load resources

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData("earth", "images/earth.png");
  await resourceManager.load();

  // create mesh with "earth" image

  var bitmapData = resourceManager.getBitmapData("earth");
  var mesh = new Mesh.fromGrid(bitmapData, 8, 8);
  mesh.pivotX = bitmapData.width / 2;
  mesh.pivotY = bitmapData.height / 2;
  mesh.x = 400;
  mesh.y = 400;
  mesh.addTo(stage);

  // animate the mesh on every frame

  var totalTime = 0.0;

  await for (var enterFrame in stage.onEnterFrame) {
    totalTime += enterFrame.passedTime;
    var dx = bitmapData.width / 8;
    var dy = bitmapData.height / 8;
    for (int x = 0; x <= 8; x++) {
      for (int y = 0; y <= 8; y++) {
        var vertex = x + y * 9;
        var px = x * dx + math.sin(x + totalTime * 6) * 15;
        var py = y * dy + math.sin(y + totalTime * 6) * 15;
        mesh.setVertexXY(vertex, px, py);
      }
    }
  }
}
