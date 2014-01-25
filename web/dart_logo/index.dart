library dart_logo;

import 'dart:math';
import 'dart:html';
import 'package:stagexl/stagexl.dart';

Stage stage = new Stage(querySelector('#stage'), webGL: true);
RenderLoop renderLoop = new RenderLoop();
Random random = new Random();

void main() {
  renderLoop.addStage(stage);
  BitmapData.load("images/logo.png").then(startAnimation);
}

void startAnimation(BitmapData logoBitmapData) {

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

  stage.juggler.delayCall(() => startAnimation(logoBitmapData), 0.15);
}

