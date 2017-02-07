import 'dart:html' show CanvasElement, querySelector, TextAreaElement, ButtonElement;
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_richtextfield/stagexl_richtextfield.dart';

CanvasElement canvas = querySelector("#stage");
Stage stage = new Stage(canvas);
RenderLoop renderLoop = new RenderLoop();

void main() {

  renderLoop.addStage(stage);

  ButtonElement reload = querySelector('#reload');
  TextAreaElement textarea = querySelector('#texttodraw');
  RichTextFormat format = new RichTextFormat('Calibri, sans-serif', 25, 0x000000, align: TextFormatAlign.LEFT);
  RichTextFormat excited = format.clone()..bold=true..italic=true..size=30..color=0xFF00FF;

  RichTextField rtf = new RichTextField('',format)
    ..presets['excited'] = excited
    ..text = textarea.value
    ..width = stage.sourceWidth - 20
    ..height = stage.sourceHeight - 10
    ..wordWrap = true
    ..x = 10
    ..y = 5
    ..addTo(stage);

  reload.onClick.listen((e) {
    rtf.text = textarea.value;
  });
}
