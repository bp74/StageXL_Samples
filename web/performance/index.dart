library performance;

import 'dart:async';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

part 'source/flying_flag.dart';
part 'source/performance.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

num _fpsAverage = null;

void main() {

  //---------------------------------------------
  // Initialize the Display List

  stage = new Stage(html.querySelector('#stage'), webGL: true);
  renderLoop = new RenderLoop();
  resourceManager = new ResourceManager();

  renderLoop.addStage(stage);

  //---------------------------------------------
  // Load the flags texture atlas, then start
  // the performance demo.

  BitmapData.defaultLoadOptions.webp = true;

  resourceManager
    ..addTextureAtlas('flags', 'images/flags.json', TextureAtlasFormat.JSONARRAY)
    ..load().then((_) => stage.addChild(new Performance()));

  //---------------------------------------------
  // add event listener to measure the fps.

  stage.onEnterFrame.listen((EnterFrameEvent e) {
    if (_fpsAverage == null) {
      _fpsAverage = 1.00 / e.passedTime;
    } else {
      _fpsAverage = 0.05 / e.passedTime + 0.95 * _fpsAverage;
    }
    html.querySelector('#fpsMeter').innerHtml = 'fps: ${_fpsAverage.round()}';
  });
}
