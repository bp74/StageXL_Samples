part of piano;

class PianoKey extends Sprite {

  final String note;
  final Sound sound;

  PianoKey(this.note, this.sound) {

    String key;

    if (note.endsWith('#')) {
      key = 'KeyBlack';
    } else if (note.startsWith('C5')) {
      key = 'KeyWhite0';
    } else if (note.startsWith('C') || note.startsWith('F')) {
      key = 'KeyWhite1';
    } else if (note.startsWith('D') || note.startsWith('G') || note.startsWith('A')) {
      key = 'KeyWhite2';
    } else if (note.startsWith('E') || note.startsWith('B')) {
      key = 'KeyWhite3';
    }

    // add the key to this Sprite
    var bitmapData = resourceManager.getBitmapData(key);
    var bitmap = new Bitmap(bitmapData);
    this.addChild(bitmap);

    // add the note name to this Sprite
    var textColor = note.endsWith('#') ? Color.White : Color.Black;
    var textFormat = new TextFormat('Helvetica,Arial', 10, textColor, align:TextFormatAlign.CENTER);

    var textField = new TextField();
    textField.defaultTextFormat = textFormat;
    textField.text = note;
    textField.width = bitmapData.width;
    textField.height = 20;
    textField.mouseEnabled = false;
    textField.y = bitmapData.height - 20;
    addChild(textField);

    // add mose event handlers
    this.useHandCursor = true;
    this.onMouseDown.listen(_keyDown);
    this.onMouseOver.listen(_keyDown);
    this.onMouseUp.listen(_keyUp);
    this.onMouseOut.listen(_keyUp);
  }

  _keyDown(MouseEvent me) {
    if (me.buttonDown) {
      this.sound.play();
      this.alpha = 0.7;
      this.dispatchEvent(new PianoEvent(this.note));
    }
  }

  _keyUp(MouseEvent me) {
      this.alpha = 1.0;
  }
}
