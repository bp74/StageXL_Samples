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
  var stage = new Stage(canvas, width: 480, height: 600);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load resources

  var resourceManager = new ResourceManager();
  resourceManager..addBitmapData("flumpAtlas", "images/flumpLibraryAtlas0.png");
  resourceManager.addCustomObject('flump', FlumpLibrary.load('images/flumpLibrary.json'));
  await resourceManager.load();

  // show TextField with user instructions

  var textField = new TextField();
  textField.defaultTextFormat = new TextFormat("Arial", 24, Color.Black);
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
    new FlumpMovie(flumpLibrary, 'idle'),
    new FlumpMovie(flumpLibrary, 'walk'),
    new FlumpMovie(flumpLibrary, 'attack'),
    new FlumpMovie(flumpLibrary, 'defeat')
  ];

  // change the FlumpMovie on every mouse click.

  var flumpJuggler = new Juggler();
  stage.juggler.add(flumpJuggler);

  var flumpLayer = new Sprite();
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
