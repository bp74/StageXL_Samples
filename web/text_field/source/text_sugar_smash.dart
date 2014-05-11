part of text_field;

class TextSugarSmash extends DisplayObjectContainer {

  TextSugarSmash() {
    addChild(_createBackground('Sugar')..y = 0);
    addChild(_createBackground('Smash')..y = 28);
    addChild(_createWord('Sugar')..y = 5);
    addChild(_createWord('Smash')..y = 33);
  }

  TextField _createTextField(String text) {

    return new TextField(text)
        ..cacheAsBitmap = false
        ..width = 120
        ..height = 45
        ..defaultTextFormat.size = 32
        ..defaultTextFormat.topMargin = -5
        ..defaultTextFormat.align = TextFormatAlign.CENTER
        ..defaultTextFormat.font = 'Yanone Kaffeesatz';
  }

  TextField _createBackground(String text) {

    return _createTextField(text)
        ..defaultTextFormat.strokeColor = 0xFFF6DFAD
        ..defaultTextFormat.strokeWidth = 7;
  }

  Sprite _createWord(String text) {

    var gradient = new GraphicsGradient.linear(0, 0, 0, 26)
        ..addColorStop(0.0, 0xFFFFDF4F)
        ..addColorStop(0.9, 0xFFD1701F)
        ..addColorStop(1.0, 0xFFEDA72D);

    return new Sprite()
        ..addChild(_createTextField(text)
            ..defaultTextFormat.strokeColor = 0xFF33150A
            ..defaultTextFormat.strokeWidth = 2)
        ..addChild(_createTextField(text)
            ..defaultTextFormat.strokeColor = 0xFFA0721A
            ..defaultTextFormat.strokeWidth = 1
            ..defaultTextFormat.fillGradient = gradient
            ..y = 1);
  }


}
