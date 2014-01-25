library flipbook;

import 'dart:async';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

//###########################################################################
//  Credits for "TheZakMan" on http://opengameart.org for the walking man.
//###########################################################################

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

void main() {

  //------------------------------------------------------------------
  // Initialize the Display List
  //------------------------------------------------------------------

  stage = new Stage(html.querySelector('#stage'), webGL: true);
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  //------------------------------------------------------------------
  // Load a TextureAtlas
  //------------------------------------------------------------------

  BitmapData.defaultLoadOptions.webp = true;

  resourceManager = new ResourceManager()
    ..addTextureAtlas("ta1", "images/walk.json", TextureAtlasFormat.JSONARRAY)
    ..load().then((result) => startAnimation());
}

void startAnimation() {

  var random = new math.Random();
  var scaling = random.nextDouble();

  //------------------------------------------------------------------
  // Get all the "walk" bitmapDatas from the texture atlas.
  //------------------------------------------------------------------

  var textureAtlas = resourceManager.getTextureAtlas("ta1");
  var bitmapDatas = textureAtlas.getBitmapDatas("walk");

  //------------------------------------------------------------------
  // Create a flip book with the list of bitmapDatas.
  //------------------------------------------------------------------

  var flipBook = new FlipBook(bitmapDatas, 30)
    ..x = -128
    ..y = 20.0 + 200.0 * scaling
    ..scaleX = 0.5 + 0.5 * scaling
    ..scaleY = 0.5 + 0.5 * scaling
    ..addTo(stage)
    ..play();

  stage.sortChildren((c1, c2) {
    if (c1.y < c2.y) return -1;
    if (c1.y > c2.y) return  1;
    return 0;
  });

  //------------------------------------------------------------------
  // Let's add a tween so the man walks from the left to the right.
  //------------------------------------------------------------------

  var transition = TransitionFunction.linear;
  var tween = new Tween(flipBook, 5.0 + (1.0 - scaling) * 5.0, transition)
    ..animate.x.to(940.0)
    ..onComplete = () => stopAnimation(flipBook);

  stage.juggler
    ..add(flipBook)
    ..add(tween)
    ..delayCall(startAnimation, 0.15);
}

void stopAnimation(FlipBook flipbook) {
  stage.removeChild(flipbook);
  stage.juggler.remove(flipbook);
}


