import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

main() async {

  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.inputEventMode = InputEventMode.MouseAndTouch;
  StageXL.stageOptions.backgroundColor = Color.Green;

  // init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 600, height: 600);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load resources

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData("flower1", "images/flower1.png");
  resourceManager.addBitmapData("flower2", "images/flower2.png");
  resourceManager.addBitmapData("flower3", "images/flower3.png");
  await resourceManager.load();

  // Create 100 random flowers around the center of the Stage

  var random = new math.Random();

  for (var i = 0; i < 100; i++) {

    var f = 1 + random.nextInt(3);
    var bitmapData = resourceManager.getBitmapData("flower$f");

    var bitmap = new Bitmap(bitmapData);
    bitmap.pivotX = 64;
    bitmap.pivotY = 64;

    var sprite = new Sprite();
    var randomRadius = random.nextDouble() * 200;
    var randomAngle = random.nextDouble() * 2 * math.PI;
    sprite.addChild(bitmap);
    sprite.x = 300 + randomRadius * math.cos(randomAngle);
    sprite.y = 300 + randomRadius * math.sin(randomAngle);
    sprite.addTo(stage);

    // add event handlers to start or stop dragging

    void startDrag(Event e) {
      stage.addChild(sprite); // bring to foreground
      sprite.scaleX = sprite.scaleY = 1.2;
      sprite.filters.add(new ColorMatrixFilter.adjust(hue: -0.5));
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
