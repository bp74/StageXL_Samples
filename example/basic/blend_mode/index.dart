library dart_logo;

import 'dart:math';
import 'dart:html';
import 'dart:async';
import 'package:stagexl/stagexl.dart';

List<BlendMode> blendModes = [
  BlendMode.NORMAL,
  BlendMode.ADD,
  BlendMode.MULTIPLY,
  BlendMode.SCREEN,
  BlendMode.ERASE,
  BlendMode.BELOW,
  BlendMode.ABOVE,
  BlendMode.NONE
];

List<String> blendModeNames = [
  "NORMAL",
  "ADD",
  "MULTIPLY",
  "SCREEN",
  "ERASE",
  "BELOW",
  "ABOVE",
  "NONE (WebGL only)"
];

//-----------------------------------------------------------------------------

Future main() async {

  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = 0xFF303030;
  StageXL.stageOptions.transparent = true;

  // init Stage and RenderLoop

  var canvas = querySelector('#stage');
  var stage = Stage(canvas, width: 400, height: 600);
  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);

  // add TextField to tell the user what to do.

  var textField = TextField();
  textField.defaultTextFormat = TextFormat("Arial", 24, Color.White);
  textField.defaultTextFormat.align = TextFormatAlign.CENTER;
  textField.width = 400;
  textField.x = 0;
  textField.y = 550;
  textField.text = "tap to change blend mode";
  textField.addTo(stage);

  // change the blend mode on every mouse click.

  var blendModeIndex = 0;
  stage.addChild(BlendModeSample(blendModes[0], blendModeNames[0]));

  stage.onMouseClick.listen((_) {
    blendModeIndex = (blendModeIndex + 1) % blendModes.length;
    var blendMode = blendModes[blendModeIndex];
    var blendModeName = blendModeNames[blendModeIndex];
    stage.removeChildren();
    stage.addChild(BlendModeSample(blendMode, blendModeName));
    stage.addChild(textField);
  });
}

//-----------------------------------------------------------------------------

class BlendModeSample extends Sprite {
  BlendModeSample(BlendMode blendMode, String blendModeName) {
    var textFormat = TextFormat("'Open Sans', sans-serif", 20, Color.White,
        bold: true, align: TextFormatAlign.CENTER, topMargin: 8);

    if (blendMode == BlendMode.BELOW || blendMode == BlendMode.ABOVE) {
      Bitmap(BitmapData(320, 200, Color.Magenta))
        ..x = 40
        ..y = 200
        ..blendMode = BlendMode.ERASE
        ..addTo(this);

      Bitmap(BitmapData(280, 160, 0x80606060))
        ..x = 60
        ..y = 220
        ..addTo(this);
    }

    TextField(blendModeName, textFormat)
      ..width = 360
      ..height = 40
      ..x = 20
      ..y = 20
      ..border = true
      ..borderColor = Color.White
      ..addTo(this);

    Sample()
      ..x = 200
      ..y = 300
      ..addTo(this)
      ..blendMode = blendMode;
  }
}

//-----------------------------------------------------------------------------

num totalTime = 0.0;

class Sample extends Sprite implements Animatable {

  List<Star> stars = List<Star>();

  Sample() {
    var star1 = Star(0xffff5050)
      ..x = -50
      ..y = -50;
    var star2 = Star(0xff50ff50)
      ..x = 50
      ..y = -50;
    var star3 = Star(0xff5050ff)
      ..x = 0
      ..y = 50;

    stars = [star1, star2, star3];
    stars.forEach((star) => this.addChild(star));

    this.onAddedToStage.listen((e) => this.stage.juggler.add(this));
    this.onRemovedFromStage.listen((e) => this.stage.juggler.remove(this));
  }

  @override
  bool advanceTime(num time) {
    totalTime += time;
    stars.forEach((star) => star.rotation = totalTime * 0.2);
    return true;
  }
}

//-----------------------------------------------------------------------------

class Star extends Sprite {
  Star(int color) {
    this.graphics.beginPath();
    this.graphics.moveTo(150, 0);

    for (int i = 0; i < 6; i++) {
      num a1 = (i * 60) * pi / 180;
      num a2 = (i * 60 + 30) * pi / 180;
      this.graphics.lineTo(150 * cos(a1), 150 * sin(a1));
      this.graphics.lineTo(80 * cos(a2), 80 * sin(a2));
    }

    this.graphics.closePath();
    this.graphics.fillColor(color);
    this.applyCache(-150, -150, 300, 300);
  }
}
