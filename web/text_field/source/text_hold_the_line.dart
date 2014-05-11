part of text_field;

class TextHoldTheLine extends DisplayObjectContainer {

  TextHoldTheLine() {
    addChild(_createTextArc("HOLD THE", 200, _deg2Rad(235), _deg2Rad(70)));
    addChild(_createTextArc("LINE", 150, _deg2Rad(250), _deg2Rad(40)));
  }

  num _deg2Rad(num deg) => deg * math.PI / 180.0;

  TextField _createTextField(String text) {

    return new TextField(text)
        ..cacheAsBitmap = false
        ..autoSize = TextFieldAutoSize.CENTER
        ..defaultTextFormat.align = TextFormatAlign.CENTER
        ..defaultTextFormat.font = 'Poly'
        ..defaultTextFormat.size = 32
        ..defaultTextFormat.color = 0xFFFCEE21;
  }

  Sprite _createLetterSprite(String text) {

    return new Sprite()
        ..addChild(_createTextField(text)
            ..y = -5
            ..defaultTextFormat.strokeWidth = 7
            ..defaultTextFormat.strokeColor = Color.Black)
        ..addChild(_createTextField(text)
            ..y = -1
            ..defaultTextFormat.strokeWidth = 3
            ..defaultTextFormat.strokeColor = Color.White)
        ..addChild(_createTextField(text)
            ..y = 0
            ..defaultTextFormat.strokeWidth = 2
            ..defaultTextFormat.strokeColor = Color.Black);
  }

  Sprite _createTextArc(String text, num offset, num arcStart, num arcLength) {

    var letters = text.split('');
    var container = new Sprite();

    for (int i = 0; i < letters.length; i++) {
      var letterSprite = _createLetterSprite(letters[i]);
      var letterBounds = letterSprite.getBounds(null);
      letterSprite.pivotY = offset;
      letterSprite.pivotX = letterBounds.center.x;
      letterSprite.rotation = math.PI / 2 + arcStart + i * arcLength / (letters.length - 1);
      letterSprite.addTo(container);
    }

    return container;
  }
}
