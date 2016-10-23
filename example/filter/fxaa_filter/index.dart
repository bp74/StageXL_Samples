library normal_map_filter;

import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

main() async {
  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.inputEventMode = InputEventMode.MouseAndTouch;
  StageXL.stageOptions.backgroundColor = Color.Black;

  // init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 800, height: 800);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // add TextField with instructions

  var textField = new TextField();
  textField.defaultTextFormat = new TextFormat("Arial", 22, Color.White);
  textField.defaultTextFormat.align = TextFormatAlign.CENTER;
  textField.width = 800;
  textField.height = 40;
  textField.x = 0;
  textField.y = 760;
  textField.text = "Tap to toggle FXAA filter on/off";
  textField.addTo(stage);

  // create a new Shape

  var shape = new Shape();
  shape.graphics.beginPath();
  shape.graphics.rect(-210, -210, 420, 420);
  shape.graphics.fillColor(Color.Black);

  shape.graphics.beginPath();
  shape.graphics.rect(-200, -200, 400, 400);
  shape.graphics.fillColor(Color.White);

  shape.graphics.beginPath();
  shape.graphics.rectRound(-150, -150, 300, 300, 40, 40);
  shape.graphics.strokeColor(Color.Blue, 30);

  for (int i = -7; i <= 7; i++) {
    shape.graphics.beginPath();
    shape.graphics.moveTo(-100, i * 15);
    shape.graphics.lineTo( 100, i * 15);
    shape.graphics.strokeColor(Color.Red, 3 + i.abs());
  }

  // toggle the FxaaFilter on every touch

  var container = new Sprite();
  container.x = 400;
  container.y = 400;
  container.addChild(shape);
  container.addTo(stage);

  var toggleFxaaFilter = (InputEvent e) {
    if (container.filters.length > 0) {
      container.filters.clear();
    } else {
      container.filters.add(new FxaaFilter());
    }
  };

  stage.onMouseClick.listen(toggleFxaaFilter);
  stage.onTouchTap.listen(toggleFxaaFilter);

  // rotate the shape (not the container) to see the filter in action,
  // but not the linear filtering of the rendered texture.

  await for (var time in stage.juggler.onElapsedTimeChange) {
    shape.rotation = time * 0.05;
  }
}
