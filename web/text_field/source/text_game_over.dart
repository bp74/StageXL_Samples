part of text_field;

class TextGameOver extends DisplayObjectContainer {

  TextGameOver() {

    var gradient1 = new GraphicsGradient.linear(0, 0, 75, 38)
        ..addColorStop(0.0, 0xFFFBF4ED)
        ..addColorStop(1.0, 0xFFF8E123);

    var gradient2 = new GraphicsGradient.linear(0, 0, 125, 75)
        ..addColorStop(0.0, 0xFFFBF4ED)
        ..addColorStop(0.4, 0xFFF8E123)
        ..addColorStop(1.0, 0xFFF05D26);

    addChild(_createTextField("Over", 36)
        ..y = 6
        ..defaultTextFormat.fillGradient = gradient2);

    addChild(_createTextField("Game", 20)
        ..x = 30
        ..defaultTextFormat.fillGradient = gradient1);
  }

  TextField _createTextField(String text, int size) {
    return new TextField(text)
        ..cacheAsBitmap = false
        ..autoSize = TextFieldAutoSize.LEFT
        ..defaultTextFormat.font = 'Poller One'
        ..defaultTextFormat.size = size
        ..defaultTextFormat.strokeWidth = 3
        ..defaultTextFormat.strokeColor = Color.Black
        ..defaultTextFormat.align = TextFormatAlign.CENTER;
  }
}
