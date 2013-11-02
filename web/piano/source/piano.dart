part of piano;

class Piano extends DisplayObjectContainer {

  final List<String> _pianoNotes = [
    'C3', 'C3#', 'D3', 'D3#', 'E3', 'F3', 'F3#', 'G3', 'G3#', 'A3', 'A3#', 'B3',
    'C4', 'C4#', 'D4', 'D4#', 'E4', 'F4', 'F4#', 'G4', 'G4#', 'A4', 'A4#', 'B4', 'C5'];

  Map<String, PianoKey> _pianoKeys = new Map<String, PianoKey>();
  Bitmap _hintFinger;

  Piano() {

    for(int n = 0, x = 0; n < _pianoNotes.length; n++) {

      // all piano key to this DisplayObjectContainer

      var sound = resourceManager.getSound('Note${n+1}');
      var pianoNote = _pianoNotes[n];
      var pianoKey = new PianoKey(pianoNote, sound);

      pianoKey.on(PianoEvent.NOTE_PLAYED).listen((event) {
        this.dispatchEvent(event);
      });

      _pianoKeys[pianoNote] = pianoKey;

      if (pianoNote.endsWith('#')) {
        pianoKey.x = x - 16;
        pianoKey.y = 35;
        addChild(pianoKey);
      } else {
        pianoKey.x = x;
        pianoKey.y = 35;
        addChildAt(pianoKey, 0);
        x = x + 47;
      }
    }

    // add hint finger to this DisplayObjectContainer

    _hintFinger = new Bitmap(resourceManager.getBitmapData('Finger'));
    _hintFinger.pivotX = 20;
    addChild(_hintFinger);
  }

  //---------------------------------------------------------------------------------

  hintNote(String note) {

    if (_pianoKeys.containsKey(note)) {

      var pianoKey = _pianoKeys[note];
      stage.juggler.removeTweens(_hintFinger);
      _hintFinger.y = 0;
      _hintFinger.alpha = 1;

      var tweenX = new Tween(this._hintFinger, 0.4, TransitionFunction.easeInOutCubic);
      var tweenY = new Tween(this._hintFinger, 0.4, TransitionFunction.sine);
      tweenX.animate.x.to(pianoKey.x + pianoKey.width / 2);
      tweenY.animate.y.to(-10);
      stage.juggler.add(tweenX);
      stage.juggler.add(tweenY);

    } else {

      var tween = new Tween(_hintFinger, 0.4, TransitionFunction.linear);
      tween.animate.alpha.to(0);
      stage.juggler.add(tween);
    }
  }

}