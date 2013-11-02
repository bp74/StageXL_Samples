library dart_logo;

import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Stage stage;
RenderLoop renderLoop;

void main() {
  stage = new Stage("myStage", html.querySelector('#stage'));
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  BitmapData.load("images/logo.png").then(startAnimation);
}

void startAnimation(BitmapData logoBitmapData) {
  var random = new math.Random();
  var startDelay = 0.15;

  var logoBitmap = new Bitmap(logoBitmapData)
    ..pivotX = logoBitmapData.width ~/ 2
    ..pivotY = logoBitmapData.height ~/ 2
    ..x = random.nextInt(stage.stageWidth)
    ..y = random.nextInt(stage.stageHeight)
    ..rotation = 0.4 * random.nextDouble() - 0.2
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

  stage.juggler.delayCall(() => startAnimation(logoBitmapData), startDelay);
}

