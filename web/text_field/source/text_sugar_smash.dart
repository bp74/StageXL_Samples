part of text_field;

class TextSugarSmash extends DisplayObjectContainer {

  TextSugarSmash() {
    addChild(_createBackground('Sugar')..y = -14);
    addChild(_createBackground('Smash')..y = 90);
    addChild(_createWord('Sugar'));
    addChild(_createWord('Smash')..y = 114);

    filters = [new DropShadowFilter(20, math.PI / 4, 0xC0606060, 8, 8)];
  }

  TextField _createTextField(String text) {

    return new TextField(text)
      ..width = 400
      ..height = 250
      ..defaultTextFormat.size = 140
      ..defaultTextFormat.align = TextFormatAlign.CENTER
      ..defaultTextFormat.font = 'Yanone Kaffeesatz';
  }

  TextField _createBackground(String text) {

    return _createTextField(text)
      ..defaultTextFormat.strokeColor = 0xFFF6DFAD
      ..defaultTextFormat.strokeWidth = 30;
  }

  Sprite _createWord(String text) {

    var gradient = new GraphicsGradient.linear(0, 0, 0, 140)
        ..addColorStop(0.0, 0xFFFFDF4F)
        ..addColorStop(0.9, 0xFFD1701F)
        ..addColorStop(1.0, 0xFFEDA72D);

    return new Sprite()
      ..addChild(_createTextField(text)
          ..defaultTextFormat.strokeColor = 0xFF33150A
          ..defaultTextFormat.strokeWidth = 8)
      ..addChild(_createTextField(text)
          ..defaultTextFormat.strokeColor = 0xFFA0721A
          ..defaultTextFormat.strokeWidth = 4
          ..defaultTextFormat.fillGradient = gradient
          ..y = 4);
  }


}
