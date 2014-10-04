import 'dart:math' hide Point, Rectangle;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Stage stage = new Stage(html.querySelector('#stage'), webGL: true, width:600, height:600);
RenderLoop renderLoop = new RenderLoop();
ResourceManager resourceManager = new ResourceManager();
Random random = new Random();

void main() {

  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;
  renderLoop.addStage(stage);

  Multitouch.inputMode = Multitouch.supportsTouchEvents
    ? MultitouchInputMode.TOUCH_POINT
    : MultitouchInputMode.NONE;

  BitmapData.defaultLoadOptions.webp = true;

  resourceManager
    ..addTextureAtlas('flowers', 'images/Flowers.json', TextureAtlasFormat.JSONARRAY)
    ..addBitmapData('grass', 'images/grass.jpg')
    ..addSound('click', 'sounds/Click.mp3')
    ..load().then(startAnimation);
}

//-----------------------------------------------------------------------------

Sprite3D sprite3D = new Sprite3D();

void startAnimation(ResourceManager resourceManager) {

  var textField = new TextField();
  textField.defaultTextFormat = new TextFormat("Arial", 24, Color.Black);
  textField.autoSize = TextFieldAutoSize.CENTER;
  textField.width = 0;
  textField.x = 300;
  textField.y = 10;
  textField.text = "tap the flowers to make them disappear";
  textField.addTo(stage);

  // create Sprite3D

  var grass = resourceManager.getBitmapData("grass");

  sprite3D = new Sprite3D();
  sprite3D.addChild(new Bitmap(grass));
  sprite3D.x = 300;
  sprite3D.y = 320;
  sprite3D.pivotX = grass.width / 2;
  sprite3D.pivotY = grass.height / 2;
  sprite3D.addTo(stage);

  for(int i = 0; i < 20; i++) {
    addRandomFlower();
  }

  // animate Sprite3D

  var transition = new Transition(0.0, 1000.0, 600.0);
  transition.delay = 2.0;
  transition.onUpdate = (value) {
    sprite3D.rotationY = 0.8 * sin(value * 0.4);
    sprite3D.rotationX = 0.8 * sin(value * 0.6);
    sprite3D.offsetZ = 400 * (0.1 + sin(value));
  };

  stage.juggler.add(transition);
}

//-----------------------------------------------------------------------------

void onFlowerMouseDown(MouseEvent me) {
  removeFlower(me.target);
}

void onFlowerTouchBegin(TouchEvent me) {
  removeFlower(me.target);
}

//-----------------------------------------------------------------------------

void addRandomFlower() {

  var grass = resourceManager.getBitmapData("grass");
  var flowers = resourceManager.getTextureAtlas("flowers");

  var frame = random.nextInt(flowers.frameNames.length);
  var flowerBitmapData = flowers.getBitmapData(flowers.frameNames[frame]);

  var flowerBitmap = new Bitmap(flowerBitmapData);
  flowerBitmap.pivotX = flowerBitmapData.width / 2;
  flowerBitmap.pivotY = flowerBitmapData.height / 2;

  var flowerSprite = new Sprite();
  flowerSprite.x = 70 + random.nextInt(grass.width - 140);
  flowerSprite.y = 70 + random.nextInt(grass.height - 140);
  flowerSprite.mouseCursor = MouseCursor.CROSSHAIR;
  flowerSprite.onMouseDown.listen(onFlowerMouseDown);
  flowerSprite.onTouchBegin.listen(onFlowerTouchBegin);
  flowerSprite.alpha = 0.0;
  flowerSprite.addChild(flowerBitmap);
  flowerSprite.addTo(sprite3D);

  stage.juggler.tween(flowerSprite, 0.5)
    ..animate.alpha.to(1.0);
}

void removeFlower(Sprite flowerSprite) {

  flowerSprite.mouseEnabled = false;
  resourceManager.getSound('click').play();
  addRandomFlower();

  stage.juggler.tween(flowerSprite, 0.5)
    ..animate.scaleX.to(3.0)
    ..animate.scaleY.to(3.0)
    ..animate.alpha.to(0.0)
    ..onComplete = flowerSprite.removeFromParent;
}



