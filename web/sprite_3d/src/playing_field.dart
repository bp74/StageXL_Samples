part of example;

class PlayingField extends Sprite3D {

  final ResourceManager resourceManager;

  Sprite _cards = new Sprite();
  Juggler _juggler = new Juggler();
  List<Card> _selectedCards = new List<Card>();
  int _numTurnedCards = 0;

  final num ANIM_TIME = 0.5;

  PlayingField(this.resourceManager);

  //---------------------------------------------------------------------------

  void advanceTime(num time) {
    _juggler.advanceTime(time);
  }

  //---------------------------------------------------------------------------

  Future dealCards(int numColumns, int numRows) {

    _cards = _createCardPlane(numColumns, numRows);
    _selectedCards.clear();
    _numTurnedCards = 0;

    removeChildren();
    addChild(_cards);

    var futures = new List<Future>();

    for (int i = 0; i < _cards.numChildren; ++i) {
      var card = _cards.getChildAt(i) as Card;
      var future = _dealCard(card, i * 0.075);
      futures.add(future);
    }

    return Future.wait(futures);
  }

  Future removeCards() {

    var futures = new List<Future>();

    for (int i = 0; i < _cards.numChildren; ++i) {
      var card = _cards.getChildAt(i) as Card;
      var future = _removeCard(card, i * 0.075);
      futures.add(future);
    }

    return Future.wait(futures);
  }

  void concealAllCards() {

    for (int i = 0; i < _cards.numChildren; ++i) {
      var future = _turnCard(_cards.getChildAt(i) as Card, 0.0);
      future.then((card) => card.mouseEnabled = true);
    }
  }

  //---------------------------------------------------------------------------

  Sprite _createCardPlane(int numColumns, int numRows) {

    var plane = new Sprite();
    addChild(plane);

    var atlas = resourceManager.getTextureAtlas("atlas");
    var iconBitmapDatas = atlas .getBitmapDatas("icon-");
    iconBitmapDatas.shuffle();

    var cards = new List<Card>();

    for (int i = 0; i < numColumns * numRows / 2; ++i) {
      var iconBitmapData = iconBitmapDatas.removeAt(0);
      cards.add(new Card(resourceManager, i, iconBitmapData));
      cards.add(new Card(resourceManager, i, iconBitmapData));
    }

    cards.shuffle();

    num margin = 20;
    num cardSize = 128;

    for (int col = 0; col < numColumns; ++col) {
      for (int row = 0; row < numRows; ++row) {
        var card = cards.removeAt(0);
        card.x = (cardSize + margin) * col;
        card.y = (cardSize + margin) * row;
        card.useHandCursor = true;
        card.mouseEnabled = false;
        card.onMouseClick.listen(_onCardSelected);
        card.onTouchBegin.listen(_onCardSelected);
        plane.addChild(card);
      }
    }

    plane.pivotX = (numColumns - 1) * (cardSize + margin) / 2;
    plane.pivotY = (numRows - 1) * (cardSize + margin) / 2;

    return plane;
  }

  //---------------------------------------------------------------------------

  void _onCardSelected(Event event) {

    var card = event.target as Card;
    if (_selectedCards.length < 2) {
      _selectedCards.add(card);
      card.mouseEnabled = false;
      _turnCard(card, 0).then(_onCardRevelead);
    }
  }

  void _onCardRevelead(Card card) {

    if (_selectedCards.indexOf(card) == 1) {
      if (_selectedCards[0].id == _selectedCards[1].id) {
        _numTurnedCards += 2;
        _selectedCards.clear();
        if (_numTurnedCards == _cards.numChildren) {
          dispatchEvent(new Event(Event.COMPLETE, true));
        }
      } else {
        var f1 = _turnCard(_selectedCards[0], ANIM_TIME);
        var f2 = _turnCard(_selectedCards[1], ANIM_TIME);
        Future.wait([f1, f2]).then((cards) {
          _selectedCards.forEach((c) => c.mouseEnabled = true);
          _selectedCards.clear();
        });
      }
    }
  }

  //---------------------------------------------------------------------------

  Future<Card> _dealCard(Card card, num delay) {

    var completer = new Completer<Card>();

    card.alpha = 0;
    card.offsetZ = -150.0;

    _juggler.removeTweens(card);
    _juggler.addTween(card, ANIM_TIME, Transition.easeOutQuadratic)
      ..delay = delay
      ..animate.alpha.to(1.0)
      ..animate3D.offsetZ.to(0.0)
      ..onComplete = () => completer.complete(card);

    return completer.future;
  }

  Future<Card> _removeCard(Card card, num delay) {

    var completer = new Completer<Card>();

    card.alpha = 1.0;
    card.offsetZ = 0.0;

    _juggler.removeTweens(card);
    _juggler.addTween(card, ANIM_TIME, Transition.easeInQuadratic)
      ..delay = delay
      ..animate.alpha.to(0.0)
      ..animate3D.offsetZ.to(-150.0)
      ..onComplete = () => completer.complete(card);

    return completer.future;
  }

  Future<Card> _turnCard(Card card, num delay) {

    var completer = new Completer<Card>();
    var r0 = card.concealed ? PI : 0;
    var r1 = card.concealed ? 0 : PI;

    card.rotationY = r0;
    card.concealed = !card.concealed;

    _juggler.removeTweens(card);
    _juggler.addTween(card, ANIM_TIME, Transition.easeInOutQuadratic)
      ..delay = delay
      ..animate3D.rotationY.to(r1)
      ..onComplete = () => completer.complete(card);

    return completer.future;
  }

}
