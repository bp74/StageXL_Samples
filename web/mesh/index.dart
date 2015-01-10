library mesh_example;

import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

void main() {

  var canvas = html.querySelector('#stage');
  stage = new Stage(canvas, webGL: true, width:800, height: 800);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  BitmapData.defaultLoadOptions.webp = true;

  resourceManager = new ResourceManager()
    ..addBitmapData("earth", "images/earth.png")
    ..load().then((rm) => showMesh());
}

void showMesh() {

  // TODO: Create a better example

  var totalTime = 0.0;
  var bitmapData = resourceManager.getBitmapData("earth");
  var mesh = new Mesh.fromGrid(bitmapData, 8, 8);

  mesh.pivotX = bitmapData.width / 2;
  mesh.pivotY = bitmapData.height / 2;
  mesh.x = 400;
  mesh.y = 400;
  mesh.addTo(stage);

  stage.onEnterFrame.listen((e) {

    totalTime += e.passedTime;

    var dx = bitmapData.width / 8;
    var dy = bitmapData.height / 8;

    for(int x = 0; x <= 8; x++) {
      for(int y = 0; y <= 8; y++) {
        var vertex = x + y * 9;
        var px = x * dx + math.sin(x + totalTime * 6) * 15;
        var py = y * dy + math.sin(y + totalTime * 6) * 15;
        mesh.setVertexXY(vertex, px, py);
      }
    }
  });
}



