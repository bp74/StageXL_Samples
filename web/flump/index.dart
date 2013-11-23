library flumpSample;

import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_flump/stagexl_flump.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

void main() {

  BitmapData.defaultLoadOptions.webp = true;

  stage = new Stage("myStage", html.querySelector('#stage'));
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  resourceManager = new ResourceManager()
    ..addBitmapData("flumpAtlas", "images/flumpLibraryAtlas0.png")
    ..addCustomObject('flump', FlumpLibrary.load('images/flumpLibrary.json'))
    ..load().then((result) => start());
}

void start() {

  var flumpLibrary = resourceManager.getCustomObject('flump') as FlumpLibrary;
  var juggler = stage.juggler;

  var bitmapData = resourceManager.getBitmapData("flumpAtlas");
  var bitmap = new Bitmap(bitmapData);
  bitmap.x = 50;
  bitmap.y = 50;
  stage.addChild(bitmap);

  var idle = new FlumpMovie(flumpLibrary, 'idle');
  idle.x = 120;
  idle.y = 450;
  stage.addChild(idle);
  juggler.add(idle);

  var walk = new FlumpMovie(flumpLibrary, 'walk');
  walk.x = 320;
  walk.y = 450;
  stage.addChild(walk);
  juggler.add(walk);

  var attack = new FlumpMovie(flumpLibrary, 'attack');
  attack.x = 540;
  attack.y = 450;
  stage.addChild(attack);
  juggler.add(attack);

  var defeat = new FlumpMovie(flumpLibrary, 'defeat');
  defeat.x = 760;
  defeat.y = 450;
  stage.addChild(defeat);
  juggler.add(defeat);
}


