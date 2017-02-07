library flipbook;

import 'dart:math';
import 'dart:html';
import 'package:stagexl/stagexl.dart';

//###########################################################################
//  Credits for "TheZakMan" on http://opengameart.org for the walking man.
//###########################################################################

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

void main() {

  // configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.stageScaleMode = StageScaleMode.SHOW_ALL;
  StageXL.stageOptions.stageAlign = StageAlign.NONE;
  StageXL.bitmapDataLoadOptions.webp = true;

  // init Stage and RenderLoop

  stage = new Stage(querySelector('#stage'), width: 800, height: 600);
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load resources

  resourceManager = new ResourceManager()
    ..addTextureAtlas("ta1", "images/walk.json")
    ..load().then((result) => startAnimation());
}

//-----------------------------------------------------------------------------

void startAnimation() {

  var random = new Random();
  var scaling = 0.5 + 0.5 * random.nextDouble();

  // Get all the "walk" bitmapDatas from the texture atlas.

  var textureAtlas = resourceManager.getTextureAtlas("ta1");
  var bitmapDatas = textureAtlas.getBitmapDatas("walk");

  // Create a flip book with the list of bitmapDatas.

  var rect = stage.contentRectangle;

  var flipBook = new FlipBook(bitmapDatas, 30)
    ..x = rect.left - 128
    ..y = rect.top + (scaling - 0.5) * 2.0 * (rect.height - 260)
    ..scaleX = scaling
    ..scaleY = scaling
    ..addTo(stage)
    ..play();

  stage.sortChildren((c1, c2) {
    if (c1.y < c2.y) return -1;
    if (c1.y > c2.y) return  1;
    return 0;
  });

  // Let's add a tween so the man walks from the left to the right.

  var transition = Transition.linear;
  var tween = new Tween(flipBook, rect.width / 200.0 / scaling, transition)
    ..animate.x.to(rect.right)
    ..onComplete = () => stopAnimation(flipBook);

  stage.juggler
    ..add(flipBook)
    ..add(tween)
    ..delayCall(startAnimation, 0.05);
}

void stopAnimation(FlipBook flipbook) {
  stage.removeChild(flipbook);
  stage.juggler.remove(flipbook);
}


