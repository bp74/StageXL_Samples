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

  var stage = Stage(html.querySelector('#stage'), width: 960, height: 570);
  var renderLoop = RenderLoop();
  renderLoop.addStage(stage);

  // load the chemical element definition files

  var resourceManager = ResourceManager();
  resourceManager.addTextFile("table", "data/table.json");
  resourceManager.addTextFile("elements", "data/elements.json");
  await resourceManager.load();

  // create the periodic table display object

  var table = json.decode(resourceManager.getTextFile("table"));
  var elements = json.decode(resourceManager.getTextFile("elements"));
  var periodicTable = PeriodicTable(table, elements);
  stage.addChild(periodicTable);
}
