import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_bitmapfont/stagexl_bitmapfont.dart';

String text = """
Hello World!
Grumpy wizards make
toxic brew for the
evil Queen and Jack.""";

Future main() async {

  // Configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.DarkSlateGray;
  StageXL.bitmapDataLoadOptions.webp = true;

  // Init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 800, height: 400);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load BitmapFont

  var fontUrl = "fonts/Luckiest_Guy.fnt";
  //var fontUrl = "fonts/Fascinate_Inline.fnt";
  //var fontUrl = "fonts/Orbitron.fnt";
  //var fontUrl = "fonts/Permanent_Marker.fnt";
  //var fontUrl = "fonts/Sarina.fnt";
  //var fontUrl = "fonts/Sigmar_One.fnt";

  var bitmapFont = await BitmapFont.load(fontUrl, BitmapFontFormat.FNT);

  // create BitmapContainerText and add it to the Stage

  var bitmapContainerText = new BitmapContainerText(bitmapFont);
  bitmapContainerText.x = 50;
  bitmapContainerText.y = 50;
  bitmapContainerText.text = text;
  bitmapContainerText.addTo(stage);

  animateBitmapText(bitmapContainerText, stage.juggler);
}

//-----------------------------------------------------------------------------

Future animateBitmapText(BitmapContainerText bct, Juggler juggler) async {

  for (var bitmap in bct.children) {
    bitmap.pivotX = bitmap.width / 2;
    bitmap.pivotY = bitmap.height / 2;
    bitmap.x += bitmap.pivotX;
    bitmap.y += bitmap.pivotY;
  }

  await for (var elapsedTime in juggler.onElapsedTimeChange) {
    for (var bitmap in bct.children) {
      bitmap.rotation = 0.2 * math.sin(elapsedTime * 8 + bitmap.x);
    }
  }
}
