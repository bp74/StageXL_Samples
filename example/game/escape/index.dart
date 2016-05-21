library escape;

import 'dart:async';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

part 'source/alarm.dart';
part 'source/board.dart';
part 'source/board_event.dart';
part 'source/board_status.dart';
part 'source/bonus.dart';
part 'source/exit_box.dart';
part 'source/explosion.dart';
part 'source/field.dart';
part 'source/game.dart';
part 'source/grafix.dart';
part 'source/head.dart';
part 'source/info_box.dart';
part 'source/lock.dart';
part 'source/message_box.dart';
part 'source/special.dart';
part 'source/special_joker_chain.dart';
part 'source/special_joker_link.dart';
part 'source/special_wobble.dart';
part 'source/value_counter.dart';

Future main() async {

  StageXL.stageOptions.stageScaleMode = StageScaleMode.SHOW_ALL;
  StageXL.stageOptions.stageAlign = StageAlign.NONE;
  StageXL.bitmapDataLoadOptions.webp = true;

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 800, height: 600);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // create loading screen

  var loadingBitmapData = await BitmapData.load("images/Loading.png");
  var loadingBitmap = new Bitmap(loadingBitmapData);
  loadingBitmap.pivotX = 20;
  loadingBitmap.pivotY = 20;
  loadingBitmap.x = 400;
  loadingBitmap.y = 270;
  stage.addChild(loadingBitmap);

  var loadingTextField = new TextField();
  loadingTextField.defaultTextFormat = new TextFormat("Arial", 20, 0xA0A0A0, bold:true);
  loadingTextField.width = 240;
  loadingTextField.height = 40;
  loadingTextField.text = "... loading ...";
  loadingTextField.x = 400 - loadingTextField.textWidth / 2;
  loadingTextField.y = 320;
  loadingTextField.mouseEnabled = false;
  stage.addChild(loadingTextField);

  var loadingBitmapTween = new Tween(loadingBitmap, 100, Transition.linear);
  loadingBitmapTween.animate.rotation.to(100.0 * 2.0 * math.PI);
  stage.juggler.add(loadingBitmapTween);

  // load resources

  var resourceManager = new ResourceManager();

  resourceManager.addBitmapData("Background", "images/Background.jpg");
  resourceManager.addBitmapData("ExitBox", "images/ExitBox.png");
  resourceManager.addBitmapData("ExitButtonNormal", "images/ExitButtonNormal.png");
  resourceManager.addBitmapData("ExitButtonPressed", "images/ExitButtonPressed.png");
  resourceManager.addBitmapData("ExitGauge", "images/ExitGauge.png");
  resourceManager.addBitmapData("ExitNoButtonNormal", "images/ExitNoButtonNormal.png");
  resourceManager.addBitmapData("ExitNoButtonPressed", "images/ExitNoButtonPressed.png");
  resourceManager.addBitmapData("ExitYesButtonNormal", "images/ExitYesButtonNormal.png");
  resourceManager.addBitmapData("ExitYesButtonPressed", "images/ExitYesButtonPressed.png");
  resourceManager.addBitmapData("InfoBox", "images/InfoBox.png");
  resourceManager.addBitmapData("MessageBox", "images/MessageBox.png");
  resourceManager.addBitmapData("ShuffleButtonNormal", "images/ShuffleButtonNormal.png");
  resourceManager.addBitmapData("ShuffleButtonPressed", "images/ShuffleButtonPressed.png");
  resourceManager.addBitmapData("TimeGauge", "images/TimeGauge.png");

  resourceManager.addTextureAtlas("Alarm", "images/AlarmTextureAtlas.json");
  resourceManager.addTextureAtlas("Head", "images/HeadTextureAtlas.json");
  resourceManager.addTextureAtlas("Elements", "images/ElementsTextureAtlas.json");
  resourceManager.addTextureAtlas("Levelup", "images/LevelupTextureAtlas.json");
  resourceManager.addTextureAtlas("Locks", "images/LocksTextureAtlas.json");

  resourceManager.addSound("BonusAllUnlock", "sounds/BonusAllUnlock.mp3");
  resourceManager.addSound("BonusUniversal", "sounds/BonusUniversal.mp3");
  resourceManager.addSound("ChainBlast", "sounds/ChainBlast.mp3");
  resourceManager.addSound("ChainBlastSpecial", "sounds/ChainBlastSpecial.mp3");
  resourceManager.addSound("ChainError", "sounds/ChainError.mp3");
  resourceManager.addSound("ChainFall", "sounds/ChainFall.mp3");
  resourceManager.addSound("ChainHelp", "sounds/ChainHelp.mp3");
  resourceManager.addSound("ChainLink", "sounds/ChainLink.mp3");
  resourceManager.addSound("ChainRotate", "sounds/ChainRotate.mp3");
  resourceManager.addSound("Click", "sounds/Click.mp3");
  resourceManager.addSound("GameOver", "sounds/GameOver.mp3");
  resourceManager.addSound("Laugh", "sounds/Laugh.mp3");
  resourceManager.addSound("LevelUp", "sounds/LevelUp.mp3");
  resourceManager.addSound("PointsCounter", "sounds/PointsCounter.mp3");
  resourceManager.addSound("Unlock", "sounds/Unlock.mp3");
  resourceManager.addSound("Warning", "sounds/Warning.mp3");
  resourceManager.addSound("Intro", "sounds/Intro.mp3");

  resourceManager.addText("ESCAPE_INS_AIM_0", "Connect at least 3 chain links of the same colour to a horizontal or vertical chain.");
  resourceManager.addText("ESCAPE_INS_DES_0", "You can change the direction of a chain link by touching it.");
  resourceManager.addText("ESCAPE_INS_TIP_0", "Earn extra points for connecting chain links displaying a key symbol.");
  resourceManager.addText("ESCBlockErrorHint", "Sorry but block chains can´t be twisted!");
  resourceManager.addText("ESCLevelBoxText", "Connect {0} chain links and help the crook to escape!");
  resourceManager.addText("ESCNoActionHint", "Press on the chain links to twist them.");
  resourceManager.addText("ESCNoComboHint", "You have to connect at least 3 chain links of the same colour.");
  resourceManager.addText("ESCStartText", "Form horizontal or vertical same-colour chains and become an escape agent!");
  resourceManager.addText("ESCtogo", "Chain links:");
  resourceManager.addText("GENexitquery", "Do you really want to quit the game?");
  resourceManager.addText("GEN2ndchancetime", "Time is up. Second chance!");
  resourceManager.addText("GENtimeup", "Sorry! Your time is up.");
  resourceManager.addText("GENgameover", "Game Over");

  // wait for resource manager, then start the game

  await resourceManager.load();

  stage.removeChild(loadingBitmap);
  stage.removeChild(loadingTextField);
  stage.juggler.remove(loadingBitmapTween);

  var game = new Game(resourceManager, stage.juggler);
  stage.addChild(new Bitmap(resourceManager.getBitmapData("Background")));
  stage.addChild(game);
  game.start();
}
