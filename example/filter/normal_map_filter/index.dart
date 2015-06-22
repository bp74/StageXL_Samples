library normal_map_filter;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

main() async {

  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.inputEventMode = InputEventMode.MouseAndTouch;
  StageXL.stageOptions.backgroundColor = Color.Black;

  // init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 800, height: 800);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load resources

  var resourceManager = new ResourceManager();
  resourceManager.addBitmapData("guy_pixels", "images/character-with-si-logo.png");
  resourceManager.addBitmapData("guy_normal", "images/character-with-si-logo_n.png");
  await resourceManager.load();

  // add TextField with SpriteIlluminator information

  var textField = new TextField();
  textField.defaultTextFormat = new TextFormat("Arial", 22, Color.White);
  textField.defaultTextFormat.align = TextFormatAlign.CENTER;
  textField.width = 800;
  textField.height = 40;
  textField.x = 0;
  textField.y = 760;
  textField.text = "Normal Map created with www.codeandweb.com/spriteilluminator";
  textField.addTo(stage);

  // create the NormalMapFilter with the image from the resource manager.

  var guyNormalBitmapData = resourceManager.getBitmapData("guy_normal");
  var normalMapFilter = new NormalMapFilter(guyNormalBitmapData);
  normalMapFilter.ambientColor = 0xFFA0A060;
  normalMapFilter.lightColor = 0xFFFFFFFF;
  normalMapFilter.lightRadius = 3000;
  normalMapFilter.lightX = 0;
  normalMapFilter.lightY = 0;
  normalMapFilter.lightZ = 100;

  // create the Bitmap with the image from the resource manager
  // and add the NormalMapFilter to the filters.

  var guyPixelsBitmapData = resourceManager.getBitmapData("guy_pixels");
  var guy = new Bitmap(guyPixelsBitmapData);
  guy.filters.add(normalMapFilter);
  guy.scaleX = guy.scaleY = 0.5;
  guy.pivotX = guyPixelsBitmapData.width / 2;
  guy.pivotY = guyPixelsBitmapData.height / 2;
  guy.x = 450;
  guy.y = 400;
  guy.addTo(stage);

  // change the light position of the NormalMapFilter when moving
  // the mouse or the touch point.

  var setLightPosition = (InputEvent e) {
    var stagePosition = new Point<num>(e.stageX, e.stageY);
    var guyPosition = guy.globalToLocal(stagePosition);
    normalMapFilter.lightX = guyPosition.x;
    normalMapFilter.lightY = guyPosition.y;
  };

  stage.onMouseDown.listen(setLightPosition);
  stage.onMouseMove.listen(setLightPosition);
  stage.onTouchBegin.listen(setLightPosition);
  stage.onTouchMove.listen(setLightPosition);
}
