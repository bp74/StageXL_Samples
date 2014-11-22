library video_example;

import 'dart:html' as html;
import 'dart:math';
import 'package:stagexl/stagexl.dart';

part 'button.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

Video video;
Sprite videoContainer2D;
Sprite3D videoContainer3D;
BitmapData videoBitmapData;
List<BitmapData> videoBitmapDatas;
List<Bitmap> videoBitmaps;

//-----------------------------------------------------------------------------

void main() {

  Video.defaultLoadOptions.corsEnabled = true;

  var canvas = html.querySelector('#stage');
  var random = new Random();

  stage = new Stage(canvas, webGL: true, width:1600, height: 800);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  Multitouch.inputMode = Multitouch.supportsTouchEvents
      ? MultitouchInputMode.TOUCH_POINT
      : MultitouchInputMode.NONE;

  resourceManager = new ResourceManager()
    ..addVideo("sintel", "videos/sintel.mp4")
    ..addBitmapData("displacement", "images/displacement.png")
    ..load().then((rm) => waitForClick());
}

//-----------------------------------------------------------------------------

void waitForClick() {

  var textFormat = new TextFormat("Arial", 36, Color.Black);
  textFormat.align = TextFormatAlign.CENTER;

  var headline = new TextField();
  headline.defaultTextFormat = textFormat;
  headline.defaultTextFormat.size = 100;
  headline.autoSize = TextFieldAutoSize.CENTER;
  headline.width = 0;
  headline.x = 800;
  headline.y = 250;
  headline.text = "Sintel Trailer";
  headline.addTo(stage);

  var info = new TextField();
  info.defaultTextFormat = textFormat;
  info.autoSize = TextFieldAutoSize.CENTER;
  info.width = 0;
  info.x = 800;
  info.y = 400;
  info.text = "tap to start video";
  info.addTo(stage);

  stage.onMouseDown.first.then(showVideo);
  stage.onTouchBegin.first.then(showVideo);
}

//-----------------------------------------------------------------------------

void showVideo(e) {

  stage.removeChildren();

  video = resourceManager.getVideo("sintel");

  videoContainer3D = new Sprite3D();
  videoContainer3D.x = 800;
  videoContainer3D.y = 340;
  videoContainer3D.addTo(stage);

  videoContainer2D = new Sprite();
  videoContainer2D.scaleX = 2.0;
  videoContainer2D.scaleY = 2.0;
  videoContainer2D.addTo(videoContainer3D);

  videoBitmapData = new BitmapData.fromVideoElement(video.videoElement);
  videoBitmapDatas = videoBitmapData.sliceIntoFrames(50, 50);
  videoBitmaps = new List<Bitmap>(videoBitmapDatas.length);

  for(int i = 0; i < videoBitmapDatas.length; i++) {
    var videoBitmap = videoBitmaps[i] = new Bitmap(videoBitmapDatas[i]);
    videoBitmap.pivotX = 25;
    videoBitmap.pivotY = 25;
    videoBitmap.x = (i % 14) * 50 + 25 - 350;
    videoBitmap.y = (i ~/ 14) * 50 + 25 - 150;
    videoBitmap.addTo(videoContainer2D);
  }

  video.loop = true;
  video.play();

  addButtons();
}

//-----------------------------------------------------------------------------

void addButtons() {

  var buttons = [
     new Button("Texture Split")..on(Event.CHANGE).listen(onSplitChanged),
     new Button("2D Transform")..on(Event.CHANGE).listen(on2dChanged),
     new Button("3D Transform")..on(Event.CHANGE).listen(on3dChanged),
     new Button("Random Filter")..on(Event.CHANGE).listen(onFilterChanged),
     new Button("Pause Video")..on(Event.CHANGE).listen(onPauseChanged)
   ];

   for(int i = 0; i < buttons.length; i++) {
     buttons[i].x = 82 + i * 293;
     buttons[i].y = 680;
     stage.addChild(buttons[i]);
   }
}

//-----------------------------------------------------------------------------

void onSplitChanged(Event event) {

  var button = event.target as Button;
  var targetScale = button.state ? 0.8 : 1.0;
  var ease = TransitionFunction.easeOutCubic;

  for(var bitmap in videoBitmaps) {
    stage.juggler.removeTweens(bitmap);
    stage.juggler.tween(bitmap, 0.3, ease)
    ..animate.scaleX.to(targetScale)
    ..animate.scaleY.to(targetScale);
  }
}

void on2dChanged(Event event) {

  var button = event.target as Button;
  var targetRotation = button.state ? PI : 0.0;
  var ease = TransitionFunction.easeInOutSine;

  stage.juggler.removeTweens(videoContainer2D);
  stage.juggler.tween(videoContainer2D, 0.3, ease)
  ..animate.rotation.to(targetRotation);
}

void on3dChanged(Event event) {

  var button = event.target as Button;
  var targetOffsetZ = button.state ? 600 : 0.0;
  var targetRotationY = button.state ? 0.9 : 0.0;
  var ease = TransitionFunction.easeInOutSine;

  stage.juggler.removeTweens(videoContainer3D);
  stage.juggler.tween(videoContainer3D, 0.3, ease)
  ..animate3D.offsetZ.to(targetOffsetZ);

  stage.juggler.tween(videoContainer3D, 0.3, ease)
  ..delay = 0.3
  ..animate3D.rotationY.to(targetRotationY);
}

void onFilterChanged(Event event) {

  var button = event.target as Button;
  var displacement = resourceManager.getBitmapData("displacement");
  var transform = new Matrix.fromIdentity();
  var random = new Random();
  var randomInt = button.state ? 1 + random.nextInt(3) : 0;

  if (randomInt == 0) {
    videoContainer2D.filters.clear();
  } else if (randomInt == 1) {
    videoContainer2D.filters.add(new ColorMatrixFilter.invert());
  } else if (randomInt == 2) {
    videoContainer2D.filters.add(new BlurFilter(8, 8));
  } else if (randomInt == 3) {
    transform = new Matrix.fromIdentity();
    transform.translate(-displacement.width / 2, -displacement.height / 2);
    var filter = new DisplacementMapFilter(displacement, transform, 20, 20);
    videoContainer2D.filters.add(filter);
  }
}

void onPauseChanged(Event event) {
  var button = event.target as Button;
  if (button.state) video.pause(); else video.play();
}
