import 'dart:async';
import 'dart:math';
import 'dart:html';
import 'package:stagexl/stagexl.dart';

Future main() async {

  // configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.Bisque;

  // init Stage and RenderLoop

  var canvas = querySelector('#stage');
  var stage = new Stage(canvas, width: 800, height: 600);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load the Dart logo and do some setup work

  var logoBitmapData = await BitmapData.load("images/logo.png");
  var juggler = stage.juggler;
  var random = new Random();
  var delay = 0.1;

  // run the animation controlled by the juggler

  await for (var counter in juggler.interval(delay).take(666)) {

    var rect = stage.contentRectangle;
    var hue = random.nextDouble() * 2.0 - 1.0;
    var hueFilter = new ColorMatrixFilter.adjust(hue: hue);

    var logoBitmap = new Bitmap(logoBitmapData)
      ..pivotX = logoBitmapData.width / 2
      ..pivotY = logoBitmapData.height / 2
      ..x = rect.left + rect.width * random.nextDouble()
      ..y = rect.top + rect.height * random.nextDouble()
      ..rotation = 0.4 * random.nextDouble() - 0.2
      ..filters = [hueFilter]
      ..scaleX = 0.0
      ..scaleY = 0.0
      ..addTo(stage);

    juggler.addTween(logoBitmap, 1.0, Transition.easeOutBack)
      ..animate.scaleX.to(1.0)
      ..animate.scaleY.to(1.0);

    juggler.addTween(logoBitmap, 1.0, Transition.easeInBack)
      ..delay = 1.5
      ..animate.scaleX.to(0.0)
      ..animate.scaleY.to(0.0)
      ..onComplete = logoBitmap.removeFromParent;

  }
}
