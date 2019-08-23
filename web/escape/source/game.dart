part of escape;

class Game extends Sprite {

  ResourceManager _resourceManager;
  Juggler _juggler;

  InfoBox _infoBox;
  SimpleButton _shuffleButton;
  SimpleButton _exitButton;
  Board _board;
  TimeGauge _timeGauge;
  Head _head;
  Alarm _alarm;
  TextField _pointsTextField;
  TextField _shufflesTextField;

  int _level;
  int _lives;
  int _shuffles;
  int _chainCount;
  int _points;

  Sprite _gameLayer;
  Sprite _messageLayer;
  Sprite _exitLayer;

  Sound _introSound;
  SoundChannel _introSoundChannel;

  //---------------------------------------------------------------------------------------------------

  Game(ResourceManager resourceManager, Juggler juggler) {

    _resourceManager = resourceManager;
    _juggler = juggler;

    Bitmap shuffleButtonNormal = Bitmap(_resourceManager.getBitmapData("ShuffleButtonNormal"));
    Bitmap shuffleButtonPressed = Bitmap(_resourceManager.getBitmapData("ShuffleButtonPressed"));

    _shuffleButton = SimpleButton(shuffleButtonNormal, shuffleButtonNormal, shuffleButtonPressed, shuffleButtonPressed);
    _shuffleButton.addEventListener(MouseEvent.CLICK, _onShuffleButtonClick);
    _shuffleButton.x = 530;
    _shuffleButton.y = 525;
    addChild(_shuffleButton);

    Bitmap exitButtonNormal = Bitmap(_resourceManager.getBitmapData("ExitButtonNormal"));
    Bitmap exitButtonPressed = Bitmap(_resourceManager.getBitmapData("ExitButtonPressed"));

    _exitButton = SimpleButton(exitButtonNormal, exitButtonNormal, exitButtonPressed, exitButtonPressed);
    _exitButton.addEventListener(MouseEvent.CLICK, _onExitButtonClick);
    _exitButton.x = 700;
    _exitButton.y = 500;
    addChild(_exitButton);

    _infoBox = InfoBox(_resourceManager, _juggler);
    _infoBox.x = 540;
    _infoBox.y = -1000;
    addChild(_infoBox);

    _timeGauge = TimeGauge(10, _resourceManager.getBitmapData("TimeGauge"), Gauge.DIRECTION_UP);
    _timeGauge.x = 659;
    _timeGauge.y = 244;
    _timeGauge.addEventListener("TimeShort", _onTimeShort);
    _timeGauge.addEventListener("TimeOver", _onTimeOver);
    addChild(_timeGauge);
    _juggler.add(_timeGauge);

    _head = Head(_resourceManager, _juggler);
    _head.x = 640;
    _head.y = 230;
    addChild(_head);

    _alarm = Alarm(_resourceManager, _juggler);
    _alarm.x = 665;
    _alarm.y = 160;
    addChild(_alarm);

    //-------------------------------

    _pointsTextField = TextField();
    _pointsTextField.defaultTextFormat = TextFormat("Arial", 30, 0xD0D0D0, bold:true, align:TextFormatAlign.CENTER);
    _pointsTextField.width = 140;
    _pointsTextField.height = 36;
    _pointsTextField.wordWrap = false;
    //_pointsTextField.selectable = false;
    _pointsTextField.x = 646;
    _pointsTextField.y = 130;
    //_pointsTextField.filters = [GlowFilter(0x000000, 1.0, 2, 2)];
    _pointsTextField.mouseEnabled = false;
    _pointsTextField.text = "0";
    _pointsTextField.scaleX = 0.9;
    addChild(_pointsTextField);

    //-------------------------------

    _shufflesTextField = TextField();
    _shufflesTextField.defaultTextFormat = TextFormat("Arial", 20, 0xFFFFFF, bold:true, align:TextFormatAlign.CENTER);
    _shufflesTextField.width = 44;
    _shufflesTextField.height = 30;
    _shufflesTextField.wordWrap = false;
    //_shufflesTextField.selectable = false;
    _shufflesTextField.x = 610;
    _shufflesTextField.y = 559;
    _shufflesTextField.mouseEnabled = false;
    _shufflesTextField.text = "3x";
    addChild(_shufflesTextField);

    //-------------------------------

    _gameLayer = Sprite();
    addChild(_gameLayer);

    _messageLayer = Sprite();
    addChild(_messageLayer);

    _exitLayer = Sprite();
    addChild(_exitLayer);

    //-------------------------------

    _introSound = _resourceManager.getSound("Intro");
    _introSoundChannel = _introSound.play();
  }

