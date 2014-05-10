library text_field;

import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';

part 'source/font.dart';
part 'source/font_tester.dart';
part 'source/font_manager.dart';

part 'source/text_game_on.dart';
part 'source/text_game_over.dart';
part 'source/text_get_ready.dart';
part 'source/text_hold_the_line.dart';
part 'source/text_hot_and_spicy.dart';
part 'source/text_sugar_smash.dart';
part 'source/text_sweet.dart';
part 'source/text_you_win.dart';

Stage stage = new Stage(html.querySelector('#stage'), webGL: true);
RenderLoop renderLoop = new RenderLoop();

void main() {

  renderLoop.addStage(stage);

  FontManager fontManager = new FontManager()
    ..addGoogleFont('Poller One')
    ..addGoogleFont('Titillium Web', 900)
    ..addGoogleFont('Parisienne')
    ..addGoogleFont('Varela Round')
    ..addGoogleFont('Poly')
    ..addGoogleFont('Ceviche One')
    ..addGoogleFont('Press Start 2P')
    ..addGoogleFont('Norican')
    ..addGoogleFont('Yanone Kaffeesatz')
    ..addGoogleFont('VT323');

  fontManager.load().then((_) => start());
}

start() {

  var textGameOn = new TextGameOn();
  var textGameOver = new TextGameOver();
  var textGetReady = new TextGetReady();
  var textHoldTheLine = new TextHoldTheLine();
  var textHotAndSpicy = new TextHotAndSpicy();
  var textSugarSmash = new TextSugarSmash();
  var textSweet = new TextSweet();
  var textYouWin = new TextYouWin();

  html.querySelector("#btnGameOn").onClick.listen((_) => showText(textGameOn));
  html.querySelector("#btnGameOver").onClick.listen((_) => showText(textGameOver));
  html.querySelector("#btnGetReady").onClick.listen((_) => showText(textGetReady));
  html.querySelector("#btnHoldTheLine").onClick.listen((_) => showText(textHoldTheLine));
  html.querySelector("#btnHotAndSpicy").onClick.listen((_) => showText(textHotAndSpicy));
  html.querySelector("#btnSugarSmash").onClick.listen((_) => showText(textSugarSmash));
  html.querySelector("#btnSweet").onClick.listen((_) => showText(textSweet));
  html.querySelector("#btnYouWin").onClick.listen((_) => showText(textYouWin));

  showText(textSugarSmash);
}

void showText(DisplayObject text) {

  text.pivotX = 0;
  text.pivotY = 0;
  text.x = 0;
  text.y = 0;

  var bounds = text.getBounds(null);

  text.pivotX = bounds.center.x;
  text.pivotY = bounds.center.y;
  text.x = stage.contentRectangle.center.x;
  text.y = stage.contentRectangle.center.y;

  stage.removeChildren();
  stage.addChild(text);
}