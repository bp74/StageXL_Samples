part of escape;

class Bonus extends Sprite {
  Bonus(ResourceManager resourceManager, Juggler juggler, int points) {
    var textField = TextField();
    textField.defaultTextFormat =
        TextFormat('Arial', 30, 0xFFFFFF, bold: true, align: TextFormatAlign.CENTER);
    textField.width = 110;
    textField.height = 36;
    textField.wordWrap = false;
    //textField.selectable = false;
    textField.x = 646;
    textField.y = 130;
    //textField.filters = [GlowFilter(0x000000, 1.0, 2, 2)]; // ToDo
    textField.mouseEnabled = false;
    textField.text = points.toString();
    textField.x = -textField.width / 2;
    textField.y = -textField.height / 2;

    var textFieldContainer = Sprite();
    textFieldContainer.addChild(textField);
    addChild(textFieldContainer);

    //-------------------------------------------------

    var translation = Translation(0.0, 1.0, 1.5, Transition.easeOutCubic);

    translation.onUpdate = (value) {
      textFieldContainer.alpha = 1 - value;
      textFieldContainer.y = -value * 50;
      textFieldContainer.scaleX = 1.0 + 0.1 * math.sin(value * 10);
      textFieldContainer.scaleY = 1.0 + 0.1 * math.cos(value * 10);
    };

    translation.onComplete = () {
      removeFromParent();
    };

    juggler.add(translation);
  }
}
