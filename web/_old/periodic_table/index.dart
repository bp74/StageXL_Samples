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

Future main() async {

  // configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.Canvas2D;
  StageXL.stageOptions.stageScaleMode = StageScaleMode.SHOW_ALL;
  StageXL.stageOptions.stageAlign = StageAlign.NONE;

  // initialize Stage and RenderLoop

  var stage = new Stage(html.querySelector('#stage'), width: 960, height: 570);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // load the chemical element definition files

  var resourceManager = new ResourceManager();
  resourceManager.addTextFile("table", "data/table.json");
  resourceManager.addTextFile("elements", "data/elements.json");
  await resourceManager.load();

  // create the periodic table display object

  var table = JSON.decode(resourceManager.getTextFile("table"));
  var elements = JSON.decode(resourceManager.getTextFile("elements"));
  var periodicTable = new PeriodicTable(table, elements);
  stage.addChild(periodicTable);
}
