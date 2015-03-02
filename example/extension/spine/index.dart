import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_spine/stagexl_spine.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager = new ResourceManager();

void main() {

  var canvas = html.querySelector('#stage');

  stage = new Stage(canvas, webGL: true, width:480, height: 600, color: Color.White);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  BitmapData.defaultLoadOptions.webp = true;

  resourceManager.addTextFile("spineboy", "spine/spineboy.json");
  resourceManager.addTextureAtlas("spineboy", "atlas/spineboy.json", TextureAtlasFormat.JSONARRAY);
  resourceManager.load().then((rm) => startSpineboy());
}

//-----------------------------------------------------------------------------

void startSpineboy() {

  var textField = new TextField();
  textField.defaultTextFormat = new TextFormat("Arial", 24, Color.Black, align: TextFormatAlign.CENTER);
  textField.width = 480;
  textField.x = 0;
  textField.y = 550;
  textField.text = "tap to change animation";
  textField.addTo(stage);

  var spineJson = resourceManager.getTextFile("spineboy");
  var textureAtlas = resourceManager.getTextureAtlas("spineboy");
  var attachmentLoader = new TextureAtlasAttachmentLoader(textureAtlas);
  var skeletonLoader = new SkeletonLoader(attachmentLoader);
  var skeletonData = skeletonLoader.readSkeletonData(spineJson);

  var animationStateData = new AnimationStateData(skeletonData);
  animationStateData.setMixByName("idle", "walk", 0.2);
  animationStateData.setMixByName("walk", "run", 0.2);
  animationStateData.setMixByName("run", "walk", 0.2);
  animationStateData.setMixByName("walk", "idle", 0.2);

  var skeletonAnimation = new SkeletonAnimation(skeletonData, animationStateData);
  skeletonAnimation.x = 240;
  skeletonAnimation.y = 520;
  skeletonAnimation.scaleX = skeletonAnimation.scaleY = 0.7;

  var animations = ["idle", "walk", "run", "walk"];
  var animationIndex = 0;

  stage.onMouseClick.listen((me) {
    animationIndex = (animationIndex + 1) % animations.length;
    skeletonAnimation.state.setAnimationByName(0, animations[animationIndex], true);
  });

  skeletonAnimation.state.setAnimationByName(0, "idle", true);

  stage.addChild(skeletonAnimation);
  stage.juggler.add(skeletonAnimation);
}
