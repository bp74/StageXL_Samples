#Piano

[Try it here](http://www.stagexl.org/samples/piano/ "StageXL Piano Sample")

---

This is a more advanced StageXL sample and it shows a piano and the lyrics of a
song. The user can choose one of four different songs and then play this song on
the piano. A karaoke like pointer shows which note on the piano needs to be
played next. This sample uses different features of the StageXL library but was
designed to show the capability of StageXL to play audio on all major browsers -
including Internet Explorer :)

### Initialization

The Stage and RenderLoop is initialized in a standard way. The Canvas has a
fixed size and does not scale it's size. We use the ResourceManager to load 7
images (5 piano keys, the finger and the background image), 25 piano sounds and
a cheer sound which is played when the user makes it to the end of a song.

After all resources have been loaded, an instance of the Piano and the Karaoke
class is created. The Piano class is a StageXL DisplayObject and the Karaoke
class is just a helper class to update the lyrics which are displayed as HTML.

### Class Piano

The Piano class extends the DisplayObjectContainer class and contains all the
PianoKeys (see blow) to play the sound of musical notes. All musical notes are
defined in an internal List - since our Piano is a simple one, we can only play
two octaves.

    final List<String> _pianoNotes = [
      'C3', 'C3#', 'D3', 'D3#', 'E3', 'F3', 'F3#', 'G3', 'G3#', 'A3', 'A3#', 'B3',
      'C4', 'C4#', 'D4', 'D4#', 'E4', 'F4', 'F4#', 'G4', 'G4#', 'A4', 'A4#', 'B4', 'C5'];

For every musical note in this list we create a PianoKey. A PianoKey is defined
by the name of the musical note and the sound the user hears when he presses the
key. The sound is retrieved from the ResourceManager. All the sounds were added
to the ResourceManager in the initialization phase.

    for(int n = 0, x = 0; n < _pianoNotes.length; n++) {
      var sound = resourceManager.getSound('Note${n+1}');
      var pianoNote = _pianoNotes[n];
      var pianoKey = new PianoKey(pianoNote, sound);

A hand cursor (it's called finger in the code) points to the next note of the
song. A simple Bitmap instance is used to show the finger. The position of the
finger is controlled with the Juggler framework (get more information about the
Juggler [here][juggler]).

    _hintFinger = new Bitmap(resourceManager.getBitmapData('Finger'));
    addChild(_hintFinger);  

### Class PianoKey

The PianoKey class extends the Sprite class and contains the image of a white or
black piano key. The constructor takes the musical note and the sound which
should be played when the key is pressed. According to the musical note one of 5
possible images of a piano key is selected and added as a child. To make the
PianoKey look a little bit more interessting a TextField with the name of the
musical note is added too.

Four event listeners for MouseDown, MouseUp, MouseOver and MouseOut are added.

    this.onMouseDown.listen(_keyDown);
    this.onMouseOver.listen(_keyDown);
    this.onMouseUp.listen(_keyUp);
    this.onMouseOut.listen(_keyUp);

This makes it easy to know when the user pressed on the key and when the piano
key needs to play the sound of the musical note. A new PianoEvent (see below) is
dispatched every time a note is played. The Piano class listens to this event
and dispatches the same event again. This way other class can listen on the
Piano instance for played notes.

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

### Class PianoEvent

The PianoEvent is used to signal when a note is played. 

    class PianoEvent extends Event {
      static const String NOTE_PLAYED = "NotePlayed";
      final String note;
      PianoEvent(this.note) : super(NOTE_PLAYED);
    } 

### Class Karaoke

The Karaoke class controls the lyrics and notes of the song. To help the user
play the correct notes, it calls the *Piano.hintNote* method every time a new
note needs to be played. It also listens to the PianoEvent of the Piano to get
all played notes. This way the Karoke class controls the current word of the
lyrics and also the next note of the song.

### songs.dart

The file contains the notes and lyrics of four songs: Happy Birthay, Hey Jude,
The Star-Spangled Banner and You are my sunshine.

---

To learn more about Dart and the StageXL library, please follow these links: 

* Dart programming language: <http://www.dartlang.org/>
* StageXL homepage: <http://www.stagexl.org/>
* StageXL on GitHub: <http://www.github.com/bp74/StageXL>


[juggler]: http://www.stagexl.org/docs/wiki-articles.html?article=juggler