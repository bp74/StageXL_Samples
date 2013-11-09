#Performance

[Try it here](http://www.stagexl.org/samples/performance/ "StageXL Performance Sample")

---

This benchmark tests how many frames per second the browser is able to draw
for a given number of flags. You can increase the number of flags to see the
effect on the frame rate. A modern desktop computer should be able to draw
at least 2000 flags at a smooth frame rate of 60 fps. This benchmark depends
on four important factors: The performance of your GPU for the draw calls, 
the performance of your CPU for the animation, the JavaScript code compiled
by dart2js and last but not least the browser you are using.

### Initialization

This demo uses 23 images of flags, all combined into one texture atlas. 
This texture atlas was created with a great tool called 
[Texture Packer](http://www.codeandweb.com/texturepacker)
which is available for free or in a more advanced version for little money.

The ResourceManager is used to load the texture atlas. After the
ResourceManager has finished the loading, we create an instance of
the Performance class and add it to the Stage.

    resourceManager
      ..addTextureAtlas('flags', 'images/flags.json', TextureAtlasFormat.JSONARRAY)
      ..load().then((_) => stage.addChild(new Performance()));

It is important to measure the frames per second of this demo. When you add
more and more flags, at some point the browser is no longer able to draw
the animation with smooth 60fps. So look at the fps-meter as you add more
flags.

    stage.onEnterFrame.listen((EnterFrameEvent e) {
      if (_fpsAverage == null) {
        _fpsAverage = 1.00 / e.passedTime;
      } else {
        _fpsAverage = 0.05 / e.passedTime + 0.95 * _fpsAverage;
      }
      html.querySelector('#fpsMeter').innerHtml = 'fps: ${_fpsAverage.round()}';
    });

### Class FylingFlag

This simple class is the display object for each flag. We could use the Bitmap 
class of StageXL to bring a flag to the screen, but at the same time we would
like to animate the flag. Therefore the FlyingFlag extends Bitmap and implements
the Animatable class. If you are not familiar with the Juggler animation 
framework, please take a look 
[here](http://www.stagexl.org/docs/wiki-articles.html?article=juggler).  

    bool advanceTime(num time) {
      var tx = x + vx * time;
      var ty = y + vy * time;
      if (tx > 910 || tx < 30) vx = -vx; else x = tx;
      if (ty > 480 || ty < 20) vy = -vy; else y = ty;
      return true;
    }

### Class Performance

The Performance class extends DisplayObjectContainer and is the main class
of this sample. It has two methods to add more flags or to remove flags.
Because the DisplayObjectContainer is a container for other DisplayObjects
it's easy to create new instances of FlyingFlag and add it as child to
the Performance class.

Let's take a look at the _addFlags method. This method is used to add
new flags to the container. It gets the texture atlas from the 
ResourceManager and all the names of the images stored in the 
texture atlas.
 
    var textureAtlas = resourceManager.getTextureAtlas('flags');
    var flagNames = textureAtlas.frameNames;

In a loop new instances of the FlyingFlag class are created. A randomly
choosen BitmapData is taken from the texture atlas and the velocity of
the FlyingFlag is also taken from the random generator. The FlyingFlag
is set to a random position and is added as child to the container. 
Finally the FlyingFlag instance is added to the Juggler (this is
possible because it implements the Animatable class) and therefore
its advanceTime method is called on every frame. 

    var flagName = flagNames[random.nextInt(flagNames.length)];
    var flagBitmapData = textureAtlas.getBitmapData(flagName);
    var velocityX = random.nextInt(200) - 100;
    var velocityY = random.nextInt(200) - 100;

    var flyingFlag = new FlyingFlag(flagBitmapData, velocityX, velocityY);
    flyingFlag.x = 30 + random.nextInt(940 - 60);
    flyingFlag.y = 30 + random.nextInt(500 - 60);
    addChild(flyingFlag);

    juggler.add(flyingFlag);

The _removeFlags method removes FlyingFlags from the container and from
the Juggler. It is important to remove the flags from the Juggler aswell,
otherwise the animation would continue even if the flag is no 
longer visible.

---

To learn more about Dart and the StageXL library, please follow these links:

* Dart programming language: <http://www.dartlang.org/>
* StageXL homepage: <http://www.stagexl.org/>
* StageXL on GitHub: <http://www.github.com/bp74/StageXL>

