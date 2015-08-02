/// Implementation of the Starling Benchmark
///
/// StageXL: http://www.stagexl.org/show/spine/bunny_bench/
/// Starling: http://gamua.com/starling/demo/
/// OpenFL: http://vroad.github.io/starling-samples/

import 'dart:js';
import 'dart:async';
import 'dart:html' as html;
import 'dart:math' hide Point, Rectangle;
import 'package:stagexl/stagexl.dart';

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
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // Load resources

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData('background', 'images/background.png');
  resourceManager.addBitmapData('flash', 'images/flash.png');
  await resourceManager.load();

  var background = resourceManager.getBitmapData("background");
  stage.addChild(new Bitmap(background));

  // start benchmark

  var benchmarkScene = new BenchmarkScene(resourceManager);
  stage.addChild(benchmarkScene);
  stage.juggler.add(benchmarkScene);

  // update fps display

  var stats = context['stats'];
  stage.onEnterFrame.listen((e) => stats.callMethod("begin"));
  stage.onExitFrame.listen((e) => stats.callMethod("end"));
}

//-----------------------------------------------------------------------------

class BenchmarkScene extends Sprite implements Animatable {

  final int targetFps = 30;
  final Random _random = new Random();
  final Sprite _container = new Sprite();
  final ResourceManager resourceManager;
  final html.Element _counterElement = html.querySelector("#counter");

  int _frameCount = 0;
  int _failCount = 0;
  num _averageFps = 0.0;
  bool _benchmarkRunning = true;

  BenchmarkScene(this.resourceManager) {
    this.addChild(_container);
    _averageFps = this.targetFps;
  }

  bool advanceTime(num time) {

    _averageFps = 0.1 / time + 0.90 * _averageFps;
    _frameCount = _frameCount + 1;

    var frameInterval = 1 + _failCount ~/ 5;

    if (_frameCount % frameInterval == 0) {
      if (_averageFps + 0.50 >= this.targetFps) {
        _failCount = max(_failCount - 1, 0);
        _addTestObjects();
      } else {
        _failCount = min(_failCount + 1, 40);
        if (_failCount == 40) _benchmarkComplete();
      }
    }

    for(var child in _container.children) {
      child.rotation += PI / 2 * time;
    }

    return _benchmarkRunning;
  }

  void _addTestObjects() {

    int padding = 15;
    int numObjects = 20 - _failCount ~/ 2;
    var bitmapData = resourceManager.getBitmapData("flash");

    for (int i = 0; i < numObjects; ++i) {
      var bitmap = new Bitmap(bitmapData);
      bitmap.x = padding + _random.nextDouble() * (320 - 2 * padding);
      bitmap.y = padding + _random.nextDouble() * (480 - 2 * padding);
      bitmap.rotation = _random.nextDouble() * 2.0 * PI;
      _container.addChild(bitmap);
    }

    _counterElement.text = _container.numChildren.toString();
  }

  void _benchmarkComplete() {

    var numChildren = _container.numChildren;
    var targetFps = this.targetFps;

    print("Benchmark complete!");
    print("FPS: $targetFps");
    print("Number of objects: $numChildren");

    var resultText = new TextField();
    var textFormat = new TextFormat("Arial, Helvetica", 30, Color.Black);
    resultText.width = 240;
    resultText.height = 200;
    resultText.text = "Result:\n$numChildren objects\nwith $targetFps fps";
    resultText.defaultTextFormat = textFormat;
    resultText.x = 160 -  resultText.width / 2;
    resultText.y = 240 -  resultText.height / 2;
    addChild(resultText);

    _container.removeChildren();
    _benchmarkRunning = false;
  }

}

