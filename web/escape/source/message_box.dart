part of escape;

class MessageBox extends Sprite {
  ResourceManager _resourceManager;
  Juggler _juggler;

  DelayedCall _showTimeout;
  Function _doneFunction;

  MessageBox(ResourceManager resourceManager, Juggler juggler, String text) {
    _resourceManager = resourceManager;
    _juggler = juggler;

    var background = Bitmap(_resourceManager.getBitmapData('MessageBox'));
    addChild(background);

    var textFormat =
        TextFormat('Arial', 24, 0xFFFFFF, bold: true, align: TextFormatAlign.CENTER);

    var textField = TextField();
    textField.defaultTextFormat = textFormat;
    textField.width = 240;
    textField.height = 200;
    textField.wordWrap = true;
    //textField.selectable = false;
    textField.text = text;
    textField.x = 47;
    textField.y = 130 - textField.textHeight / 2;
    //textField.filters = [GlowFilter(0x000000, 0.7, 3, 3)];   // ToDo
    textField.mouseEnabled = false;
    addChild(textField);

    _showTimeout = null;

    addEventListener(MouseEvent.CLICK, _onClick);

    filters.add(DropShadowFilter(16, math.pi / 4, 0x80000000, 8, 8, 2));
  }

  //----------------------------------------------------------------------
  //----------------------------------------------------------------------

  void show(Function doneFunction) {
    parent.addChild(this); // move to top
    x = -width;
    y = 150;

    _doneFunction = doneFunction;

    var tween = Tween(this, 0.3, Transition.easeOutCubic);
    tween.animate.x.to(110);
    tween.onComplete = () => _showTimeout = _juggler.delayCall(_hide, 10);

    _juggler.add(tween);
  }

  //----------------------------------------------------------------------

  void _hide() {
    if (_showTimeout != null) {
      _juggler.remove(_showTimeout);
      _showTimeout = null;

      _doneFunction();

      var tween = Tween(this, 0.4, Transition.easeInCubic);
      tween.animate.x.to(800);
      tween.onComplete = () => parent.removeChild(this);

      _juggler.add(tween);
    }
  }

  //----------------------------------------------------------------------

  void _onClick(MouseEvent me) {
    _hide();
  }
}
