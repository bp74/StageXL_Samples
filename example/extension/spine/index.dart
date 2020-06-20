import 'dart:async';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_spine/stagexl_spine.dart';

Future main() async {
  // configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;

  // init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = Stage(canvas, width: 480, height: 600);
  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);
  stage.console.visible = true;
  stage.console.alpha = 0.75;

  // load "Spineboy" skeleton resources

  var resourceManager = ResourceManager();
  var libgdx = TextureAtlasFormat.LIBGDX;
  resourceManager.addTextFile('spineboy', 'spine/spineboy.json');
  resourceManager.addTextureAtlas('spineboy', 'spine/spineboy.atlas', libgdx);
  await resourceManager.load();

  // add TextField with user instructions

  var textField = TextField();
  textField.defaultTextFormat = TextFormat('Arial', 24, Color.Black);
  textField.defaultTextFormat.align = TextFormatAlign.CENTER;
  textField.width = 480;
  textField.x = 0;
  textField.y = 550;
  textField.text = 'tap to change animation';
  textField.addTo(stage);

  // load Spine skeleton

  var spineJson = resourceManager.getTextFile('spineboy');
  var textureAtlas = resourceManager.getTextureAtlas('spineboy');
  var attachmentLoader = TextureAtlasAttachmentLoader(textureAtlas);
  var skeletonLoader = SkeletonLoader(attachmentLoader);
  var skeletonData = skeletonLoader.readSkeletonData(spineJson);

  // configure Spine animation mix

  var animationStateData = AnimationStateData(skeletonData);
  animationStateData.setMixByName('idle', 'walk', 0.2);
  animationStateData.setMixByName('walk', 'run', 0.2);
  animationStateData.setMixByName('run', 'walk', 0.2);
  animationStateData.setMixByName('walk', 'idle', 0.2);

  // create the display object showing the skeleton animation

  var skeletonAnimation = SkeletonAnimation(skeletonData, animationStateData);
  skeletonAnimation.x = 240;
  skeletonAnimation.y = 520;
  skeletonAnimation.scaleX = skeletonAnimation.scaleY = 0.7;
  skeletonAnimation.state.setAnimationByName(0, 'idle', true);
  stage.addChild(skeletonAnimation);
  stage.juggler.add(skeletonAnimation);

  // change the animation on every mouse click

  var animations = ['idle', 'walk', 'run', 'walk'];
  var animationIndex = 0;

  stage.onMouseClick.listen((_) {
    animationIndex = (animationIndex + 1) % animations.length;
    skeletonAnimation.state.setAnimationByName(0, animations[animationIndex], true);
  });
}
