part of escape;

class BoardEvent extends Event {

  static const String Explosion = "Explosion";
  static const String Unlocked = "Unlocked";
  static const String Finalized = "Finalized";
  static const String Timeouted = "Timeouted";

  Map<String, dynamic> _info;

  BoardEvent(String type, Map<String, dynamic> info, [bool bubbles = false]) : super(type, bubbles) {
    _info = info;
  }

  Map<String, dynamic> get info {
    return _info;
  }
}