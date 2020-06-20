part of supersonic;

class GameComponent extends Sprite {
  Game _game;

  GameComponent(Game game) {
    this.game = game;
  }

  set game(Game game) {
    if (_game != null) {
      _game.removeEventListeners(GameEvent.TYPE_GAME_OVER);
      _game.removeEventListeners(GameEvent.TYPE_GAME_ABORT);
      _game.removeEventListeners(GameEvent.TYPE_GAME_SIZE_CHANGED);
      _game.removeEventListeners(GameEvent.TYPE_GAME_START);
      _game.removeEventListeners(GameEvent.TYPE_LEVEL_CHANGED);
      _game.removeEventListeners(GameEvent.TYPE_PAUSE_CHANGED);
      _game.removeEventListeners(GameEvent.TYPE_SCORE_CHANGED);
      _game.removeEventListeners(GameEvent.TYPE_LIVES_CHANGED);
      _game.removeEventListeners(GameEvent.TYPE_PROGRESS_CHANGED);
    }

    _game = game;

    if (_game != null) {
      _game.addEventListener(GameEvent.TYPE_GAME_OVER, onGameOver);
      _game.addEventListener(GameEvent.TYPE_GAME_ABORT, onGameAbort);
      _game.addEventListener(GameEvent.TYPE_GAME_SIZE_CHANGED, onGameSizeChanged);
      _game.addEventListener(GameEvent.TYPE_GAME_START, onGameStart);
      _game.addEventListener(GameEvent.TYPE_LEVEL_CHANGED, onLevelChanged);
      _game.addEventListener(GameEvent.TYPE_PAUSE_CHANGED, onPauseChanged);
      _game.addEventListener(GameEvent.TYPE_SCORE_CHANGED, onScoreChanged);
      _game.addEventListener(GameEvent.TYPE_LIVES_CHANGED, onLivesChanged);
      _game.addEventListener(GameEvent.TYPE_PROGRESS_CHANGED, onProgressChanged);
    }
  }

  Game get game => _game;

  void onGameOver(GameEvent event) {}
  void onGameAbort(GameEvent event) {}
  void onGameSizeChanged(GameEvent event) {}
  void onGameStart(GameEvent event) {}
  void onLevelChanged(GameEvent event) {}
  void onPauseChanged(GameEvent event) {}
  void onScoreChanged(GameEvent event) {}
  void onLivesChanged(GameEvent event) {}
  void onProgressChanged(GameEvent event) {}
}
