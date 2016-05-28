import 'dart:math';
import 'dart:html';
import 'dart:async';
import 'package:stagexl/stagexl.dart';

Future main() async {

  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.stageScaleMode = StageScaleMode.NO_SCALE;
  StageXL.stageOptions.backgroundColor = Color.White;

  // init Stage and RenderLoop

  var canvas = querySelector('#stage');
  var stage = new Stage(canvas, width: 800, height: 600);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // create some random lines on the StageXL stage

  var background = new Sprite();
  var random = new Random();

  for (int i = 0; i < 200; i++) {
    var r = random.nextInt(255);
    var g = random.nextInt(255);
    var b = random.nextInt(255);
    var color = 0xC0000000 + (r << 16) + (g << 8) + b;
    var x1 = random.nextInt(1600) - 400;
    var y1 = random.nextInt(1200) - 300;
    var x2 = random.nextInt(1600) - 400;
    var y2 = random.nextInt(1200) - 300;
    background.graphics.beginPath();
    background.graphics.moveTo(x1, y1);
    background.graphics.lineTo(x2, y2);
    background.graphics.strokeColor(color, 20);
  }

  stage.addChild(background);

  // create HtmlObject display object

  var htmlElement = querySelector("#htmlObject");
  var htmlObject = new HtmlObject(htmlElement);
  htmlObject.x = 800 / 2;
  htmlObject.y = 600 / 2;
  htmlObject.pivotX = 600 / 2;
  htmlObject.pivotY = 300 / 2;
  stage.addChild(htmlObject);

  // animate with standard StageXL display object properties

  var juggler = stage.juggler;
  var transition = Transition.easeInOutBack;

  await juggler.delay(1.0);
  await for (var r in juggler.translation(0, PI * 8, 10.0, transition)) {
    htmlObject.rotation = r;
  }

}
