part of piano;

class PianoKey extends Sprite {

  final String noteName;
  final String soundName;

  PianoKey(this.noteName, this.soundName) {

    String key;

    if (noteName.endsWith('#')) {
      key = 'KeyBlack';
    } else if (noteName.startsWith('C5')) {
      key = 'KeyWhite0';
    } else if (noteName.startsWith('C') || noteName.startsWith('F')) {
      key = 'KeyWhite1';
    } else if (noteName.startsWith('D') || noteName.startsWith('G') || noteName.startsWith('A')) {
      key = 'KeyWhite2';
    } else if (noteName.startsWith('E') || noteName.startsWith('B')) {
      key = 'KeyWhite3';
    }

    // add the key to this Sprite
    var bitmapData = resourceManager.getBitmapData(key);
    var bitmap = new Bitmap(bitmapData);
    this.addChild(bitmap);

    // add the note name to this Sprite
    var textColor = noteName.endsWith('#') ? Color.White : Color.Black;
    var textFormat = new TextFormat('Helvetica,Arial', 10, textColor, align:TextFormatAlign.CENTER);

    var textField = new TextField();
    textField.defaultTextFormat = textFormat;
    textField.text = noteName;
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
      this.alpha = 0.7;
      this.dispatchEvent(new PianoEvent(this.noteName));
      if (resourceManager.containsSoundSprite("Notes")) {
        var soundSprite = resourceManager.getSoundSprite("Notes");
        soundSprite.getSegment(this.soundName).play();
      } else {
        var sound = resourceManager.getSound(this.soundName);
        sound.play();
      }
    }
  }

  _keyUp(MouseEvent me) {
      this.alpha = 1.0;
  }
}
