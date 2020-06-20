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
    var bitmap = Bitmap(bitmapData);
    addChild(bitmap);

    // add the note name to this Sprite
    var textColor = noteName.endsWith('#') ? Color.White : Color.Black;
    var textFormat = TextFormat('Helvetica,Arial', 10, textColor, align: TextFormatAlign.CENTER);

    var textField = TextField();
    textField.defaultTextFormat = textFormat;
    textField.text = noteName;
    textField.width = bitmapData.width;
    textField.height = 20;
    textField.mouseEnabled = false;
    textField.y = bitmapData.height - 20;
    addChild(textField);

    // add mose event handlers
    useHandCursor = true;
    onMouseDown.listen(_keyDown);
    onMouseOver.listen(_keyDown);
    onMouseUp.listen(_keyUp);
    onMouseOut.listen(_keyUp);
  }

  void _keyDown(MouseEvent me) {
    if (me.buttonDown) {
      alpha = 0.7;
      dispatchEvent(PianoEvent(noteName));
      if (resourceManager.containsSoundSprite('Notes')) {
        var soundSprite = resourceManager.getSoundSprite('Notes');
        var soundChannel = soundSprite.getSegment(soundName).play();
        soundChannel.onComplete.listen((e) => print('Complete $noteName'));
      } else {
        var sound = resourceManager.getSound(soundName);
        var soundChannel = sound.play();
        soundChannel.onComplete.listen((e) => print('Complete $noteName'));
      }
    }
  }

  void _keyUp(MouseEvent me) {
    alpha = 1.0;
  }
}
