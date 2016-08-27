import 'dart:html';
import 'package:stagexl/stagexl.dart';

/// Learn more about the different Stage scale and align modes here:
/// http://www.stagexl.org/docs/wiki-articles.html?article=stagescale

void main() {

  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.LightSkyBlue;

  // configure StageXL stage scale mode

  StageXL.stageOptions.stageScaleMode = StageScaleMode.SHOW_ALL;
  //StageXL.stageOptions.stageScaleMode = StageScaleMode.EXACT_FIT;
  //StageXL.stageOptions.stageScaleMode = StageScaleMode.NO_BORDER;
  //StageXL.stageOptions.stageScaleMode = StageScaleMode.NO_SCALE;

  // configure StageXL stage align

  StageXL.stageOptions.stageAlign = StageAlign.NONE;
  //StageXL.stageOptions.stageAlign = StageAlign.TOP_LEFT;

  // init Stage and RenderLoop

  var canvas = querySelector('#stage');
  var stage = new Stage(canvas, width: 400, height: 400);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // draw a 10x10 grid

  var backgroundGrid = new Shape();
  backgroundGrid.addTo(stage);

  backgroundGrid.graphics.beginPath();
  backgroundGrid.graphics.rect(0, 0, 400, 400);
  backgroundGrid.graphics.fillColor(Color.LightSeaGreen);
  backgroundGrid.graphics.strokeColor(Color.Black, 3);

  backgroundGrid.graphics.beginPath();
  for (int x = 0; x <= 400; x += 40) {
    for (int y = 0; y <= 400; y += 40) {
      backgroundGrid.graphics.rect(x - 5, y - 5, 10, 10);
    }
  }
  backgroundGrid.graphics.fillColor(Color.White);

  // output the size of stage.contentRectangle

  stage.onResize.listen((e) => print(stage.contentRectangle));

}
