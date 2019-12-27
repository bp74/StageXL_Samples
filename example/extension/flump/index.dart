import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_flump/stagexl_flump.dart';

Future main() async {
  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.White;
  StageXL.bitmapDataLoadOptions.webp = true;

  // init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = Stage(canvas, width: 480, height: 600);
  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);
  stage.console.visible = true;
  stage.console.alpha = 0.75;

  // load resources

  var resourceManager = ResourceManager();
  resourceManager..addBitmapData("flumpAtlas", "images/flumpLibraryAtlas0.png");
  resourceManager.addCustomObject('flump', FlumpLibrary.load('images/flumpLibrary.json'));
  await resourceManager.load();

  // show TextField with user instructions

  var textField = TextField();
  textField.defaultTextFormat = TextFormat("Arial", 24, Color.Black);
  textField.defaultTextFormat.align = TextFormatAlign.CENTER;
  textField.width = 480;
  textField.x = 0;
  textField.y = 450;
  textField.text = "tap to change animation";
  textField.addTo(stage);

  // get FlumpLibrary from resource manager.
  // get FlumpMovies from the FlumpLibrary.

  var flumpLibrary = resourceManager.getCustomObject('flump') as FlumpLibrary;

  var flumpMovies = [
    FlumpMovie(flumpLibrary, 'idle'),
    FlumpMovie(flumpLibrary, 'walk'),
    FlumpMovie(flumpLibrary, 'attack'),
    FlumpMovie(flumpLibrary, 'defeat')
  ];

  // change the FlumpMovie on every mouse click.

  var flumpJuggler = Juggler();
  stage.juggler.add(flumpJuggler);

  var flumpLayer = Sprite();
  flumpLayer.addTo(stage);
  flumpLayer.x = 250;
  flumpLayer.y = 400;

  var flumpMovieIndex = 0;
  var flumpMovie = flumpMovies[0];
  flumpLayer.addChild(flumpMovie);
  flumpJuggler.add(flumpMovie);

  stage.onMouseClick.listen((_) {
    flumpLayer.removeChildren();
    flumpJuggler.remove(flumpMovie);
    flumpMovieIndex = (flumpMovieIndex + 1) % flumpMovies.length;
    flumpMovie = flumpMovies[flumpMovieIndex];
    flumpLayer.addChild(flumpMovie);
    flumpJuggler.add(flumpMovie);
  });
}
