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
  final BitmapContainer _container = new BitmapContainer();
  final ResourceManager resourceManager;
  final html.Element _counterElement = html.querySelector("#counter");

  num _averageFps = 60.0;
  num _deltaToggleSign = 0;
  int _deltaToggleCount = 0;

  BitmapData bitmapData = null;

  BenchmarkScene(this.resourceManager) {
    this.addChild(_container);
    this.bitmapData = resourceManager.getBitmapData("flash");
  }

  bool advanceTime(num time) {

    _averageFps = 0.05 / time + 0.95 * _averageFps;

    var children = _container.children;
    var childCount = max(1, children.length);
    var deltaCount = (_averageFps / targetFps - 1.0) * childCount;
    var speedCount = min(20, pow(deltaCount.abs().ceil(), 0.25));

    // add a few bitmaps

    if (deltaCount > 0) {
      for(int i = 0; i < speedCount; i++) {
        var bitmap = new Bitmap(bitmapData);
        bitmap.x = _random.nextDouble() * (320 - 30) + 15;
        bitmap.y = _random.nextDouble() * (480 - 30) + 15;
        bitmap.rotation = _random.nextDouble() * 2.0 * PI;
        children.add(bitmap);
      }
    }

    // remove a few bitmaps

    if (deltaCount < 0) {
      speedCount = min(speedCount, children.length);
      for(int i = 0; i < speedCount; i++) {
        children.removeLast();
      }
    }

    // rotate all bitmaps

    _counterElement.text = children.length.toString();

    for(int i = 0; i < children.length; i++) {
      children[i].rotation += PI / 2 * time;
    }

    // check for steady state

    if (_deltaToggleSign != deltaCount.sign) {
      _deltaToggleSign = deltaCount.sign;
      _deltaToggleCount += 1;
    }

    if (_deltaToggleCount >= 10) {
      _container.removeFromParent();
      _benchmarkComplete();
      return false;
    } else {
      return true;
    }
  }

  void _benchmarkComplete() {

    var numChildren = _container.numChildren;
    var targetFps = this.targetFps;
    var resultText = new TextField();
    var textFormat = new TextFormat("Arial, Helvetica", 30, Color.Black);

    resultText.width = 240;
    resultText.height = 200;
    resultText.text = "Result:\n$numChildren objects\nwith $targetFps fps";
    resultText.defaultTextFormat = textFormat;
    resultText.x = 160 -  resultText.width / 2;
    resultText.y = 240 -  resultText.height / 2;
    addChild(resultText);
  }

}

