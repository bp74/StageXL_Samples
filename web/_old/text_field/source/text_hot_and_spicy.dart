part of text_field;

class TextHotAndSpicy extends DisplayObjectContainer {

  TextHotAndSpicy() {

    var textGradient = new GraphicsGradient.linear(0, 0, 0, 32)
        ..addColorStop(0.0, 0xFFFEBBA8)
        ..addColorStop(1.0, 0xFFFF3100);

    var textField = new TextField(" Hot & Spicy ")
        ..cacheAsBitmap = false
        ..autoSize = TextFieldAutoSize.LEFT
        ..defaultTextFormat.font = '"Norican", cursive'
        ..defaultTextFormat.size = 32
        ..defaultTextFormat.strokeWidth = 1
        ..defaultTextFormat.strokeColor = 0xFF600105
        ..defaultTextFormat.fillGradient = textGradient;

    addChild(textField);
  }

}
