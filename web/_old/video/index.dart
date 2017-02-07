library video_example;

import 'dart:async';
import 'dart:math';
import 'dart:html' as html;
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

Future main() async {

  // configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.inputEventMode = InputEventMode.MouseAndTouch;
  StageXL.stageOptions.stageScaleMode = StageScaleMode.SHOW_ALL;
  StageXL.stageOptions.stageAlign = StageAlign.NONE;

  StageXL.videoLoadOptions.corsEnabled = true;

  // init Stage and RenderLoop

  stage = new Stage(html.querySelector('#stage'), width:1600, height: 800);
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load resources

  resourceManager = new ResourceManager();
  //resourceManager.addVideo("sintel", "videos/sintel.mp4");
  resourceManager.addBitmapData("displacement", "images/displacement.png");
  await resourceManager.load();

  // show user information

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

  // wait for a mouse click or touch press to start the video.
  // On most mobile devices loading a video only works from an
  // input event and not from elsewhere.

  stage.onMouseDown.first.then(loadAndPlayVideo);
  stage.onTouchBegin.first.then(loadAndPlayVideo);
}

//-----------------------------------------------------------------------------

void loadAndPlayVideo(e) {

  print(e);

  stage.removeChildren();

  var videoLoadOptions = StageXL.videoLoadOptions;
  var videoSources = videoLoadOptions.getOptimalVideoUrls("videos/sintel.mp4");

  Video.load(videoSources.first).then((Video sintelVideo) {
    showVideo(sintelVideo);
  }).catchError((e) {
    html.window.alert(e.toString());
  });
}

//-----------------------------------------------------------------------------

void showVideo(Video sintelVideo) {

  video = sintelVideo;
  video.loop = true;
  video.play();

  videoBitmapData = new BitmapData.fromVideoElement(video.videoElement);

  videoContainer3D = new Sprite3D();
  videoContainer3D.x = 800;
  videoContainer3D.y = 340;
  videoContainer3D.addTo(stage);

  videoContainer2D = new Sprite();
  videoContainer2D.scaleX = 2.0;
  videoContainer2D.scaleY = 2.0;
  videoContainer2D.addTo(videoContainer3D);

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
  var scale = button.state ? 0.8 : 1.0;
  var transition = Transition.easeOutCubic;

  for(var bitmap in videoBitmaps) {
    stage.juggler.removeTweens(bitmap);
    stage.juggler.addTween(bitmap, 0.3, transition)
    ..animate.scaleX.to(scale)
    ..animate.scaleY.to(scale);
  }
}

void on2dChanged(Event event) {

  var button = event.target as Button;
  var rotation = button.state ? PI : 0.0;
  var ease = Transition.easeInOutSine;

  stage.juggler.removeTweens(videoContainer2D);
  stage.juggler.addTween(videoContainer2D, 0.3, ease)
  ..animate.rotation.to(rotation);
}

void on3dChanged(Event event) {

  var button = event.target as Button;
  var offsetZ = button.state ? 600 : 0.0;
  var rotationY = button.state ? 0.9 : 0.0;
  var ease = Transition.easeInOutSine;

  stage.juggler.removeTweens(videoContainer3D);
  stage.juggler.addTween(videoContainer3D, 0.3, ease)
  ..animate3D.offsetZ.to(offsetZ);

  stage.juggler.addTween(videoContainer3D, 0.3, ease)
  ..delay = 0.3
  ..animate3D.rotationY.to(rotationY);
}

void onFilterChanged(Event event) {

  var button = event.target as Button;
  var random = new Random();
  var randomInt = button.state ? 1 + random.nextInt(5) : 0;

  if (randomInt == 0) {
    videoContainer2D.filters.clear();
  } else if (randomInt == 1) {
    videoContainer2D.filters.add(new ColorMatrixFilter.invert());
  } else if (randomInt == 2) {
    videoContainer2D.filters.add(new BlurFilter(8, 8, 3));
  } else if (randomInt == 3) {
    videoContainer2D.filters.add(new TintFilter.fromColor(Color.Red));
  } else if (randomInt == 4) {
    var filter = new DropShadowFilter(6, PI / 4, 0x80000000, 3, 3, 2);
    videoContainer2D.filters.add(filter);
  } else if (randomInt == 5) {
    var displacement = resourceManager.getBitmapData("displacement");
    var transform = new Matrix.fromIdentity();
    transform.translate(-displacement.width / 2, -displacement.height / 2);
    var filter = new DisplacementMapFilter(displacement, transform, 20, 20);
    videoContainer2D.filters.add(filter);
  }
}

void onPauseChanged(Event event) {
  var button = event.target as Button;
  if (button.state) video.pause(); else video.play();
}
