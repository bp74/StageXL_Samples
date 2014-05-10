part of text_field;

class TextHotAndSpicy extends DisplayObjectContainer {

  TextHotAndSpicy() {

    var textGradient = new GraphicsGradient.linear(0, 0, 0, 120)
        ..addColorStop(0.0, 0xFFFEBBA8)
        ..addColorStop(1.0, 0xFFFF3100);

    var textField = new TextField(" Hot & Spicy ")
        ..autoSize = TextFieldAutoSize.LEFT
        ..defaultTextFormat.font = '"Norican", cursive'
        ..defaultTextFormat.size = 120
        ..defaultTextFormat.strokeWidth = 3
        ..defaultTextFormat.strokeColor = 0xFF600105
        ..defaultTextFormat.fillGradient = textGradient;

    addChild(textField);
  }

}
