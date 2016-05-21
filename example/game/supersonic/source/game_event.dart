part of supersonic;

class GameEvent extends Event {

  static const String TYPE_LIVES_CHANGED = "GameEvent.TYPE_LIVES_CHANGED";
  static const String TYPE_PROGRESS_CHANGED = "GameEvent.TYPE_PROGRESS_CHANGED";
  static const String TYPE_PAUSE_CHANGED = "GameEvent.TYPE_PAUSE_CHANGED";
  static const String TYPE_LEVEL_CHANGED = "GameEvent.TYPE_LEVEL_CHANGED";
  static const String TYPE_SCORE_CHANGED = "GameEvent.TYPE_SCORE_CHANGED";
  static const String TYPE_GAME_START = "GameEvent.TYPE_GAME_START";
  static const String TYPE_GAME_OVER = "GameEvent.TYPE_GAME_OVER";
  static const String TYPE_GAME_ABORT = "GameEvent.TYPE_GAME_ABORT";
  static const String TYPE_GAME_SIZE_CHANGED = "GameEvent.TYPE_GAME_SIZE_CHANGED";

  Game game;

  GameEvent(String type, this.game, [bool bubbles = false]):super(type, bubbles);
}
