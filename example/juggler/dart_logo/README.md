#Animation

[Try it here](http://www.stagexl.org/samples/animation/ "StageXL Animation Sample")

---

This is a very simple demo showing some animated Dart logos. Learn how to
initialize the StageXL Stage, the RenderLoop and how simple it is to do
animations.

    stage = new Stage(html.querySelector('#stage'), webGL: true);
    renderLoop = new RenderLoop();
    renderLoop.addStage(stage);

An image (the Dart logo) is loaded from the server by using the
*BitmapData.load* function. This function returns a Future (a Dart class used
for asynchronous programming) and you get notified as soon as the image has
finished loading.

    BitmapData.load("images/logo.png").then(startAnimation);

The *startAnimation* function (see source code) obviously starts a new
animation. Therefore it takes a BitmapData instance (the image we've loaded
before) and places a Bitmap instance on a random position on the Stage. The
scale factor of this Bitmap instance is set to 0.0 because we want the Dart
logo to start with zero size.

    var logoBitmap = new Bitmap(logoBitmapData)
      ..pivotX = logoBitmapData.width ~/ 2
      ..pivotY = logoBitmapData.height ~/ 2
      ..x = random.nextInt(stage.stageWidth)
      ..y = random.nextInt(stage.stageHeight)
      ..rotation = 0.4 * random.nextDouble() - 0.2
      ..scaleX = 0.0
      ..scaleY = 0.0
      ..addTo(stage);

Next we use the Juggler framework (learn more about it
[here](http://www.stagexl.org/docs/wiki-articles.html?article=juggler "Juggler
Animation Framework")) to start two animations. The first animation uses
tweening to bring the scale factor of the Bitmap instance to 1.0 within one
second. The second animation starts with a delay of 1.5 seconds (which is 0.5
seconds after the first animation ended) and brings the scale factor back to
0.0. After the second animations ends the Bitmap instance is removed from the
Stage because we don't need it anymore.

    stage.juggler.tween(logoBitmap, 1.0, TransitionFunction.easeOutBack)
      ..animate.scaleX.to(1.0)
      ..animate.scaleY.to(1.0);

    stage.juggler.tween(logoBitmap, 1.0, TransitionFunction.easeInBack)
      ..delay = 1.5
      ..animate.scaleX.to(0.0)
      ..animate.scaleY.to(0.0)
      ..onComplete = logoBitmap.removeFromParent;

Last but not least, after a short delay the *startAnimation* function is called
again. This way we get an endless loop of Dart logo animations.

    stage.juggler.delayCall(() => startAnimation(logoBitmapData), startDelay);

---

To learn more about Dart and the StageXL library, please follow these links:

* Dart programming language: <http://www.dartlang.org/>
* StageXL homepage: <http://www.stagexl.org/>
* StageXL on GitHub: <http://www.github.com/bp74/StageXL>