  //---------------------------------------------------------------------------------------------------
  //---------------------------------------------------------------------------------------------------

  void start() {

    _level = 1;
    _lives = 1;
    _points = 0;
    _shuffles = 3;

    MessageBox messageBox  = MessageBox(_resourceManager, _juggler, _resourceManager.getText("ESCStartText"));
    _messageLayer.addChild(messageBox);

    _juggler.delayCall(() => _head.nod(21), 1);

    messageBox.show(() => _juggler.delayCall(() => _nextLevel(), 0.5));
  }

  //---------------------------------------------------------------------------------------------------

  void _nextLevel() {

    if (_board != null && this.contains(_board)) {
      _gameLayer.removeChild(_board);
    }

    int level = _level;
    int chainCount = 0;
    num time = 0;

    switch(_level) {
      case 01: time = 50; _board = Board(_resourceManager, _juggler, chainCount = 40, 3, 0, 0, 0, 0, [0,1,2]); break;
      case 02: time = 45; _board = Board(_resourceManager, _juggler, chainCount = 45, 3, 1, 0, 0, 0, [2,3,4]); break;
      case 03: time = 40; _board = Board(_resourceManager, _juggler, chainCount = 50, 4, 2, 2, 1, 0, [5,6,7]); break;
      case 04: time = 35; _board = Board(_resourceManager, _juggler, chainCount = 55, 4, 3, 3, 2, 0, [0,2,6]); break;
      case 05: time = 30; _board = Board(_resourceManager, _juggler, chainCount = 60, 5, 4, 4, 2, 1, [1,3,5]); break;
      case 06: time = 34; _board = Board(_resourceManager, _juggler, chainCount = 60, 5, 5, 5, 3, 2, [1,2,4,7]); break;
      case 07: time = 33; _board = Board(_resourceManager, _juggler, chainCount = 65, 5, 5, 6, 3, 2, [0,1,2,3]); break;
      case 08: time = 32; _board = Board(_resourceManager, _juggler, chainCount = 70, 5, 5, 6, 3, 2, [0,2,5,6]); break;
      case 09: time = 31; _board = Board(_resourceManager, _juggler, chainCount = 75, 5, 5, 6, 3, 2, [1,4,5,7]); break;
      default: time = 30; _board = Board(_resourceManager, _juggler, chainCount = 80 + (_level - 10) * 5, 5, 5, 6, 3, 2, [0,1,2,3]); break;
    }

    _chainCount = chainCount;
    //_logger.info(TextUtil.format("Level: {0}, Time: {1}, Chains: {2}", level, time, chainCount));

    if (_shuffles < 3) {
      _shuffles++;
      _shufflesTextField.text = "${_shuffles}x";
    }

    _board.addEventListener(BoardEvent.Explosion, _onBoardEventExplosion);
    _board.addEventListener(BoardEvent.Unlocked, _onBoardEventUnlocked);
    _board.addEventListener(BoardEvent.Finalized, _onBoardEventFinalized);
    _board.addEventListener(BoardEvent.Timeouted, _onBoardEventTimeouted);

    _board.x = 20;
    _board.y = 16;
    _board.mouseEnabled = false;

    _gameLayer.addChild(_board );

    _timeGauge.reset(time);
    _timeGauge.addAlarm("TimeShort", 9);
    _timeGauge.addAlarm("TimeOver", 0);
    _timeGauge.pause();

    _infoBox.level = level;
    _infoBox.chains = chainCount;
    _infoBox.y = -210;

    Tween tween = Tween(_infoBox, 0.4, Transition.easeOutCubic);
    tween.animate.y.to(-90);

    _juggler.add(tween);

    MessageBox messageBox = MessageBox(_resourceManager, _juggler,
        _resourceManager.getText("ESCLevelBoxText").replaceAll("{0}", "$chainCount"));

    _messageLayer.addChild(messageBox);

    messageBox.show(() {

      _board.mouseEnabled = true;
      _timeGauge.start();

      if (_introSound != null)
      {
        Translation translation = Translation(1.0, 0.0, 4.0, Transition.linear);

        translation.onUpdate = (volume) {
          _introSoundChannel.soundTransform.volume = volume;
          _introSoundChannel.soundTransform = _introSoundChannel.soundTransform;
        };

        translation.onComplete = () {
          _introSoundChannel.stop();
          _head.nodStop();
        };

        _juggler.add(translation);
        _introSound = null;
      }
    });
  }

