part of text_field;

class TextYouWin extends DisplayObjectContainer {

  TextYouWin() {

    var textGradient = new GraphicsGradient.linear(0, 0, 240, 0)
        ..addColorStop(0.0, 0xFFFFD000)
        ..addColorStop(0.3, 0xFFFFFA00)
        ..addColorStop(0.6, 0xFFFFD000)
        ..addColorStop(1.0, 0xFFDDEB1A);

    addChild(_createTextField()
        ..y = -4
        ..defaultTextFormat.strokeColor = Color.Black
        ..defaultTextFormat.strokeWidth = 5);

    addChild(_createTextField()
        ..y = -2
        ..defaultTextFormat.strokeColor = Color.White
        ..defaultTextFormat.strokeWidth = 3);

    addChild(_createTextField()
        ..defaultTextFormat.strokeColor = 0xFF3B615B
        ..defaultTextFormat.strokeWidth = 1
        ..defaultTextFormat.fillGradient = textGradient);
  }

  TextField _createTextField() {

    return new TextField("You win")
        ..cacheAsBitmap = false
        ..width = 240
        ..height = 70
        ..defaultTextFormat.align = TextFormatAlign.CENTER
        ..defaultTextFormat.font = 'Ceviche One'
        ..defaultTextFormat.size = 64
        ..defaultTextFormat.topMargin = -15
        ..defaultTextFormat.strokeColor = 0xFF3B615B;
  }
}
