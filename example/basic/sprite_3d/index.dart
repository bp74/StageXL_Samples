import 'dart:math';
import 'dart:html';
import 'dart:async';
import 'package:stagexl/stagexl.dart';

Future main() async {
  // configure StageXL default options.

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.White;

  // init Stage and RenderLoop

  var canvas = querySelector('#stage');
  var stage = Stage(canvas, width: 400, height: 400);
  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);

  // load a texture atlas with 3 flower BitmapDatas

  var textureAtlas = await TextureAtlas.load('images/Flowers.json');
  var flower1 = textureAtlas.getBitmapData('Flower1');
  var flower2 = textureAtlas.getBitmapData('Flower2');
  var flower3 = textureAtlas.getBitmapData('Flower3');

  // Create cube faces and set the position and orientation in 3D space.

  var cubeFaces = <CubeFace>[
    CubeFace(0xFFFF8080, flower1)
      ..offsetX = -75
      ..rotationY = pi / 2,
    CubeFace(0xFF80FF80, flower1)
      ..offsetX = 75
      ..rotationY = -pi / 2,
    CubeFace(0xFF8080FF, flower2)
      ..offsetY = -75
      ..rotationX = -pi / 2,
    CubeFace(0xFFFFFF80, flower2)
      ..offsetY = 75
      ..rotationX = pi / 2,
    CubeFace(0xFF80FFFF, flower3)
      ..offsetZ = -75
      ..rotationY = 0,
    CubeFace(0xFFFF80FF, flower3)
      ..offsetZ = 75
      ..rotationY = pi
  ];

  // Create a cube and rotate it in the 3D space.

  var cube = Sprite3D();
  cube.x = 200;
  cube.y = 200;
  cube.children.addAll(cubeFaces);
  cube.perspectiveProjection = PerspectiveProjection.fromDepth(1000, 2);
  cube.addTo(stage);

  stage.juggler.timespan(3600.0).listen((time) {
    cube.x = 200 + sin(time) * 80;
    cube.y = 200 + cos(time) * 80;
    cube.rotationX = time * 0.5;
    cube.rotationY = time * 0.7;
    cube.rotationZ = time * 0.9;
  });
}

//-----------------------------------------------------------------------------

class CubeFace extends Sprite3D {
  CubeFace(int color, BitmapData bitmapData) {
    var back = Bitmap(BitmapData(150, 150, color));
    var icon = Bitmap(bitmapData);
    addChild(back..alignPivot());
    addChild(icon..alignPivot());

    // set perspective projection to none because this Sprite3D will
    // be inside of another Sprite3D (the cube) which will define the
    // perspective projection for all its children.
    perspectiveProjection = PerspectiveProjection.none();

    // hide the CubeFace if it isn't forward facing
    onEnterFrame.listen(_onEnterFrame);
  }

  void _onEnterFrame(EnterFrameEvent e) {
    visible = isForwardFacing;
  }
}
