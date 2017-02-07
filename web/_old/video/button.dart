part of video_example;

class Button extends Sprite {

  SimpleButton simpleButton;
  bool state = false;

  Bitmap _stateBitmap0;
  Bitmap _stateBitmap1;
  TextField _textField;

  Button(String caption) : super() {

    var textFormat = new TextFormat("Arial", 24, Color.Black);
    textFormat.align = TextFormatAlign.CENTER;
    textFormat.leftMargin = 20;
    textFormat.rightMargin = 20;

    _stateBitmap0 = new Bitmap(new BitmapData(260, 80, Color.LightGray));
    _stateBitmap1 = new Bitmap(new BitmapData(260, 80, Color.LightGreen));

    _stateBitmap0.addTo(this);
    _stateBitmap1.addTo(this);
    _stateBitmap1.alpha = 0.0;

    _textField = new TextField();
    _textField.defaultTextFormat = textFormat;
    _textField.width = 260;
    _textField.height = 80;
    _textField.text = caption;
    _textField.wordWrap = true;
    _textField.y = (_textField.height - _textField.textHeight) / 2;
    _textField.mouseEnabled = false;
    _textField.addTo(this);

    this.onMouseDown.listen(_toggleState);
    this.onTouchBegin.listen(_toggleState);
  }

  void _toggleState(e) {
    state = !state;

    stage.juggler.removeTweens(_stateBitmap1);
    stage.juggler.addTween(_stateBitmap1, 0.25)
      ..animate.alpha.to(state ? 1.0 : 0.0);

    this.dispatchEvent(new Event(Event.CHANGE));
  }
}
