import 'dart:math';
import 'dart:html';
import 'package:stagexl/stagexl.dart';

void main() {

  // configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.Canvas2D;
  StageXL.stageOptions.backgroundColor = Color.White;

  // init Stage and RenderLoop

  var canvas = querySelector('#stage');
  var stage = new Stage(canvas, width: 800, height: 600);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // Create random bezier curves

  var random = new Random();

  for(int i = 0; i < 5; i++) {

    var curveData1 = new CurveData.fromRandom(random);
    var curveData2 = new CurveData.fromRandom(random);
    var curve = new Curve(curveData1, curveData2);

    stage.addChild(curve);
    stage.juggler.add(curve);

    stage.juggler.interval(1.5).listen((_) {
      var cp = new CurveData.fromRandom(random);
      curve.animateTo(cp);
    });
  }
}

//------------------------------------------------------------------------------

class Curve extends Shape implements Animatable {

  CurveData _curveData1;
  CurveData _curveData2;

  GraphicsCommandMoveTo _moveto;
  GraphicsCommandBezierCurveTo _bezier;
  GraphicsCommandStrokeColor _stroke;
  double _time = 0.0;

  Curve(CurveData curveData1, CurveData curveData2) {
    _curveData1 = curveData1;
    _curveData2 = curveData2;
    _moveto = this.graphics.moveTo(0, 0);
    _bezier = this.graphics.bezierCurveTo(0, 0, 0, 0, 0, 0);
    _stroke = this.graphics.strokeColor(Color.White, 15);
    this.advanceTime(0.0);
  }

  bool advanceTime(num delta) {

    var t = Transition.easeInOutCubic(min(_time += delta, 1.0));
    var p = new CurveData.interpolate(_curveData1, _curveData2, t);

    _moveto.x = p.x1;
    _moveto.y = p.y1;
    _bezier.controlX1 = p.controlX1;
    _bezier.controlY1 = p.controlY1;
    _bezier.controlX2 = p.controlX2;
    _bezier.controlY2 = p.controlY2;
    _bezier.endX = p.x2;
    _bezier.endY = p.y2;
    _stroke.width = p.width;
    _stroke.color = p.color;

    return true;
  }

  void animateTo(CurveData curveData) {
    _curveData1 = _curveData2;
    _curveData2 = curveData;
    _time = 0.0;
  }
}

//------------------------------------------------------------------------------

class CurveData {

  num x1 = 0, y1 = 0, x2 = 0, y2 = 0;
  num controlX1 = 0, controlY1 = 0;
  num controlX2 = 0, controlY2 = 0;
  num colorA = 0, colorR = 0, colorG = 0, colorB = 0;
  num width = 0;

  CurveData.fromRandom(Random random) {
    x1 = random.nextInt(800);
    y1 = random.nextInt(600);
    x2 = random.nextInt(800);
    y2 = random.nextInt(600);
    controlX1 = random.nextInt(800);
    controlY1 = random.nextInt(600);
    controlX2 = random.nextInt(800);
    controlY2 = random.nextInt(600);
    width = 5 + random.nextInt(10);
    colorA = random.nextDouble();
    colorR = random.nextDouble();
    colorG = random.nextDouble();
    colorB = random.nextDouble();
  }

  CurveData.interpolate(CurveData a, CurveData b, double ratio) {
    x1 = a.x1 + (b.x1 - a.x1) * ratio;
    y1 = a.y1 + (b.y1 - a.y1) * ratio;
    x2 = a.x2 + (b.x2 - a.x2) * ratio;
    y2 = a.y2 + (b.y2 - a.y2) * ratio;
    controlX1 = a.controlX1 + (b.controlX1 - a.controlX1) * ratio;
    controlY1 = a.controlY1 + (b.controlY1 - a.controlY1) * ratio;
    controlX2 = a.controlX2 + (b.controlX2 - a.controlX2) * ratio;
    controlY2 = a.controlY2 + (b.controlY2 - a.controlY2) * ratio;
    width = a.width + (b.width - a.width) * ratio;
    colorA = a.colorA + (b.colorA - a.colorA) * ratio;
    colorR = a.colorR + (b.colorR - a.colorR) * ratio;
    colorG = a.colorG + (b.colorG - a.colorG) * ratio;
    colorB = a.colorB + (b.colorB - a.colorB) * ratio;
  }

  int get color {
    int a = (colorA * 255).round();
    int r = (colorR * 255).round();
    int g = (colorG * 255).round();
    int b = (colorB * 255).round();
    return (a << 24) + (r << 16) + (g << 8) + b;
  }
}
