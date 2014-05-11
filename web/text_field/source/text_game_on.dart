part of text_field;

class TextGameOn extends DisplayObjectContainer {

  TextGameOn() {

    var gradient1 = new GraphicsGradient.linear(0, 0, 0, 32)
        ..addColorStop(0.0, 0xFF4591B2)
        ..addColorStop(1.0, 0xFF7AEDD0);

    var gradient2 = new GraphicsGradient.linear(0, 0, 0, 32)
        ..addColorStop(0.0, 0xFFD85585)
        ..addColorStop(1.0, 0xFFF2B499);

    addChild(_createTextField("GAME")
        ..y = 0
        ..defaultTextFormat.fillGradient = gradient1);

    addChild(_createTextField("ON!")
        ..y = 34
        ..defaultTextFormat.fillGradient = gradient2);
  }

  TextField _createTextField(String text) {
    return new TextField(text)
        ..cacheAsBitmap = false
        ..autoSize = TextFieldAutoSize.LEFT
        ..defaultTextFormat.size = 32
        ..defaultTextFormat.font = '"Press Start 2P", cursive'
        ..defaultTextFormat.topMargin = 5
        ..defaultTextFormat.leftMargin = 10
        ..defaultTextFormat.rightMargin = 10
        ..defaultTextFormat.strokeWidth = 1
        ..defaultTextFormat.strokeColor = 0x000000;
  }

}
