library performance;

import 'dart:async';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

part 'source/flying_flag.dart';
part 'source/performance.dart';

Future main() async {

  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.bitmapDataLoadOptions.webp = true;

  // init Stage and RenderLoop

  var stage = new Stage(html.querySelector('#stage'));
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load the resources

  var resourceManager = new ResourceManager();
  resourceManager.addTextureAtlas('flags', 'images/flags.json');
  await resourceManager.load();

  // create the "Performance" display object

  var performance = new Performance(resourceManager);
  performance.addFlags(500);
  stage.addChild(performance);
  stage.juggler.add(performance);

  // add html-button event listeners

  var flagCounter = html.querySelector('#flagCounter');

  html.querySelector('#plus100').onClick.listen((e) {
    performance.addFlags(100);
    flagCounter.innerHtml = 'flags: ${performance.numChildren}';
  });

  html.querySelector('#minus100').onClick.listen((e) {
    performance.removeFlags(100);
    flagCounter.innerHtml = 'flags: ${performance.numChildren}';
  });

  // measure the frames per second

  var fpsAverage = 60.0;
  var fpsMeter = html.querySelector('#fpsMeter');

  await for (var enterFrame in stage.onEnterFrame) {
    fpsAverage = 0.05 / enterFrame.passedTime + 0.95 * fpsAverage;
    fpsMeter.innerHtml = 'fps: ${fpsAverage.round()}';
  }

}
