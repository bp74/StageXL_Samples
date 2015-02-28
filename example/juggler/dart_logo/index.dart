library dart_logo;

import 'dart:math';
import 'dart:html';
import 'package:stagexl/stagexl.dart';

Random random = new Random();
Stage stage;
RenderLoop renderLoop;

void main() {

  stage = new Stage(querySelector('#stage'), webGL: true, width:800, height: 600);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  BitmapData.load("images/logo.png").then(startAnimation);
}

void startAnimation(BitmapData logoBitmapData) {

  var rect = stage.contentRectangle;
  var hue = random.nextDouble() * 2.0 - 1.0;
  var hueFilter = new ColorMatrixFilter.adjust(hue: hue);

  var logoBitmap = new Bitmap(logoBitmapData)
    ..pivotX = logoBitmapData.width ~/ 2
    ..pivotY = logoBitmapData.height ~/ 2
    ..x = rect.left + rect.width * random.nextDouble()
    ..y = rect.top + rect.height * random.nextDouble()
    ..rotation = 0.4 * random.nextDouble() - 0.2
    ..filters = [hueFilter]
    ..scaleX = 0.0
    ..scaleY = 0.0
    ..addTo(stage);

  stage.juggler.tween(logoBitmap, 1.0, TransitionFunction.easeOutBack)
    ..animate.scaleX.to(1.0)
    ..animate.scaleY.to(1.0);

  stage.juggler.tween(logoBitmap, 1.0, TransitionFunction.easeInBack)
    ..delay = 1.5
    ..animate.scaleX.to(0.0)
    ..animate.scaleY.to(0.0)
    ..onComplete = logoBitmap.removeFromParent;

  stage.juggler.delayCall(() => startAnimation(logoBitmapData), 0.1);
}

