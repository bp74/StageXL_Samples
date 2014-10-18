/// Implementation of the Bunny Benchmark
///
/// StageXL: http://www.stagexl.org/show/spine/bunny_bench/
/// PixiJS: http://www.goodboydigital.com/pixijs/bunnymark/
/// CreateJS: http://createjs.com/Demos/EaselJS/bunnymarkEasel/?c2d=0
/// 

import 'dart:js';
import 'dart:html' as html;
import 'dart:math' hide Point, Rectangle;
import 'package:stagexl/stagexl.dart';

Random random = new Random();
num gravity = 0.75;

void main() {
  
  // Do not automatically switch to HiDpi to make it
  // comparable with the Pixi JS benchmark.
  
  Stage.autoHiDpi = false;
 
  // Initialize StageXL
  
  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, webGL:true, color:Color.White);
  stage.scaleMode = StageScaleMode.NO_SCALE;
  stage.align = StageAlign.TOP_LEFT;
  
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // Switch to touch events if touch is available
  
  Multitouch.inputMode = Multitouch.supportsTouchEvents
    ? MultitouchInputMode.TOUCH_POINT
    : MultitouchInputMode.NONE;
 
  // Load resources and create BunnyView when loaded
  
  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData('bunny', 'images/bunny.png');
  
  resourceManager.load().then((_) {
    var bitmapData = resourceManager.getBitmapData('bunny');
    var bunnyView = new BunnyView(bitmapData);
    stage.addChild(bunnyView);
    stage.onMouseDown.listen((me) => bunnyView.adding = true);
    stage.onMouseUp.listen((me) => bunnyView.adding = false);
    stage.onTouchBegin.listen((me) => bunnyView.adding = true);
    stage.onTouchEnd.listen((me) => bunnyView.adding = false);
  });
  
  var stats = context['stats'];
  stage.onEnterFrame.listen((e) => stats.callMethod("begin"));
  stage.onExitFrame.listen((e) => stats.callMethod("end"));
}

//-----------------------------------------------------------------------------

class BunnyView extends DisplayObjectContainer {
  
  BitmapData bitmapData;
  bool adding = false;
  
  BunnyView(this.bitmapData) {
    
    _addBunny();
    _addBunny();
    _updateCounter();
    
    this.onEnterFrame.listen(_onEnterFrame);
  }
  
  void _addBunny() {
    
    var bunny = new Bunny(this.bitmapData);
    bunny.speedX = random.nextDouble() * 10.0;
    bunny.speedY = random.nextDouble() * 10.0 - 5.0;
    bunny.pivotX = 26 / 2;
    bunny.pivotY = 37;
    
    this.addChild(bunny);
  }
  
  void _updateCounter() {
    var counter = this.numChildren;
    html.querySelector("#counter").text = "$counter BUNNIES";
  }
 
  void _onEnterFrame(EnterFrameEvent e) {
    
    if (adding) {
      for(int i = 0; i < 50; i++) {
        _addBunny();
      }
      _updateCounter();
    }
   
    // This is very benchmark specific. A real application
    // would probably use the Juggler animation framework.
    
    var contentRectangle = stage.contentRectangle;
    
    for(int i = 0; i < this.numChildren; i++) {
      var bunny = this.getChildAt(i);
      bunny.update(contentRectangle);
    }
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
