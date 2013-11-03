library periodic_table;

import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

part 'source/category_detail.dart';
part 'source/category_button.dart';
part 'source/element_button.dart';
part 'source/element_detail.dart';
part 'source/periodic_table.dart';

Stage stage;
RenderLoop renderLoop;
ResourceManager resourceManager;

void main() {

  // This sample is work in progress!

  //------------------------------------------------------------------
  // Initialize the Display List
  //------------------------------------------------------------------

  var canvas = html.querySelector('#stage');
  stage = new Stage("myStage", canvas, 940, 570);
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;

  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  //------------------------------------------------------------------
  // Load a TextureAtlas
  //------------------------------------------------------------------

  BitmapData.defaultLoadOptions.webp = true;

  resourceManager = new ResourceManager()
    ..addTextFile("table", "data/table.json")
    ..addTextFile("elements", "data/elements.json")
    ..load().then((result) {
      var table = JSON.decode(resourceManager.getTextFile("table"));
      var elements = JSON.decode(resourceManager.getTextFile("elements"));
      var periodicTable = new PeriodicTable(table, elements);
      stage.addChild(periodicTable);
    });
}
