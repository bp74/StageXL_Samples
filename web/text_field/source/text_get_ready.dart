part of text_field;

class TextGetReady extends DisplayObjectContainer {

  TextGetReady() {

    addChild(_createTextField()
        ..y = 0
        ..defaultTextFormat.strokeWidth = 7
        ..defaultTextFormat.strokeColor = 0xFF433F4E);

    addChild(_createTextField()
        ..y = 3
        ..defaultTextFormat.strokeWidth = 4
        ..defaultTextFormat.strokeColor = Color.White);

    addChild(_createTextField()
        ..y = 8
        ..defaultTextFormat.color = 0xFFDE631D);

    addChild(_createTextField()
        ..y = 6
        ..defaultTextFormat.color = 0xFFFFA147);
  }

  TextField _createTextField() {
    return new TextField('GET READY!')
        ..width = 600
        ..height = 200
        ..defaultTextFormat.size = 140
        ..defaultTextFormat.align = TextFormatAlign.CENTER
        ..defaultTextFormat.font = 'VT323';
  }
}
