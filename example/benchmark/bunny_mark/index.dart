/// Implementation of the Bunny Benchmark
///
/// StageXL: http://www.stagexl.org/show/spine/bunny_bench/
/// PixiJS: http://www.goodboydigital.com/pixijs/bunnymark/
/// CreateJS: http://createjs.com/Demos/EaselJS/bunnymarkEasel/?c2d=0
///

import 'dart:async';
import 'dart:js';
import 'dart:html' as html;
import 'dart:math' hide Point, Rectangle;
import 'package:stagexl/stagexl.dart';

Random random = new Random();
num gravity = 0.75;

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
  resourceManager.addBitmapData('bunny', 'images/bunny.png');
  resourceManager.addBitmapData('bunnyAtlas', 'images/bunnyAtlas.png');
  await resourceManager.load();

  var bunnyAtlas = resourceManager.getBitmapData("bunnyAtlas");
  var bunnyBitmapDatas = <BitmapData>[
    new BitmapData.fromBitmapData(bunnyAtlas, new Rectangle(2, 47, 26, 37)),
    new BitmapData.fromBitmapData(bunnyAtlas, new Rectangle(2, 86, 26, 37)),
    new BitmapData.fromBitmapData(bunnyAtlas, new Rectangle(2, 125, 26, 37)),
    new BitmapData.fromBitmapData(bunnyAtlas, new Rectangle(2, 164, 26, 37)),
    new BitmapData.fromBitmapData(bunnyAtlas, new Rectangle(2, 2, 26, 37))
  ];

  // Create BunnyView

  var bunnyView = new BunnyView(bunnyBitmapDatas);
  stage.addChild(bunnyView);
  stage.onMouseDown.listen((me) => bunnyView.startAdding());
  stage.onMouseUp.listen((me) => bunnyView.stopAdding());
  stage.onTouchBegin.listen((me) => bunnyView.startAdding());
  stage.onTouchEnd.listen((me) => bunnyView.stopAdding());

  var stats = context['stats'];
  stage.onEnterFrame.listen((e) => stats.callMethod("begin"));
  stage.onExitFrame.listen((e) => stats.callMethod("end"));
}

//-----------------------------------------------------------------------------

class BunnyView extends BitmapContainer {

  List<BitmapData> bitmapDatas;
  html.Element _counterElement = html.querySelector("#counter");
  bool _adding = false;
  int _bunnyIndex = 0;

  BunnyView(this.bitmapDatas) {
    _addBunny();
    _addBunny();
    _updateCounter();
    this.onEnterFrame.listen(_onEnterFrame);
  }

  void startAdding() {
    _adding = true;
    _bunnyIndex = (_bunnyIndex + 1) % this.bitmapDatas.length;
  }

  void stopAdding() {
    _adding = false;
  }

  void _addBunny() {
    var bitmapData = this.bitmapDatas[_bunnyIndex];
    var bunny = new Bunny(bitmapData);
    bunny.speedX = random.nextDouble() * 10.0;
    bunny.speedY = random.nextDouble() * 10.0 - 5.0;
    bunny.pivotX = 26 / 2;
    bunny.pivotY = 37;
    bunny.addTo(this);
  }

  void _updateCounter() {
    _counterElement.text = "${this.numChildren} BUNNIES";
  }

  void _onEnterFrame(EnterFrameEvent e) {

    if (_adding) {
      for (int i = 0; i < 50; i++) {
        _addBunny();
      }
      _updateCounter();
    }

    // This is very benchmark specific. A real application
    // would probably use the Juggler animation framework.

    var contentRectangle = stage.contentRectangle;
    children.forEach((bunny) => bunny.update(contentRectangle));
  }
}

//-----------------------------------------------------------------------------

class Bunny extends Bitmap {

  num posX = 0.0;
  num posY = 0.0;
  num speedX = 0.0;
  num speedY = 0.0;

  Bunny(BitmapData bitmapData) : super(bitmapData);

  void update(Rectangle contentRectangle) {

    posX += speedX;
    posY += speedY;
    speedY += gravity;

    if (posX > contentRectangle.right) {
      speedX = -speedX;
      posX = contentRectangle.right;
    } else if (posX < contentRectangle.left) {
      speedX = -speedX;
      posX = contentRectangle.left;
    }

    if (posY > contentRectangle.bottom) {
      speedY *= -0.85;
      posY = contentRectangle.bottom;
      if (random.nextBool()) {
        speedY -= random.nextDouble() * 6.0;
      }
    } else if (posY < contentRectangle.top) {
      speedY = 0.0;
      posY = contentRectangle.top;
    }

    this.x = posX;
    this.y = posY;
  }
}
