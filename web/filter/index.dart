library filter;

import 'dart:js';
import 'dart:convert';
import 'dart:math';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

part 'source/flower_field.dart';

Stage stage = new Stage(html.querySelector('#stage'), webGL: true);
ResourceManager resourceManager  = new ResourceManager();
RenderLoop renderLoop = new RenderLoop();
FlowerField flowerField = null;
num totalTime = 0.0;

void main() {
  renderLoop.addStage(stage);
  BitmapData.defaultLoadOptions.webp = true;

  resourceManager
      ..addTextureAtlas('flowers', 'images/Flowers.json', TextureAtlasFormat.JSONARRAY)
      ..addBitmapData('grass', 'images/grass.jpg')
      ..addBitmapData('apple', 'images/apple.png')
      ..addBitmapData('chrome', 'images/chrome.png')
      ..addBitmapData('displacement_bubble', 'images/displacement_bubble.png')
      ..addBitmapData('displacement_ripple', 'images/displacement_ripple.png')
      ..addBitmapData('displacement_twirl', 'images/displacement_twirl.png')
      ..addBitmapData('butterfly', 'images/butterfly.png')
      ..load().then(createFlowerField);
}

void createFlowerField(ResourceManager resourceManager) {
  stage.addChild(new Bitmap(resourceManager.getBitmapData('grass')));
  flowerField = new FlowerField();
  flowerField.x = flowerField.pivotX = 320;
  flowerField.y = flowerField.pivotY = 250;
  stage.addChild(flowerField);
  stage.onEnterFrame.listen(onEnterFrame);
}

void onEnterFrame(EnterFrameEvent e) {
  Map config = JSON.decode(context['filterConfig']);
  if  (config.keys.length == 0) return;

  List filters = [];
  totalTime += e.passedTime;

  var colorMatrixFilterConfig = config['colorMatrixFilter'];
  if (colorMatrixFilterConfig['enabled']) {
    var filter = colorMatrixFilterConfig['filter'];
    switch(colorMatrixFilterConfig['filter']) {
      case 'invert': filters.add(new ColorMatrixFilter.invert()); break;
      case 'grayscale': filters.add(new ColorMatrixFilter.grayscale()); break;
      case 'brightness': filters.add(new ColorMatrixFilter.adjust(brightness: 0.2)); break;
      case 'contrast': filters.add(new ColorMatrixFilter.adjust(contrast: 1.0)); break;
      case 'saturation': filters.add(new ColorMatrixFilter.adjust(saturation: 1.0)); break;
      case 'hue': filters.add(new ColorMatrixFilter.adjust(hue: -0.5)); break;
    }
  }

  var alphaMaskFilterConfig = config['alphaMaskFilter'];
  if (alphaMaskFilterConfig['enabled']) {
    var bitmapData = null;
    switch(alphaMaskFilterConfig['mask']) {
      case 'apple': bitmapData = resourceManager.getBitmapData('apple'); break;
      case 'butterfly': bitmapData = resourceManager.getBitmapData('butterfly'); break;
      case 'chrome': bitmapData = resourceManager.getBitmapData('chrome'); break;
    }
    if (bitmapData != null) {
      var matrix = new Matrix.fromIdentity();
      matrix.translate(-bitmapData.width / 2, -bitmapData.height / 2);
      matrix.translate(320, 250);
      filters.add(new AlphaMaskFilter(bitmapData, matrix));
    }
  }

  var displacementMapFilter = config['displacementMapFilter'];
  if (displacementMapFilter['enabled']) {
    var bitmapData = null;
    var transform = new Matrix.fromIdentity();
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
      var matrix = new Matrix.fromIdentity();
      matrix.translate(-bitmapData.width / 2, -bitmapData.height / 2);
      matrix.concat(transform);
      matrix.translate(320, 250);
      filters.add(new DisplacementMapFilter(bitmapData, matrix, scaleX, scaleY));
    }
  }


  var blurFilterConfig = config['blurFilter'];
  if (blurFilterConfig['enabled']) {
    var blurX = blurFilterConfig['blurX'];
    var blurY = blurFilterConfig['blurY'];
    filters.add(new BlurFilter(blurX, blurY));
  }

  var dropShadowFilterConfig = config['dropShadowFilter'];
  if (dropShadowFilterConfig['enabled']) {
    var distance = dropShadowFilterConfig['distance'];
    var angle = dropShadowFilterConfig['angle'] * PI / 180.0;
    var color = dropShadowFilterConfig['color'];
    var blurX = dropShadowFilterConfig['blurX'];
    var blurY = dropShadowFilterConfig['blurY'];
    filters.add(new DropShadowFilter(distance, angle, color, blurX, blurY));
  }

  var glowFilterConfig = config['glowFilter'];
  if (glowFilterConfig['enabled']) {
    var color = glowFilterConfig['color'];
    var blurX = glowFilterConfig['blurX'];
    var blurY = glowFilterConfig['blurY'];
    filters.add(new GlowFilter(color, blurX, blurY));
  }

  flowerField.filters = filters;
}