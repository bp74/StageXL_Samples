import 'dart:html' show CanvasElement, querySelector, TextAreaElement, ButtonElement;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_richtextfield/stagexl_richtextfield.dart';

void main() {

  CanvasElement canvas = querySelector("#richtext");
  TextAreaElement textarea = querySelector('#texttodraw');
  ButtonElement reload = querySelector('#reload');
  Stage stage = new Stage(canvas, webGL: true)
    ..scaleMode = StageScaleMode.SHOW_ALL;
  RenderLoop render = new RenderLoop();
  RichTextFormat format = new RichTextFormat('Calibri, sans-serif', 25, 0x000000, align: TextFormatAlign.LEFT);
  RichTextFormat excited = format.clone()..bold=true..italic=true..size=30..color=0xFF00FF;
  RichTextField rtf = new RichTextField('',format)
    ..presets['excited'] = excited
    ..text = textarea.value
    ..width = stage.sourceWidth
    ..height = stage.sourceHeight
    ..wordWrap = true
    ..y = 0;

  render.addStage(stage);
  stage.addChild(rtf);


  reload.onClick.listen((e) {
    rtf.text = textarea.value;
  });

}