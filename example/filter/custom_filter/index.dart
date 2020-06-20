library custom_filter;

import 'dart:async';
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';

part 'color_matrix_alpha_mask_filter.dart';
part 'color_matrix_alpha_mask_program.dart';

Future main() async {
  // configure StageXL default options
  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.Black;

  // init Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  var stage = Stage(canvas, width: 700, height: 700);
  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);

  // load main and mask image
  var mask = await BitmapData.load('images/mask.png');
  var ship = await BitmapData.load('images/ship.png');

  var shipBitmap = Bitmap(ship);
  shipBitmap.addTo(stage);
  shipBitmap.alignPivot();
  shipBitmap.x = 350;
  shipBitmap.y = 350;

  // create custom filter and add it to the ship image
  var filter = ColorMatrixAlphaMaskFilter(mask, Matrix.fromIdentity());
  shipBitmap.filters.add(filter);

  // apply a dark grayscale color transformation
  filter.colorMatrixList.setAll(0, <double>[
    0.10,
    0.25,
    0.05,
    0.00,
    0.10,
    0.25,
    0.05,
    0.00,
    0.10,
    0.25,
    0.05,
    0.00,
    0.00,
    0.00,
    0.00,
    1.00
  ]);
  filter.colorOffsetList.setAll(0, <double>[0.00, 0.00, 0.00, 0.00]);

  // animate the alpha mask of the filter
  await for (var time in stage.juggler.onElapsedTimeChange) {
    var scale = 1.0 + 0.2 * math.sin(time * 2.7);
    filter.matrix.identity();
    filter.matrix.translate(-200, -200);
    filter.matrix.scale(scale, scale);
    filter.matrix.translate(math.sin(time) * 100, math.cos(time) * 100);
    filter.matrix.translate(256, 256);
  }
}
