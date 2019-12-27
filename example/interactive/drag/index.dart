import 'dart:async';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Future main() async {
  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.inputEventMode = InputEventMode.MouseAndTouch;
  StageXL.stageOptions.backgroundColor = Color.Green;

  // init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = Stage(canvas, width: 600, height: 600);
  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);

  // load resources

  var resourceManager = ResourceManager();
  resourceManager.addBitmapData("flowers", "images/flowers.png");
  await resourceManager.load();

  var flowers = resourceManager.getBitmapData("flowers");
  var flowersList = <BitmapData>[
    BitmapData.fromBitmapData(flowers, Rectangle(0 * 128, 0, 128, 128)),
    BitmapData.fromBitmapData(flowers, Rectangle(1 * 128, 0, 128, 128)),
    BitmapData.fromBitmapData(flowers, Rectangle(2 * 128, 0, 128, 128)),
  ];

  // Create 100 random flowers around the center of the Stage

  var random = math.Random();

  for (var i = 0; i < 100; i++) {
    var bitmapData = flowersList[random.nextInt(3)];
    var bitmap = Bitmap(bitmapData);
    bitmap.pivotX = 64;
    bitmap.pivotY = 64;

    var sprite = Sprite();
    var randomRadius = random.nextDouble() * 200;
    var randomAngle = random.nextDouble() * 2 * math.pi;
    sprite.addChild(bitmap);
    sprite.x = 300 + randomRadius * math.cos(randomAngle);
    sprite.y = 300 + randomRadius * math.sin(randomAngle);
    sprite.addTo(stage);

    // add event handlers to start or stop dragging

    void startDrag(Event e) {
      stage.addChild(sprite); // bring to foreground
      sprite.scaleX = sprite.scaleY = 1.2;
      sprite.filters.add(ColorMatrixFilter.adjust(hue: -0.5));
      sprite.startDrag(true);
    }

    void stopDrag(Event e) {
      sprite.scaleX = sprite.scaleY = 1.0;
      sprite.filters.clear();
      sprite.stopDrag();
    }

    sprite.onMouseDown.listen(startDrag);
    sprite.onTouchBegin.listen(startDrag);
    sprite.onMouseUp.listen(stopDrag);
    sprite.onTouchEnd.listen(stopDrag);
    stage.onMouseLeave.listen(stopDrag);
  }
}
