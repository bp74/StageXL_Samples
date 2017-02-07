part of text_field;

class TextGetReady extends DisplayObjectContainer {

  TextGetReady() {

    addChild(_createTextField()
        ..y = 0
        ..defaultTextFormat.strokeWidth = 2
        ..defaultTextFormat.strokeColor = 0xFF433F4E);

    addChild(_createTextField()
        ..y = 1
        ..defaultTextFormat.strokeWidth = 1
        ..defaultTextFormat.strokeColor = Color.White);

    addChild(_createTextField()
        ..y = 2.25
        ..defaultTextFormat.color = 0xFFDE631D);

    addChild(_createTextField()
        ..y = 1.75
        ..defaultTextFormat.color = 0xFFFFA147);
  }

  TextField _createTextField() {
    return new TextField('GET READY!')
        ..cacheAsBitmap = false
        ..width = 150
        ..height = 40
        ..defaultTextFormat.size = 32
        ..defaultTextFormat.topMargin = -5
        ..defaultTextFormat.align = TextFormatAlign.CENTER
        ..defaultTextFormat.font = 'VT323';
  }
}