  //---------------------------------------------------------------------------------------------------
  //---------------------------------------------------------------------------------------------------

  void _onTimeShort(Event e) {
    //_logger.info("onTimeShort");
    _alarm.start();
  }

  //---------------------------------------------------------------------------------------------------

  void _onTimeOver(Event e) {
    // _logger.info("onTimeOver");
    _board.updateStatus(BoardStatus.Timeouting);
  }

  //---------------------------------------------------------------------------------------------------

  void _onBoardEventUnlocked(BoardEvent be) {
    // _logger.info(TextUtil.format("onBoardEventUnlocked ({0})", be.info.type));

    int unlockPoints = 0;
    Point position = be.info["Position"];
    String type = be.info["Type"];

    if (type == "SingleLocked") unlockPoints = 3000;
    if (type == "SingleUnlocked") unlockPoints = 1000;
    if (type == "All") unlockPoints = 10000;

    Bonus bonus = Bonus(_resourceManager, _juggler, unlockPoints);
    bonus.x = position.x;
    bonus.y = position.y;
    _gameLayer.addChild(bonus);

    _points = _points + unlockPoints;

    _pointsTextField.text = "$_points";
  }

  //---------------------------------------------------------------------------------------------------

  void _onBoardEventExplosion(BoardEvent be) {
    //_logger.info("onBoardEventExplosion");

    int chainCount = _chainCount;
    int chainLength = be.info["Length"];
    int chainFactor = be.info["Factor"];

    chainCount = (chainCount > chainLength) ? chainCount - chainLength : 0;

    _chainCount = chainCount;
    _infoBox.chains = chainCount;

    if (chainCount == 0) {
      _board.updateStatus(BoardStatus.Finalizing);
    }

    //----------------------------------

    int chainPoints = 0;

    switch(chainLength) {
      case 3: chainPoints = 1000; break;
      case 4: chainPoints = 2000; break;
      case 5: chainPoints = 5000; break;
      default: chainPoints = 5000; break;
    }

    _points = _points + chainPoints * chainFactor;
    _pointsTextField.text = "$_points";
  }

  //---------------------------------------------------------------------------------------------------

  void _onBoardEventFinalized(BoardEvent be) {
   //_logger.info("onBoardEventFinalized");

    _timeGauge.pause();
    _alarm.stop();

    Sound laugh = _resourceManager.getSound("Laugh");
    Sound levelUp = _resourceManager.getSound("LevelUp");

    laugh.play();
    _head.nod(3);

    Sprite levelUpAnimation = Grafix.getLevelUpAnimation(_resourceManager, _juggler);
    levelUpAnimation.x = 55;
    levelUpAnimation.y = 260;
    _gameLayer.addChild(levelUpAnimation);

    _juggler.delayCall(() {
      _board.dropFields();
      levelUp.play();
    }, 2.0);

    _juggler.delayCall(() {
      int timePoints = (_timeGauge.restTime * 1000).toInt();
      Bonus timeBonus = Bonus(_resourceManager, _juggler, timePoints);
      timeBonus.x = 704;
      timeBonus.y = 360;
      _gameLayer.addChild(timeBonus);

      _points = _points + timePoints;
      _pointsTextField.text = "$_points";
    }, 2.5);

    Tween tween = Tween(_infoBox, 0.5, Transition.easeOutCubic);
    tween.animate.y.to(-210);
    tween.delay = 3.0;

    _juggler.add(tween);

    _juggler.delayCall(() {
      _gameLayer.removeChild(levelUpAnimation);
    }, 3.5);

    _juggler.delayCall(() {
      _level++;
      _nextLevel();
    }, 4.0);
  }

  //---------------------------------------------------------------------------------------------------

