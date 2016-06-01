library benchmark_startling;

/// Implementation of the Starling Benchmark
///
/// StageXL: http://www.stagexl.org/example/benchmark/starling
/// Starling: http://gamua.com/starling/demo/
/// OpenFL: http://vroad.github.io/starling-samples/

import 'dart:js';
import 'dart:async';
import 'dart:html' as html;
import 'dart:math' hide Point, Rectangle;
import 'package:stagexl/stagexl.dart';

part 'src/benchmark_render_loop.dart';
part 'src/benchmark_scene.dart';

Future main() async {

  // configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.inputEventMode = InputEventMode.MouseAndTouch;
  StageXL.stageOptions.stageScaleMode = StageScaleMode.NO_SCALE;
  StageXL.stageOptions.stageAlign = StageAlign.TOP_LEFT;
  StageXL.stageOptions.backgroundColor = Color.White;
  StageXL.stageOptions.maxPixelRatio = 1;

  // Initialize Stage and RenderLoop

  var stage = new Stage(html.querySelector('#stage'));
  var renderLoop = new BenchmarkRenderLoop();
  renderLoop.addStage(stage);

  // Load resources

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData('background', 'images/background.png');
  resourceManager.addBitmapData('flash', 'images/flash.png');
  await resourceManager.load();

  var background = resourceManager.getBitmapData("background");
  stage.addChild(new Bitmap(background));

  // start benchmark

  var bitmapData = resourceManager.getBitmapData("flash");
  var benchmarkScene = new BenchmarkScene(bitmapData, 60);
  stage.addChild(benchmarkScene);
  stage.juggler.add(benchmarkScene);

  // update fps display

  var stats = context['stats'];
  stage.onEnterFrame.listen((e) => stats.callMethod("begin"));
  stage.onExitFrame.listen((e) => stats.callMethod("end"));
}
