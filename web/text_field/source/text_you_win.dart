part of text_field;

class TextYouWin extends DisplayObjectContainer {

  TextYouWin() {

    var textGradient = new GraphicsGradient.linear(0, 50, 300, 50)
        ..addColorStop(0.0, 0xFFFFD000)
        ..addColorStop(0.3, 0xFFFFFA00)
        ..addColorStop(0.6, 0xFFFFD000)
        ..addColorStop(1.0, 0xFFDDEB1A);

    addChild(_createTextField()
        ..y = -8
        ..defaultTextFormat.strokeColor = Color.Black
        ..defaultTextFormat.strokeWidth = 10);

    addChild(_createTextField()
        ..y = -3
        ..defaultTextFormat.strokeColor = Color.White
        ..defaultTextFormat.strokeWidth = 5);

    addChild(_createTextField()
        ..defaultTextFormat.strokeColor = 0xFF3B615B
        ..defaultTextFormat.strokeWidth = 2
        ..defaultTextFormat.fillGradient = textGradient);
  }

  TextField _createTextField() {

    return new TextField("You win")
        ..width = 500
        ..height = 150
        ..defaultTextFormat.align = TextFormatAlign.CENTER
        ..defaultTextFormat.font = 'Ceviche One'
        ..defaultTextFormat.size = 160
        ..defaultTextFormat.topMargin = - 50
        ..defaultTextFormat.strokeColor = 0xFF3B615B;
  }
}
