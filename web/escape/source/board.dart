part of escape;

class Board extends ViewportContainer {
  // LEVEL |  1 |  2 |  3 |  4 |  5 |  6 |  7 | ++
  //-------|------------------------------------------
  int _levelChains; //       | 40 | 45 | 50 | 55 | 60 | 65 | 70 | ++5
  int _levelLocks; //       |  3 |  3 |  4 |  4 |  5 |  5 |  5 | ==
  int _levelJokers; //       |  0 |  1 |  2 |  3 |  4 |  5 |  5 | ==
  int _levelBlocks; //       |  0 |  0 |  2 |  3 |  4 |  5 |  6 | ==
  int _levelDoubles; //       |  0 |  0 |  1 |  2 |  2 |  3 |  3 | ==
  int _levelQuints; //       |  0 |  0 |  0 |  0 |  1 |  2 |  2 | ==
  int _levelColors; //       |  3 |  3 |  3 |  3 |  3 |  4 |  4 | ==

  //-------------------------------------------------------------------------------------------------

  ResourceManager _resourceManager;
  Juggler _juggler;

  math.Random _random;
  int _status;

  List<int> _colors;
  List<Field> _queue;
  List<Field> _fields;
  List<Lock> _locks;

  List<Point> _mouseBuffer;
  bool _animationRunning;

  Sprite _chainLayer;
  Sprite _linkLayer;
  Sprite _specialLayer;
  Sprite _lockLayer;
  Sprite _explosionLayer;

  //-------------------------------------------------------------------------------------------------

  Board(ResourceManager resourceManager, Juggler juggler, int chains, int locks, int jokers,
      int blocks, int doubles, int quints, List<int> colors) {
    _resourceManager = resourceManager;
    _juggler = juggler;

    _random = math.Random();
    _status = BoardStatus.Playing;
    _colors = colors;

    _levelChains = chains;
    _levelLocks = locks;
    _levelJokers = jokers;
    _levelBlocks = blocks;
    _levelDoubles = doubles;
    _levelQuints = quints;
    _levelColors = colors.length;

    _mouseBuffer = <Point>[];

    //----------------------------

    _chainLayer = Sprite();
    _linkLayer = Sprite();
    _specialLayer = Sprite();
    _lockLayer = Sprite();
    _explosionLayer = Sprite();

    addChild(_chainLayer);
    addChild(_linkLayer);
    addChild(_specialLayer);
    addChild(_lockLayer);
    addChild(_explosionLayer);

    _linkLayer.mouseEnabled = false;
    _specialLayer.mouseEnabled = false;
    _lockLayer.mouseEnabled = false;
    _explosionLayer.mouseEnabled = false;

    //----------------------------

    initLocks();
    initQueue();
    initField();

    _animationRunning = true;

    var completeCounter = ValueCounter();

    //this.mask = Mask.rectangle(0.0, 0.0, 500.0, 500.0);
    viewport = Rectangle(0, 0, 500, 500);

    for (var x = 0; x < 10; x++) {
      for (var y = 0; y < 10; y++) {
        var field = _fields[x + y * 10];
        field.x = x * 50 + 25;
        field.y = y * 50 + 25 - 550;
        field.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);

        var transition = Transition.easeOutCubic;
        var translation = Translation(field.y, y * 50 + 25, 0.4, transition);

        translation.delay = x * 0.03;

        translation.onUpdate = (value) {
          field.y = value;
        };

        translation.onComplete = () {
          if (completeCounter.increment() == 100) {
            _updateLinks();
            _animationRunning = false;
            _mouseBuffer.clear();
            //this.mask = null;
            viewport = null;
          }
        };

        _juggler.add(translation);
      }
    }

    //----------------------------

    addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
  }

  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  void updateStatus(int status) {
    if (status == BoardStatus.Finalizing) {
      _status = status;
    }

    if (status == BoardStatus.Timeouting && _status == BoardStatus.Playing) {
      _status = status;

      if (_animationRunning == false) {
        dispatchEvent(BoardEvent(BoardEvent.Timeouted, null));
      }
    }
  }

  //-------------------------------------------------------------------------------------------------

  void dropFields() {
    //this.mask = Mask.rectangle(0.0, 0.0, 500.0, 500.0);
    viewport = Rectangle(0, 0, 500, 500);

    for (var y = 0; y < 10; y++) {
      for (var x = 0; x < 10; x++) {
        var field = _fields[x + y * 10];

        field.linked = false;
        field.linkedJoker = false;
        field.special = Special.None;
        field.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);

        var transition = Transition.easeOutCubic;
        var translation = Translation(field.y, 500 + y * 50 + 25, 0.5, transition);
        translation.delay = x * 0.1;

        translation.onUpdate = (value) {
          field.y = value;
        };

        _juggler.add(translation);
      }
    }
  }

  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  void initLocks() {
    _locks = <Lock>[];

    for (var l = 0; l < _levelLocks; l++) {
      var lock = Lock(_resourceManager, _juggler, l);
      lock.rotation = (_random.nextInt(30) - 15) * math.pi / 180;
      lock.x = 300 - (90 * _levelLocks) / 2 + l * 90 + _random.nextInt(20) - 10;
      lock.y = 550;

      _locks.add(lock);
      _lockLayer.addChild(lock);
    }
  }

  //-------------------------------------------------------------------------------------------------

  int countLinks(int x, int y) {
    var linkCount = 0;
    var field = _fields[x + y * 10];

    if (field.direction == 0) {
      var fieldWest = (x > 0) ? _fields[x - 1 + y * 10] : null;
      var fieldEast = (x < 9) ? _fields[x + 1 + y * 10] : null;

      if (field.canLinkHorizontal(fieldWest)) linkCount++;
      if (field.canLinkHorizontal(fieldEast)) linkCount++;
    } else {
      var fieldNorth = (y > 0) ? _fields[x + (y - 1) * 10] : null;
      var fieldSouth = (y < 9) ? _fields[x + (y + 1) * 10] : null;

      if (field.canLinkVertical(fieldNorth)) linkCount++;
      if (field.canLinkVertical(fieldSouth)) linkCount++;
    }

    return linkCount;
  }

  //-------------------------------------------------------------------------------------------------

  bool clearCombinations() {
    for (var y = 0; y < 10; y++) {
      for (var x = 0; x < 10; x++) {
        var field = _fields[x + y * 10];
        var retry = _levelColors * 2;

        while (countLinks(x, y) == 2 && retry > 0) {
          if (retry % 2 == 0) {
            field.direction = 1 - field.direction;
            retry--;
          } else {
            var colorIndex = 0;

            for (var ci = 0; ci < _colors.length; ci++) {
              if (field.color == _colors[ci]) {
                colorIndex = ci;
              }
            }

            field.color = _colors[(colorIndex + 1) % _colors.length];
            retry--;
          }
        }
      }
    }

    //-----------------------------------------

    var rebuild = false;

    for (var y = 0; y < 10; y++) {
      for (var x = 0; x < 10; x++) {
        rebuild = rebuild || (countLinks(x, y) == 2);
      }
    }

    return rebuild;
  }

  //-------------------------------------------------------------------------------------------------

  bool possibleCombinations() {
    for (var y = 0; y < 10; y++) {
      for (var x = 1; x < 9; x++) {
        if (_fields[(x - 1) + y * 10].couldLink(_fields[x + y * 10]) &&
            _fields[x + y * 10].couldLink(_fields[(x + 1) + y * 10])) {
          return true;
        }
      }
    }

    for (var x = 0; x < 10; x++) {
      for (var y = 1; y < 9; y++) {
        if (_fields[x + (y - 1) * 10].couldLink(_fields[x + y * 10]) &&
            _fields[x + y * 10].couldLink(_fields[x + (y + 1) * 10])) {
          return true;
        }
      }
    }

    return false;
  }

  //-------------------------------------------------------------------------------------------------

  void _initQueuePlaceSpecial(String special, int current, int maximum) {
    for (var retry = 0; retry < 20; retry++) {
      var range = _levelChains ~/ maximum;
      var index = current * range + _random.nextInt(range);

      if (_queue[index].special == Special.None) {
        _queue[index].special = special;
        return;
      }
    }
  }

  void initQueue() {
    _queue = <Field>[];

    for (var i = 0; i < _levelChains; i++) {
      var color = _colors[_random.nextInt(_colors.length)];
      var direction = _random.nextInt(2);

      _queue.add(Field(_resourceManager, _juggler, color, direction));
    }

    for (var i = 0; i < _levelLocks * 2; i++) {
      _initQueuePlaceSpecial(
          'Lock${(i % _levelLocks) + 1}', i, _levelLocks * 2); // Lock1, Lock2, Lock3, ...
    }

    for (var i = 0; i < _levelJokers; i++) {
      _initQueuePlaceSpecial(Special.Joker, i, _levelJokers);
    }

    for (var i = 0; i < _levelBlocks; i++) {
      _initQueuePlaceSpecial(Special.Block, i, _levelBlocks);
    }

    for (var i = 0; i < _levelDoubles; i++) {
      _initQueuePlaceSpecial(Special.Double, i, _levelDoubles);
    }

    for (var i = 0; i < _levelQuints; i++) {
      _initQueuePlaceSpecial(Special.Quint, i, _levelQuints);
    }
  }

  //-------------------------------------------------------------------------------------------------

  void initField() {
    _fields = <Field>[];

    var rebuild = true;

    while (rebuild) {
      _fields.clear();

      for (var f = 0; f < 100; f++) {
        var color = _colors[_random.nextInt(_colors.length)];
        var direction = _random.nextInt(2);
        _fields.add(Field(_resourceManager, _juggler, color, direction));
      }

      rebuild = clearCombinations();
    }
  }

  //-------------------------------------------------------------------------------------------------

  bool shuffleField() {
    if (_animationRunning || _status != BoardStatus.Playing) {
      return false;
    }

    var rebuild = true;

    _animationRunning = true;

    while (rebuild) {
      for (var f = 0; f < _fields.length; f++) {
        var field = _fields[f];
        field.linked = false;
        field.linkedJoker = false;
        field.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);

        field.color = _colors[_random.nextInt(_colors.length)];
        field.direction = _random.nextInt(2);
      }

      rebuild = clearCombinations() || (possibleCombinations() == false);
    }

    _resourceManager.getSound('BonusUniversal').play();

    var completeCounter = ValueCounter();

    for (var x = 0; x < 10; x++) {
      for (var y = 0; y < 10; y++) {
        var field = _fields[x + y * 10];
        field.sinScale = 0.0;

        var translation = Translation(0.0, 1.0, 0.2, Transition.linear);
        translation.delay = x * 0.06;

        translation.onUpdate = (value) {
          field.sinScale = value;
        };

        translation.onStart = () {
          field.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);
        };

        translation.onComplete = () {
          if (completeCounter.increment() == 100) {
            _updateLinks();
            _processCombinations();
            _mouseBuffer.clear();
          }
        };

        _juggler.add(translation);
      }
    }

    return true;
  }

  //-------------------------------------------------------------------------------------------------

  void _updateLinks() {
    for (var y = 0; y < 10; y++) {
      for (var x = 0; x < 10; x++) {
        var field = _fields[x + y * 10];
        var fieldEast = (x < 9) ? _fields[x + 1 + y * 10] : null;
        var fieldSouth = (y < 9) ? _fields[x + (y + 1) * 10] : null;

        var linked = false;
        var linkedJoker = false;

        if (field.canLinkHorizontal(fieldEast)) {
          linked = true;
          linkedJoker = (field.special == Special.Joker || fieldEast.special == Special.Joker);
        }

        if (field.canLinkVertical(fieldSouth)) {
          linked = true;
          linkedJoker = (field.special == Special.Joker || fieldSouth.special == Special.Joker);
        }

        if (field.linked != linked || field.linkedJoker != linkedJoker) {
          field.linked = linked;
          field.linkedJoker = linkedJoker;
          field.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);
        }
      }
    }
  }

  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  void _processCombinationsExplosion(
      ValueCounter animationCounter, int x, int y, int length, int dx, int dy) {
    _animationRunning = true;
    animationCounter.increment(length);

    var factor = 1;

    for (var l = 0; l < length; l++) {
      var field = _fields[x + l * dx + (y + l * dy) * 10];

      if (field.special == Special.Double) factor = factor * 2;
      if (field.special == Special.Quint) factor = factor * 5;

      var px = x + l * dx;
      var py = y + l * dy;

      _juggler.delayCall(() {
        field.empty = true;
        field.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);

        _resourceManager.getSound('ChainBlast').play();

        var explosion = Explosion(_resourceManager, _juggler, field.color, field.direction);
        explosion.x = px * 50;
        explosion.y = py * 50;

        _juggler.add(explosion);
        _explosionLayer.addChild(explosion);

        processSpecial(field);

        //---------------------------------

        if (animationCounter.decrement() == 0) {
          _fillEmptyFields();
        }
      }, 0.1 + l * 0.1);
    }

    dispatchEvent(BoardEvent(BoardEvent.Explosion, {'Length': length, 'Factor': factor}));
  }

  void _processCombinations() {
    _animationRunning = false;
    var animationCounter = ValueCounter();

    //------------------------------------------------------------------------------
    // check horizontal positions

    for (var y = 0; y < 10; y++) {
      for (var x = 0; x < 10;) {
        var length = 1;

        while (x + length < 10 &&
            _fields[x + length - 1 + y * 10].canLinkHorizontal(_fields[x + length + y * 10])) {
          length++;
        }

        if (length >= 3) {
          _processCombinationsExplosion(animationCounter, x, y, length, 1, 0);
        }

        x = x + length;
      }
    }

    //------------------------------------------------------------------------------
    // check vertical positions

    for (var x = 0; x < 10; x++) {
      for (var y = 0; y < 10;) {
        var length = 1;

        while (y + length < 10 &&
            _fields[x + (y + length - 1) * 10].canLinkVertical(_fields[x + (y + length) * 10])) {
          length++;
        }

        if (length >= 3) {
          _processCombinationsExplosion(animationCounter, x, y, length, 0, 1);
        }

        y = y + length;
      }
    }

    //------------------------------------------------------------------------------
    // no explosions and finalizing or timeouting?

    if (animationCounter.value == 0) {
      if (_status == BoardStatus.Finalizing) {
        dispatchEvent(BoardEvent(BoardEvent.Finalized, null));
      }

      if (_status == BoardStatus.Timeouting) {
        dispatchEvent(BoardEvent(BoardEvent.Timeouted, null));
      }

      if (_status == BoardStatus.Playing && possibleCombinations() == false) {
        shuffleField();
      }
    }
  }

  //-------------------------------------------------------------------------------------------------

  void processSpecial(Field field) {
    if (field.special.indexOf('Lock') == 0) {
      var lockNumber = int.parse(field.special.substring(4, 5)) - 1;
      var lock = _locks[lockNumber];

      var special = Grafix.getSpecial(_resourceManager, field.special);
      special.x = field.x;
      special.y = field.y;
      addChild(special);

      var tween = Tween(special, 0.5, Transition.easeOutCubic);
      tween.animate.x.to(lock.x);
      tween.animate.y.to(lock.y - 10);
      tween.onComplete = () => removeChild(special);

      _juggler.add(tween);
      _juggler.delayCall(() => openLock(lockNumber), 0.5);
    }
  }

  //-------------------------------------------------------------------------------------------------

  void openLock(int lockNumber) {
    var lock = _locks[lockNumber];
    BoardEvent boardEvent;

    if (lock.locked) {
      boardEvent = BoardEvent(
          BoardEvent.Unlocked, {'Type': 'SingleLocked', 'Position': Point(lock.x + 20, lock.y)});
      _resourceManager.getSound('Unlock').play();
    } else {
      boardEvent = BoardEvent(
          BoardEvent.Unlocked, {'Type': 'SingleUnlocked', 'Position': Point(lock.x + 20, lock.y)});
    }

    dispatchEvent(boardEvent);

    lock.locked = false;
    lock.showLocked(false);

    //---------------------------------

    var allUnlocked = true;

    for (var i = 0; i < _locks.length; i++) {
      allUnlocked = allUnlocked && (_locks[i].locked == false);
    }

    if (allUnlocked) {
      _resourceManager.getSound('BonusAllUnlock').play();

      for (var i = 0; i < _locks.length; i++) {
        _locks[i].locked = true;
        _juggler.delayCall(() => _locks[(i + lockNumber) % _locks.length].showHappy(), i * 0.2);
      }

      _juggler.delayCall(
          () => dispatchEvent(
              BoardEvent(BoardEvent.Unlocked, {'Type': 'All', 'Position': Point(280, 550)})),
          0.75);
    }
  }

  //-------------------------------------------------------------------------------------------------

  void _fillEmptyFields() {
    var animationCounter = ValueCounter();

    for (var x = 0; x < 10; x++) {
      var target = 9;
      var source = 8;

      while (target >= 0) {
        while (target >= 0 && _fields[x + target * 10].empty == false) {
          target--;
          source--;
        }

        while (source >= 0 && _fields[x + source * 10].empty == true) {
          source--;
        }

        if (target >= 0) {
          Field fieldTarget, fieldSource, fieldSourceWest;

          if (source >= 0) {
            fieldSource = _fields[x + source * 10];

            if (x > 0) {
              fieldSourceWest = _fields[x - 1 + source * 10];

              if (fieldSource.canLinkHorizontal(fieldSourceWest)) {
                fieldSourceWest.linked = false;
                fieldSourceWest.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);
              }
            }

            fieldSource.linked = false;
            fieldSource.empty = true;
            fieldSource.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);
          } else {
            if (_queue.isNotEmpty) {
              fieldSource = _queue.removeAt(0);
            } else {
              var color = _colors[_random.nextInt(_colors.length)];
              var direction = _random.nextInt(2);
              fieldSource = Field(_resourceManager, _juggler, color, direction);
            }
          }

          fieldTarget = _fields[x + target * 10];
          fieldTarget.color = fieldSource.color;
          fieldTarget.direction = fieldSource.direction;
          fieldTarget.special = fieldSource.special;
          fieldTarget.linked = false;
          fieldTarget.empty = false;
          fieldTarget.x = 50 * x + 25;
          fieldTarget.y = 50 * source + 25;
          fieldTarget.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);

          animationCounter.increment();

          var transition = Transition.linear;
          var translation = Translation(fieldTarget.y, 50 * target + 25, 0.1, transition);

          translation.onUpdate = (value) {
            fieldTarget.y = value;
          };

          translation.onComplete = () {
            if (animationCounter.decrement() == 0) {
              _updateLinks();
              _processCombinations();
              _checkMouseBuffer();
            }
          };

          _juggler.add(translation);
        }
      }
    }
  }

  //-------------------------------------------------------------------------------------------------
  //-------------------------------------------------------------------------------------------------

  void _onMouseDown(MouseEvent me) {
    if (me.target == _chainLayer && mouseEnabled) {
      var x = math.min(me.localX / 50, 9).toInt();
      var y = math.min(me.localY / 50, 9).toInt();

      var p = Point(x, y);

      _mouseBuffer.add(p);
      _checkMouseBuffer();
    }
  }

  void _checkMouseBuffer() {
    while (
        _status == BoardStatus.Playing && _animationRunning == false && _mouseBuffer.isNotEmpty) {
      var p = _mouseBuffer.removeAt(0);

      var x = p.x.toInt();
      var y = p.y.toInt();

      var field = _fields[x + y * 10];
      var fieldWest = (x > 0) ? _fields[x - 1 + y * 10] : null;
      var fieldEast = (x < 9) ? _fields[x + 1 + y * 10] : null;
      var fieldNorth = (y > 0) ? _fields[x + (y - 1) * 10] : null;
      var fieldSouth = (y < 9) ? _fields[x + (y + 1) * 10] : null;

      var playChainLink = false;

      if (field.special == Special.Block) {
        _resourceManager.getSound('ChainError').play();
        continue;
      }

      //--------------------------------------------
      // update links on North and West field

      if (field.canLinkVertical(fieldNorth)) {
        fieldNorth.linked = false;
        fieldNorth.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);
      }

      if (field.canLinkHorizontal(fieldWest)) {
        fieldWest.linked = false;
        fieldWest.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);
      }

      //--------------------------------------------
      // rotate and update links on field

      field.direction = 1 - field.direction;
      field.linked = false;
      field.linkedJoker = false;

      _resourceManager.getSound('ChainRotate').play();

      if (field.canLinkHorizontal(fieldEast)) {
        field.linked = true;
        field.linkedJoker = (field.special == Special.Joker || fieldEast.special == Special.Joker);
      }

      if (field.canLinkVertical(fieldSouth)) {
        field.linked = true;
        field.linkedJoker = (field.special == Special.Joker || fieldSouth.special == Special.Joker);
      }

      field.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);

      playChainLink = playChainLink || field.linked;

      //--------------------------------------------
      // update links on North and West field

      if (field.canLinkVertical(fieldNorth)) {
        fieldNorth.linked = true;
        fieldNorth.linkedJoker =
            (field.special == Special.Joker || fieldNorth.special == Special.Joker);
        fieldNorth.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);
        playChainLink = true;
      }

      if (field.canLinkHorizontal(fieldWest)) {
        fieldWest.linked = true;
        fieldWest.linkedJoker =
            (field.special == Special.Joker || fieldWest.special == Special.Joker);
        fieldWest.updateDisplayObjects(_chainLayer, _linkLayer, _specialLayer);
        playChainLink = true;
      }

      //--------------------------------------------

      if (playChainLink) {
        _resourceManager.getSound('ChainLink').play();
      }

      //--------------------------------------------

      _processCombinations();
    }
  }
}
