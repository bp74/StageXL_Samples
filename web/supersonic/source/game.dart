part of supersonic;

class Game extends Sprite {

  num _score = 0;
  int _level = 0;
  bool _paused = true;
  int _lives = 3;

  num _progress = 0.0;

  int _gameWidth;
  int _gameHeight;

  Game(int gameWidth, int gameHeight) {
    setWidthHeight( gameWidth, gameHeight );
  }

  void setWidthHeight(int w, int h) {
    _gameWidth = w;
    _gameHeight = h;
    this.dispatchEvent(new GameEvent(GameEvent.TYPE_GAME_SIZE_CHANGED, this));
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  int get gameWidth => _gameWidth;
  int get gameHeight => _gameHeight;

  num get progress => _progress;
  int get lives => _lives;
  num get score => _score;
  int get scoreRounded => _score.toDouble().round().toInt();
  int get level => _level;
  bool get paused => _paused;

  //-----------------------------------------------------------------------------------------------

  set gameWidth(int value) {
    setWidthHeight( value, _gameHeight);
  }

  set gameHeight(int value) {
    setWidthHeight(_gameWidth, value);
  }

  void setSizes(int gameWidth, int gameHeight) {
    setWidthHeight( gameWidth, gameHeight);
  }

  void start() {
    this.paused = false;
    this.dispatchEvent(new GameEvent(GameEvent.TYPE_GAME_START, this));
  }

  void gameOver() {
    this.dispatchEvent(new GameEvent(GameEvent.TYPE_GAME_OVER, this));
  }

  void abortGame() {
    this.dispatchEvent(new GameEvent(GameEvent.TYPE_GAME_ABORT, this));
  }

  set progress(num value) {
    if (value < 0.0) value = 0.0;
    if (value > 1.0) value = 1.0;
    _progress = value;

    this.dispatchEvent(new GameEvent(GameEvent.TYPE_PROGRESS_CHANGED, this));
  }

  set lives(int value) {
    if (value < 0) value = 0;
    _lives = value;

    this.dispatchEvent(new GameEvent(GameEvent.TYPE_LIVES_CHANGED, this));
    if (_lives == 0 ) this.gameOver();
  }

  set score(num value) {
    if (value < 0) value = 0;
    _score= value;

    this.dispatchEvent(new GameEvent(GameEvent.TYPE_SCORE_CHANGED, this));
  }

  set level(int value) {
    if (value < 0) value = 0;
    _level = value;

    this.dispatchEvent(new GameEvent(GameEvent.TYPE_LEVEL_CHANGED, this));
  }

  int nextLevel() {
    this.level += 1;
    return this.level;
  }

  set paused(bool value) {
    _paused = value;
    this.dispatchEvent(new GameEvent(GameEvent.TYPE_PAUSE_CHANGED, this));
  }
}
