part of piano;

class PianoEvent extends Event {

  static const String NOTE_PLAYED = "NotePlayed";
  final String note;

  PianoEvent(this.note) : super(NOTE_PLAYED);
}