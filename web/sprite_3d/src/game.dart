part of example;

class Game extends Sprite implements Animatable {

  final ResourceManager resourceManager;

  PlayingField _playingField;

  Game(this.resourceManager) {

    _playingField = new PlayingField(resourceManager);
    _playingField.rotationX = -0.6;
    _playingField.x = 400;
    _playingField.y = 270;
    _playingField.addTo(this);

    this.on(Event.COMPLETE).listen(_gameCompleted);

    _startGame();
  }

  bool advanceTime(num time) {
    _playingField.advanceTime(time);
    return true;
  }

  void _startGame() {
    _playingField.dealCards(4, 3).then((_) {
      stage.onMouseDown.first.then((e) => _playingField.concealAllCards());
      stage.onTouchBegin.first.then((e) => _playingField.concealAllCards());
    });
  }

  void _gameCompleted(Event event) {
    _playingField.removeCards().then((_) => _startGame());
  }
}
