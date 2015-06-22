library text_field;

import 'dart:async';
import 'dart:js' as js;
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';

part 'source/text_game_on.dart';
part 'source/text_game_over.dart';
part 'source/text_get_ready.dart';
part 'source/text_hold_the_line.dart';
part 'source/text_hot_and_spicy.dart';
part 'source/text_sugar_smash.dart';
part 'source/text_sweet.dart';
part 'source/text_you_win.dart';

Stage stage;
RenderLoop renderLoop;
DisplayObject currentText = new Sprite();
DisplayObject currentTextCached = new Sprite();

void main() {

  stage = new Stage(html.querySelector('#stage'));
  stage.scaleMode = StageScaleMode.NO_SCALE;
  stage.align = StageAlign.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // https://github.com/typekit/webfontloader

  var completer = new Completer();
  var googleFontFamilies = [
      'Poller One', 'Titillium Web:900', 'Parisienne',
      'Varela Round', 'Poly', 'Ceviche One', 'Press Start 2P',
      'Norican', 'Yanone Kaffeesatz', 'VT323'];

  js.JsObject webFont = js.context["WebFont"];
  js.JsObject webFontConfig = new js.JsObject.jsify({
    "google": { "families": googleFontFamilies },
    "loading": () => print("loading fonts"),
    "active": () => completer.complete(null),
    "inactive": () => completer.completeError("Error loading fonts"),
    //"fontloading": (familyName, fvd) => print("fontloading: $familyName, $fvd"),
    //"fontactive": (familyName, fvd) => print("fontactive: $familyName, $fvd"),
    //"fontinactive": (familyName, fvd) => print("fontinactive: $familyName, $fvd")
  });

  webFont.callMethod("load", [webFontConfig]);
  completer.future.then((_) => start());
}

void start() {

  var textField = new TextField();
  textField.defaultTextFormat = new TextFormat("Arial", 36, Color.Black, align: TextFormatAlign.CENTER);
  textField.width = 400;
  textField.x = stage.contentRectangle.center.x - 200;
  textField.y = stage.contentRectangle.center.y - 20;
  textField.text = "tap to change text";
  textField.addTo(stage);

  var textGameOn = new TextGameOn();
  var textGameOver = new TextGameOver();
  var textGetReady = new TextGetReady();
  var textHoldTheLine = new TextHoldTheLine();
  var textHotAndSpicy = new TextHotAndSpicy();
  var textSugarSmash = new TextSugarSmash();
  var textSweet = new TextSweet();
  var textYouWin = new TextYouWin();

  var textIndex = 0;
  var texts = [textGameOn, textGameOver, textGetReady, textHoldTheLine,
      textHotAndSpicy, textSugarSmash, textSweet, textYouWin];

  stage.onMouseClick.listen((e) {
    textField.removeFromParent();
    textIndex = (textIndex + 1) % texts.length;
    showText(texts[textIndex]);
  });

}

//-----------------------------------------------------------------------------

void showText(DisplayObject text) {

  var rect = stage.contentRectangle;
  var bounds = text.bounds;
  var scale = math.min(rect.width / bounds.width, rect.height / bounds.height);
  var oldTextCached = currentTextCached;

  text.pivotX = bounds.center.x;
  text.pivotY = bounds.center.y;
  text.scaleY = text.scaleX = scale * 0.9;

  stage.juggler.addTween(oldTextCached, 0.5, Transition.easeInCubic)
      ..animate.x.to(rect.right - oldTextCached.bounds.left)
      ..onComplete = () {
        oldTextCached.removeFromParent();
        oldTextCached.removeCache();
      };

  currentText = text;
  currentTextCached = new Sprite()
      ..x = rect.left - currentText.width
      ..y = rect.center.y
      ..addChild(currentText)
      ..addTo(stage);

  var size = currentTextCached.bounds.align();
  currentTextCached.applyCache(size.left, size.top, size.width, size.height);

  stage.juggler.addTween(currentTextCached, 0.5, Transition.easeInCubic)
      ..animate.x.to(rect.center.x);
}
