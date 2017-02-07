#FlipBook

[Try it here](http://www.stagexl.org/samples/flipbook/ "StageXL FlipBook Sample")

---

This is a very simple demo showing an animated walking man. Learn how to
initialize the StageXL Stage, the RenderLoop and how to use the FlipBook class
to play sprite sheet animations. This demo also uses the opt-in feature of
StageXL to load WebP images if the browser supports it.

    stage = new Stage(html.querySelector('#stage'), webGL: true);
    renderLoop = new RenderLoop();
    renderLoop.addStage(stage);

    BitmapData.defaultLoadOptions.webp = true;

The sprite sheet animation for the walking man consists of 31 images. To
simplify and speed up the loading process of those images, we used the great
[TexturePacker](http://www.codeandweb.com/texturepacker "Texture Packer
Homepage") tool to combine those 31 images in one big image. Check out the 31
images and the combined image in the *images* folder. As mentioned before we
used the WebP support in StageXL to bring down the file size of the walking man
dramatically. The sprite sheet animation has an alpha channel so we need a PNG
file in the first place. Converting this image to WebP brings down the file size
from 668KB to 124KB. The WebP file is so much smaller because we use lossy
compression with alpha channel (a great feature of WebP).

This demo also shows how to use the ResourceManager class. The ResourceManager
takes all your resources (images, sounds, text, ...) and loads all of them at
once. Here we only load the sprite sheet animation, but if you have many
different resource files the ResourceManager is very handy.

    resourceManager = new ResourceManager()
      ..addTextureAtlas("ta1", "images/walk.json", TextureAtlasFormat.JSONARRAY)
      ..load().then((result) => startAnimation());

The *startAnimation* function (see source code) obviously starts the animation.
First we get the TextureAtlas (the combined image generated with TexturePacker)
from the *resourceManager*. Then we get the 31 images (BitmapDatas) for the
walking man animation from the *textureAtlas*.

    var textureAtlas = resourceManager.getTextureAtlas("ta1");
    var bitmapDatas = textureAtlas.getBitmapDatas("walk");

Creating the FlipBook instance is as easy as calling it's constructor with a
list of those 31 BitmapDatas and the frames per second of the animation. The
walking man sprite sheet animation consists of 31 image and we use 30fps for the
animation. Therefore our animation will last for approximately one second. The
FlipBook class plays this animation in a loop, so it will look like an endless
motion of a walking man.

The get a fake 3D perspective, we scale the size of the FlipBook and also change
the y-coordinate in accordance with the size. We also sort the DisplayObjects
(children) of the Stage to bring smaller walking mans to the background and
bigger ones to the foreground.

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

Next we use the Juggler framework
(learn more about it
[here](http://www.stagexl.org/docs/wiki-articles.html?article=juggler "Juggler Animation Framework"))
to start the animation. To make the man walk from the left to the right, we
create a *Tween* to animate the x-property of the FlipBook instance. The
FlipBook instance is an *Animatable* (see Juggler documentation) and can be
added to the Juggler as well. This is necessary because the FlipBook class
controls which image of the animation is shown on the screen at any given time.

    var transition = TransitionFunction.linear;
    var tween = new Tween(flipBook, 5.0 + (1.0 - scaling) * 5.0, transition)
      ..animate.x.to(940.0)
      ..onComplete = () => stopAnimation(flipBook);

    stage.juggler
      ..add(flipBook)
      ..add(tween)
      ..delayCall(startAnimation, 0.15);

The animation of the walking man should stop when the man is leaving the screen.
This happens when the Tween (which controls the x-property of the FlipBook
instance) completes. We simply set the *onComplete* callback of the Tween
instance and call the *stopAnimation* function. This function removes the
FlipBook instance from the Stage and also from the Juggler.

    stage.removeChild(flipbook);
    stage.juggler.remove(flipbook);

---

To learn more about Dart and the StageXL library, please follow these links: 

* Dart programming language: <http://www.dartlang.org/>
* StageXL homepage: <http://www.stagexl.org/>
* StageXL on GitHub: <http://www.github.com/bp74/StageXL>