  void _onBoardEventTimeouted(BoardEvent be) {

    _alarm.stop();
    _board.dropFields();

    MessageBox messageBox;

    if (_lives > 0) {

      //_logger.info("onBoardEventTimeouted (SecondChance)");

      _lives--;

      messageBox = MessageBox(_resourceManager, _juggler, _resourceManager.getText("GEN2ndchancetime"));
      _messageLayer.addChild(messageBox);
      _resourceManager.getSound("LevelUp").play();

      messageBox.show(() {

        _juggler.delayCall(() => _nextLevel(), 0.5);

        Tween tween = Tween(_infoBox, 0.5, Transition.easeOutCubic);
        tween.animate.y.to(-210);

        _juggler.add(tween);
      });

    } else {

      // _logger.info("onBoardEventTimeouted (GameOver)");

      messageBox = MessageBox(_resourceManager, _juggler, _resourceManager.getText("GENtimeup"));
      _messageLayer.addChild(messageBox);
      _resourceManager.getSound("GameOver").play();

      messageBox.show(() {

        _juggler.delayCall(() => _gameOver(), 0.5);

        Tween tween = Tween(_infoBox, 0.5, Transition.easeOutCubic);
        tween.animate.y.to(-210);

        _juggler.add(tween);
      });
    }
  }

  //---------------------------------------------------------------------------------------------------
  //---------------------------------------------------------------------------------------------------

  void _onShuffleButtonClick(MouseEvent me) {
   //  _logger.info("onShuffleButtonClick");

    if (_board != null && _shuffles > 0) {

      bool shuffled = _board.shuffleField();

      if (shuffled) {
        //_logger.info("shuffled");

        _shuffles = _shuffles - 1;
        _shufflesTextField.text = "${_shuffles}x";
      }
    }
  }

  void _onExitButtonClick(MouseEvent me) {
    //_logger.info("onExitButtonClick");

    Sprite dark = Sprite();
    dark.addChild(Bitmap(BitmapData(800, 600, Color.Black)));
    dark.alpha = 0.6;

    _exitLayer.addChild(dark);

    ExitBox exitBox = ExitBox(_resourceManager, _juggler);
    exitBox.x = 235;
    exitBox.y = 150;
    _exitLayer.addChild(exitBox);

    exitBox.show((bool exit) {
      _exitLayer.removeChild(exitBox);

      if (exit == false) {
        _exitLayer.removeChild(dark);
      } else {
        _exitGame(false);
      }
    });
  }

  //---------------------------------------------------------------------------------------------------
  //---------------------------------------------------------------------------------------------------

  void _gameOver() {

    Sprite gameOverBox = Sprite();

    Bitmap background = Bitmap(_resourceManager.getBitmapData("ExitBox"));
    gameOverBox.addChild(background);

    TextField textField = TextField();
    textField.defaultTextFormat = TextFormat("Arial", 30, 0xFFFFFF, bold:true, align:TextFormatAlign.CENTER);
    textField.width = 240;
    textField.height = 200;
    textField.wordWrap = true;
    //textField.selectable = false;
    textField.text = _resourceManager.getText("GENgameover");
    textField.x = 47;
    textField.y = 30 + (textField.height - textField.textHeight)/2;
    //textField.filters = [GlowFilter(0x000000, 0.7, 3, 3)];
    textField.mouseEnabled = false;
    gameOverBox.addChild(textField);

    gameOverBox.x = 110;
    gameOverBox.y = -gameOverBox.height;

    _messageLayer.addChild(gameOverBox);
    _juggler.delayCall(() => _resourceManager.getSound("Laugh").play(), 0.3);

    Tween tween = Tween(gameOverBox, 0.3, Transition.easeOutCubic);
    tween.animate.y.to(150);

    _juggler.add(tween);

    //----------------------------------------------

    _juggler.delayCall(() => _exitGame(true), 5.0);

    gameOverBox.addEventListener(MouseEvent.CLICK, (MouseEvent me) => _exitGame(true));
  }

  //---------------------------------------------------------------------------------------------------

  bool _exitCalled = false;

  void _exitGame(bool gameEnded) {
    _timeGauge.pause();

    if (_exitCalled == false) {
      _exitCalled = true;
      //  GameApi.instance.exit(_points.intValue, gameEnded);
    }
  }

}
