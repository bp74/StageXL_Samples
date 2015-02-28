library normal_map_filter;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

main() async {

  BitmapData.defaultLoadOptions.webp = true;

  if(Multitouch.supportsTouchEvents) {
    Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
  }

  //---------------

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, webGL: true, width:800, height: 800);
  stage.backgroundColor = Color.Black;
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData("guy_pixels", "images/character-with-si-logo.png");
  resourceManager.addBitmapData("guy_normal", "images/character-with-si-logo_n.png");
  await resourceManager.load();

  var textField = new TextField();
  textField.defaultTextFormat = new TextFormat("Arial", 22, Color.White);
  textField.defaultTextFormat.align = TextFormatAlign.CENTER;
  textField.width = 800;
  textField.height = 40;
  textField.x = 0;
  textField.y = 760;
  textField.text = "Normal Map created with www.codeandweb.com/spriteilluminator";
  textField.addTo(stage);

  //---------------

  var guyPixelsBitmapData = resourceManager.getBitmapData("guy_pixels");
  var guyNormalBitmapData = resourceManager.getBitmapData("guy_normal");

  var normalMapfilter = new NormalMapFilter(guyNormalBitmapData);
  normalMapfilter.ambientColor = 0xFFA0A060;
  normalMapfilter.lightColor = 0xFFFFFFFF;
  normalMapfilter.lightRadius = 3000;
  normalMapfilter.lightX = 0;
  normalMapfilter.lightY = 0;
  normalMapfilter.lightZ = 100;

  var guy = new Bitmap(guyPixelsBitmapData);
  guy.filters.add(normalMapfilter);
  guy.scaleX = guy.scaleY = 0.5;
  guy.pivotX = guyPixelsBitmapData.width / 2;
  guy.pivotY = guyPixelsBitmapData.height / 2;
  guy.x = 450;
  guy.y = 400;
  guy.addTo(stage);

  //---------------

  var setLightPosition = (InputEvent e) {
    var stagePosition = new Point<num>(e.stageX, e.stageY);
    var guyPosition = guy.globalToLocal(stagePosition);
    normalMapfilter.lightX = guyPosition.x;
    normalMapfilter.lightY = guyPosition.y;
  };

  stage.onMouseDown.listen(setLightPosition);
  stage.onMouseMove.listen(setLightPosition);
  stage.onTouchBegin.listen(setLightPosition);
  stage.onTouchMove.listen(setLightPosition);
}

