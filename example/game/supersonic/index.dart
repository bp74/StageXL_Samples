library supersonic;

import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';

part 'source/geom/regular_polygon.dart';
part 'source/geom/polygon.dart';
part 'source/geom/segment.dart';
part 'source/geom/vector_2d.dart';
part 'source/geom/vector_3d.dart';

part 'source/menu/menu.dart';
part 'source/menu/menu_event.dart';
part 'source/menu/top_menu.dart';
part 'source/menu/abort_game_menu.dart';

part 'source/game.dart';
part 'source/game_event.dart';
part 'source/game_component.dart';
part 'source/missile_game.dart';
part 'source/missile_game_engine.dart';
part 'source/pipe_object.dart';
part 'source/scene.dart';
part 'source/random_utils.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;
Juggler renderJuggler;

Bitmap loadingBitmap;
Tween loadingBitmapTween;
TextField loadingTextField;

const String defaultFont = "Russo One";

void main() {

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.stageScaleMode= StageScaleMode.SHOW_ALL;
  StageXL.stageOptions.stageAlign = StageAlign.NONE;
  StageXL.bitmapDataLoadOptions.webp = true;

  stage = new Stage(html.querySelector('#stage'), width: 800, height: 600);
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  renderJuggler = renderLoop.juggler;

  //-------------------------------------------

  Future<BitmapData> loading = BitmapData.load("images/Loading.png");

  loading.then((bitmapData) {

    loadingBitmap = new Bitmap(bitmapData);
    loadingBitmap.pivotX = 20;
    loadingBitmap.pivotY = 20;
    loadingBitmap.x = 400;
    loadingBitmap.y = 270;
    stage.addChild(loadingBitmap);

    loadingBitmapTween = new Tween(loadingBitmap, 100, Transition.linear);
    loadingBitmapTween.animate.rotation.to(100.0 * 2.0 * math.PI);
    renderJuggler.add(loadingBitmapTween);

    loadingTextField = new TextField();
    loadingTextField.defaultTextFormat = new TextFormat("Arial", 20, 0xA0A0A0, bold:true);;
    loadingTextField.width = 240;
    loadingTextField.height = 40;
    loadingTextField.text = "... loading ...";
    loadingTextField.x = 400 - loadingTextField.textWidth / 2;
    loadingTextField.y = 320;
    loadingTextField.mouseEnabled = false;
    stage.addChild(loadingTextField);

    loadGame();
  });
}

void loadGame() {

  resourceManager = new ResourceManager();

  resourceManager.onProgress.listen((e) {
    var finished = resourceManager.finishedResources;
    var pending = resourceManager.pendingResources;
    var failed = resourceManager.failedResources;
    print("Resource Progress -> finished: ${finished.length}, pending:${pending.length}, failed:${failed.length}");
  });

  resourceManager.addBitmapData("barrier01", "images/barrier01.png");
  resourceManager.addBitmapData("barrier02", "images/barrier02.png");
  resourceManager.addBitmapData("barrier03", "images/barrier03.png");
  resourceManager.addBitmapData("barrier04", "images/barrier04.png");
  resourceManager.addBitmapData("barrier05", "images/barrier05.png");
  resourceManager.addBitmapData("barrier06", "images/barrier06.png");
  resourceManager.addBitmapData("barrier07", "images/barrier07.png");
  resourceManager.addBitmapData("training01", "images/training01.png");
  resourceManager.addBitmapData("training02", "images/training02.png");
  resourceManager.addBitmapData("finish", "images/finish.png");
  resourceManager.addBitmapData("broken", "images/broken.png");

  resourceManager.addTextureAtlas("items", "images/ItemTextureAtlas.json", TextureAtlasFormat.JSONARRAY);

  resourceManager.addSound("crash", "sounds/crash.mp3");
  resourceManager.addSound("swish", "sounds/swish.mp3");
  resourceManager.addSound("speedalizer", "sounds/speedalizer.mp3");

  resourceManager.addText("DISPLAY_LEVEL", "Level: {0}");
  resourceManager.addText("DISPLAY_LIVES", "Ships:");
  resourceManager.addText("DISPLAY_SCORE", "Score: {0}");
  resourceManager.addText("DISPLAY_TRAINING", "Training");
  resourceManager.addText("MESSAGE_FIRST_LEVEL", "Remain with your finger on the screen in order to fly through the tunnel!");
  resourceManager.addText("MESSAGE_FIRST_LEVEL_WEB", "Move the mouse pointer to navigate through the obstacles!");
  resourceManager.addText("MESSAGE_FREE_LEVEL_BARRIER_1", "Navigate to the center to fly through the hole!");
  resourceManager.addText("MESSAGE_FREE_LEVEL_BARRIER_2", "Navigate to the upper left side to fly through the hole!");
  resourceManager.addText("MESSAGE_FREE_LEVEL_BARRIER_3", "Navigate to the bottom right side to fly through the hole!");
  resourceManager.addText("MESSAGE_GAME_OVER", "Game\nOver!");
  resourceManager.addText("MESSAGE_RESTART_LEVEL", "Ooops!\nGet Ready\nFor Restart!");
  resourceManager.addText("MESSAGE_START_LEVEL", "Get Ready\nFor Level {0}!");
  resourceManager.addText("GENscore", "Score");
  resourceManager.addText("GENlevel", "Level");
  resourceManager.addText("GENexitquery", "Do you really want to quit the game?");
  resourceManager.addText("GENyes", "Yes");
  resourceManager.addText("GENno", "No");

  resourceManager.load().then((res) {

    stage.removeChild(loadingBitmap);
    stage.removeChild(loadingTextField);
    renderJuggler.remove(loadingBitmapTween);

    //------------------------------

    Game game = new MissileGame(800, 600);
    game.addTo(stage);
    game.start();

  }).catchError((error) {

    for(var resource in resourceManager.failedResources) {
      print("Loading resouce failed: ${resource.kind}.${resource.name} - ${resource.error}");
    }
  });
}


