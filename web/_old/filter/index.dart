library filter;

import 'dart:js';
import 'dart:convert';
import 'dart:math';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager = ResourceManager();
Sprite flowerField = Sprite();
Random random = Random();
num totalTime = 0.0;

//-------------------------------------------------------------------------------------------------

void main() {

  // configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.bitmapDataLoadOptions.webp = true;

  // init Stage and RenderLoop

  stage = Stage(html.querySelector('#stage'));
  renderLoop = RenderLoop();
  renderLoop.addStage(stage);

  // load resources

  resourceManager
      ..addTextureAtlas('flowers', 'images/Flowers.json')
      ..addBitmapData('grass', 'images/grass.jpg')
      ..addBitmapData('apple', 'images/apple.png')
      ..addBitmapData('chrome', 'images/chrome.png')
      ..addBitmapData('displacement_bubble', 'images/displacement_bubble.png')
      ..addBitmapData('displacement_ripple', 'images/displacement_ripple.png')
      ..addBitmapData('displacement_twirl', 'images/displacement_twirl.png')
      ..addBitmapData('butterfly', 'images/butterfly.png')
      ..load().then(createFlowerField);
}

//-------------------------------------------------------------------------------------------------

void createFlowerField(ResourceManager resourceManager) {

  var textureAtlas = resourceManager.getTextureAtlas("flowers");
  var flowers = textureAtlas.getBitmapDatas("Flower");

  for(var i = 0; i < 100; i++) {
    var flower = flowers[random.nextInt(flowers.length)];
    var bitmap = Bitmap(flower)
      ..pivotX = 64
      ..pivotY = 64
      ..x = 80 + random.nextInt(640 - 160)
      ..y = 80 + random.nextInt(500 - 160)
      ..addTo(flowerField);

    stage.juggler.addTween(bitmap, 3600, Transition.linear)
      ..animate.rotation.to(math.pi * 360.0);
  }

  flowerField.x = flowerField.pivotX = 320;
  flowerField.y = flowerField.pivotY = 250;

  //-------------

  stage.addChild(Bitmap(resourceManager.getBitmapData('grass')));
  stage.addChild(flowerField);
  stage.onEnterFrame.listen(onEnterFrame);

  if (stage.renderEngine != RenderEngine.WebGL) {
    var font =  "Open Sans, Helvetica Neue, Helvetica, Arial, sans-serif";
    var textField = TextField();
    textField.defaultTextFormat = TextFormat(font, 16, Color.White, bold:true);
    textField.defaultTextFormat.leftMargin = 10;
    textField.defaultTextFormat.rightMargin = 10;
    textField.defaultTextFormat.topMargin = 10;
    textField.defaultTextFormat.bottomMargin = 10;
    textField.text = "This browser does not support WebGL, filters are ignored.";
    textField.autoSize = TextFieldAutoSize.CENTER;
    textField.background = true;
    textField.backgroundColor = Color.Red;
    textField.x = 320;
    textField.y = 50;
    textField.width = 0;
    textField.height = 0;
    textField.addTo(stage);
  }
}

//-------------------------------------------------------------------------------------------------

void onEnterFrame(EnterFrameEvent e) {

  Map config = json.decode(context['filterConfig']);
  if  (config.keys.isEmpty) return;

  var filters = <BitmapFilter>[];
  totalTime += e.passedTime;

  var colorMatrixFilterConfig = config['colorMatrixFilter'];
  if (colorMatrixFilterConfig['enabled']) {
    switch(colorMatrixFilterConfig['filter']) {
      case 'invert': filters.add(ColorMatrixFilter.invert()); break;
      case 'grayscale': filters.add(ColorMatrixFilter.grayscale()); break;
      case 'brightness': filters.add(ColorMatrixFilter.adjust(brightness: 0.2)); break;
      case 'contrast': filters.add(ColorMatrixFilter.adjust(contrast: 1.0)); break;
      case 'saturation': filters.add(ColorMatrixFilter.adjust(saturation: 1.0)); break;
      case 'hue': filters.add(ColorMatrixFilter.adjust(hue: -0.5)); break;
    }
  }

  var alphaMaskFilterConfig = config['alphaMaskFilter'];
  if (alphaMaskFilterConfig['enabled']) {
    BitmapData bitmapData;
    switch(alphaMaskFilterConfig['mask']) {
      case 'apple': bitmapData = resourceManager.getBitmapData('apple'); break;
      case 'butterfly': bitmapData = resourceManager.getBitmapData('butterfly'); break;
      case 'chrome': bitmapData = resourceManager.getBitmapData('chrome'); break;
    }
    if (bitmapData != null) {
      var matrix = Matrix.fromIdentity();
      matrix.translate(-bitmapData.width / 2, -bitmapData.height / 2);
      matrix.translate(320, 250);
      filters.add(AlphaMaskFilter(bitmapData, matrix));
    }
  }

  var displacementMapFilter = config['displacementMapFilter'];
  if (displacementMapFilter['enabled']) {
    BitmapData bitmapData;
    var transform = Matrix.fromIdentity();
    num scaleX = 16, scaleY = 16;

    switch(displacementMapFilter['map']) {
      case 'bubble':
        bitmapData = resourceManager.getBitmapData('displacement_bubble');
        transform.scale(1.2, 1.2);
        transform.translate(cos(totalTime) * 180, 0.0);
        scaleX = scaleY = 100;
        break;
      case 'twirl':
        bitmapData = resourceManager.getBitmapData('displacement_twirl');
        transform.scale(1.2, 1.2);
        transform.translate(cos(totalTime) * 180, 0.0);
        scaleX = scaleY = 300;
        break;
      case 'ripple':
        bitmapData = resourceManager.getBitmapData('displacement_ripple');
        scaleX = scaleY = 16;
        break;
    }

    if (bitmapData != null) {
      var matrix = Matrix.fromIdentity();
      matrix.translate(-bitmapData.width / 2, -bitmapData.height / 2);
      matrix.concat(transform);
      matrix.translate(320, 250);
      filters.add(DisplacementMapFilter(bitmapData, matrix, scaleX, scaleY));
    }
  }

  var blurFilterConfig = config['blurFilter'];
  if (blurFilterConfig['enabled']) {
    var blurX = blurFilterConfig['blurX'];
    var blurY = blurFilterConfig['blurY'];
    filters.add(BlurFilter(blurX, blurY, 5));
  }

  var dropShadowFilterConfig = config['dropShadowFilter'];
  if (dropShadowFilterConfig['enabled']) {
    var distance = dropShadowFilterConfig['distance'];
    var angle = dropShadowFilterConfig['angle'] * pi / 180.0;
    var color = dropShadowFilterConfig['color'];
    var blurX = dropShadowFilterConfig['blurX'];
    var blurY = dropShadowFilterConfig['blurY'];
    filters.add(DropShadowFilter(distance, angle, color, blurX, blurY, 2));
  }

  var glowFilterConfig = config['glowFilter'];
  if (glowFilterConfig['enabled']) {
    var color = glowFilterConfig['color'];
    var blurX = glowFilterConfig['blurX'];
    var blurY = glowFilterConfig['blurY'];
    filters.add(GlowFilter(color, blurX, blurY, 2));
  }

  flowerField.filters = filters;
}
