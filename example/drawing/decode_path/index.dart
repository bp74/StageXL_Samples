import 'dart:async';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';

Future main() async {

  // Configure StageXL default options

  StageXL.stageOptions.renderEngine = RenderEngine.WebGL;
  StageXL.stageOptions.backgroundColor = Color.White;
  StageXL.stageOptions.antialias = true;

  // Init Stage and RenderLoop

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 900, height: 700);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  // draw SVG encoded pie chart

  var pieChart = new Shape();
  pieChart.graphics.beginPath();
  pieChart.graphics.decodePath('M 200 200 v -150 a 150 150 0 0 0 -150 150 z');
  pieChart.graphics.fillColor(Color.Yellow);
  pieChart.graphics.strokeColor(Color.SteelBlue, 4);
  pieChart.graphics.beginPath();
  pieChart.graphics.decodePath('M 230 230 h -150 a 150 150 0 1 0 150 -150 z');
  pieChart.graphics.fillColor(Color.LightCyan);
  pieChart.graphics.strokeColor(Color.SteelBlue, 4);
  stage.addChild(pieChart);

  // draw SVG encoded glyphs

  var glyphs = new Shape();
  glyphs.graphics.decodePath('M961 45 C961 69 952 77 942 77 C929 77 917 63 890 63 C843 63 836 120 836 177 C836 277 854 297 854 363 C854 411 828 430 780 430 C739 430 712 419 661 419 C609 419 585 482 543 482 C506 482 469 459 469 422 C469 390 496 370 530 357 C535 333 535 293 535 276 C535 135 411 61 276 61 C188 61 120 117 120 216 C120 309 181 372 269 372 C292 372 340 372 340 338 C340 309 295 289 295 259 C295 237 309 223 351 223 C395 223 436 286 436 331 C436 416 344 438 277 438 C129 438 25 349 25 198 C25 64 136 -21 279 -21 C591 -21 626 201 626 306 L626 335 C635 334 643 333 645 333 C670 333 710 339 730 339 C736 339 741 339 747 337 C752 335 754 326 754 314 C754 277 736 205 736 163 C736 85 752 -12 876 -12 C917 -12 961 3 961 45 L961 45 Z');
  glyphs.graphics.fillColor(Color.LightPink);
  glyphs.graphics.strokeColor(Color.Black, 10);
  glyphs.x = 450;
  glyphs.y = 270;
  glyphs.scaleX = 0.4;
  glyphs.scaleY = -0.4;
  stage.addChild(glyphs);

  // draw SVG encoded elliptic arcs

  var arcsShape = new Shape();
  var arcs = 'M 380 580 l 50 -25 a25 25 -30 0 1 50 -25 l 50 -25 a25 50 -30 0 1 50 -25 l 50 -25 a25 75 -30 0 1 50 -25 l 50 -25 a 25 100 -30 0 1 50 -25 l50 -25';
  arcsShape.graphics.decodePath(arcs);
  arcsShape.graphics.strokeColor(Color.Blue, 15);
  stage.addChild(arcsShape);

  // draw SVG encoded rings

  var ring = new Shape();
  ring.graphics.beginPath();
  ring.graphics.decodePath('M 670,540 a100,50 0 0,0 100,50');
  ring.graphics.strokeColor(0xFFFF0000, 5);
  ring.graphics.beginPath();
  ring.graphics.decodePath('M 670,540 a100,50 0 0,1 100,50');
  ring.graphics.strokeColor(0xFF00FF00, 5);
  ring.graphics.beginPath();
  ring.graphics.decodePath('M 670,540 a100,50 0 1,0 100,50');
  ring.graphics.strokeColor(0xFF0000FF, 5);
  ring.graphics.beginPath();
  ring.graphics.decodePath('M 670,540 a100,50 0 1,1 100,50');
  ring.graphics.strokeColor(0xFFFF00FF, 5);
  stage.addChild(ring);

  // draw EaselJS encoded anchor

  var anchorShape = new Shape();
  var anchor = 'AOsLuIiMAAIAAhQICMAAIAAAAIAAgoYg8gUgyg8AAhGYAAhaBGhGBQAAYBaAABGBGAABaYAABGgyA8hGAUIAAAoIAAAAICWAAIAABQIiWAAIAAAAIAAG4YAAAADmgUBki0Ig8goIC0hkIAKDSIg8geYAAAAhQDwloAAYloAAhQkOAAAAIg8AeIAei+ICgBQIg8AoYAAAABaDSDwAUIAAm4IAAAA';
  anchorShape.graphics.decodePath(anchor, PathEncoding.EaselJS);
  anchorShape.graphics.closePath();
  anchorShape.graphics.fillColor(Color.DarkGray);
  anchorShape.graphics.strokeColor(Color.Black, 2);
  anchorShape.y = 375;
  anchorShape.scaleX = anchorShape.scaleY = 2.0;
  stage.addChild(anchorShape);
}
