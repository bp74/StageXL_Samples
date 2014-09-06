import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_flump/stagexl_flump.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

void main() {

  var canvas = html.querySelector('#stage');

  stage = new Stage(canvas, webGL: true, width:480, height: 600, color: Color.White);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  BitmapData.defaultLoadOptions.webp = true;

  resourceManager = new ResourceManager()
    ..addBitmapData("flumpAtlas", "images/flumpLibraryAtlas0.png")
    ..addCustomObject('flump', FlumpLibrary.load('images/flumpLibrary.json'))
    ..load().then((result) => startFlump());
}

void startFlump() {

  var textField = new TextField();
  textField.defaultTextFormat = new TextFormat("Arial", 24, Color.Black, align: TextFormatAlign.CENTER);
  textField.width = 480;
  textField.x = 0;
  textField.y = 450;
  textField.text = "tap to change animation";
  textField.addTo(stage);

  var flumpLibrary = resourceManager.getCustomObject('flump') as FlumpLibrary;

  var idle = new FlumpMovie(flumpLibrary, 'idle');
  var walk = new FlumpMovie(flumpLibrary, 'walk');
  var attack = new FlumpMovie(flumpLibrary, 'attack');
  var defeat = new FlumpMovie(flumpLibrary, 'defeat');

  var flumpMovies = [idle, walk, attack, defeat];
  var flumpMovieIndex = 0;
  var flumpMovie = flumpMovies[0];
  flumpMovie.x = 250;
  flumpMovie.y = 400;

  stage.addChild(flumpMovie);
  stage.juggler.add(flumpMovie);

  stage.onMouseClick.listen((me) {

    stage.removeChild(flumpMovie);
    stage.juggler.remove(flumpMovie);

    flumpMovieIndex = (flumpMovieIndex + 1) % flumpMovies.length;
    flumpMovie = flumpMovies[flumpMovieIndex];
    flumpMovie.x = 250;
    flumpMovie.y = 400;

    stage.addChild(flumpMovie);
    stage.juggler.add(flumpMovie);

  });
}


