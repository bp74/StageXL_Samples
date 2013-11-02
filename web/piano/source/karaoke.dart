part of piano;

class Karaoke {

  List<String> _songNotes;
  List<String> _songLyrics;
  Piano _piano;

  int _songNoteIndex = 0;

  Karaoke(List<String> songNotes, List<String> songLyrics, Piano piano) {

    _songNotes = songNotes;
    _songLyrics = songLyrics;
    _piano = piano;

    // listen to the piano event to get what note was played.
    this._piano.on(PianoEvent.NOTE_PLAYED).listen(_onPianoEvent);

    // start with the first note.
    this.resetSong();
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  void resetSong() {

    _songNoteIndex = 0;
    _updateLyrics();

    if (_songNoteIndex < _songNotes.length) {
      this._piano.hintNote(_songNotes[_songNoteIndex]);
    }
  }

  //-----------------------------------------------------------------------------------------------

  void updateSong(List<String> songNotes, List<String>  songLyrics) {
    _songNotes = songNotes;
    _songLyrics = songLyrics;
    this.resetSong();
  }

  //-----------------------------------------------------------------------------------------------

  _onPianoEvent(PianoEvent event) {

    if (_songNoteIndex < _songNotes.length && _songNotes[_songNoteIndex] == event.note) {

      _songNoteIndex++;
      _updateLyrics();

      if (_songNoteIndex == _songNotes.length) {
        resourceManager.getSound('Cheer').play();
        this._piano.hintNote(null);
      } else {
        this._piano.hintNote(_songNotes[_songNoteIndex]);
      }
    }
  }

  //-----------------------------------------------------------------------------------------------

  _updateLyrics() {

    var lyricsDiv = html.querySelector('#lyrics');
    var wordIndex = -1;

    lyricsDiv.innerHtml = '';

    for(int w = 0, last = 0; w < _songLyrics.length; w++)  {
      if (_songLyrics[w] != '') last = w;
      if (w == this._songNoteIndex) wordIndex = last;
    }

    for(int w = 0; w < _songLyrics.length; w++) {
      if (w == wordIndex) {
        lyricsDiv.appendHtml('<span id="word">${_songLyrics[w]}</span>');
      } else {
        lyricsDiv.appendHtml(_songLyrics[w]);
      }
    }

  }
}