part of escape;

class ExitBox extends Sprite {
  TimeGauge _timeGauge;
  SimpleButton _yesButton;
  SimpleButton _noButton;

  Function _doneFunction;

  ExitBox(ResourceManager resourceManager, Juggler juggler) {
    var background = Bitmap(resourceManager.getBitmapData('ExitBox'));
    addChild(background);

    var textField = TextField();
    textField.defaultTextFormat =
        TextFormat('Arial', 24, 0xFFFFFF, bold: true, align: TextFormatAlign.CENTER);
    textField.width = 240;
    textField.height = 100;
    textField.wordWrap = true;
    //textField.selectable = false;
    textField.text = resourceManager.getText('GENexitquery');
    textField.x = 47;
    textField.y = 150 - textField.textHeight / 2;
    //textField.filters = [GlowFilter(0x000000, 0.7, 3, 3)];    // ToDo
    textField.mouseEnabled = false;

    addChild(textField);

    //---------------------

    _timeGauge = TimeGauge(7, resourceManager.getBitmapData('ExitGauge'), Gauge.DIRECTION_DOWN);
    _timeGauge.x = 268;
    _timeGauge.y = 25;
    _timeGauge.addEventListener('TimeOver', _onTimeOver);
    addChild(_timeGauge);

    _timeGauge.addAlarm('TimeOver', 0);
    _timeGauge.start();

    var exitYesButtonNormal = Bitmap(resourceManager.getBitmapData('ExitYesButtonNormal'));
    var exitYesButtonPressed = Bitmap(resourceManager.getBitmapData('ExitYesButtonPressed'));

    _yesButton = SimpleButton(
        exitYesButtonNormal, exitYesButtonNormal, exitYesButtonPressed, exitYesButtonPressed);
    _yesButton.x = 68;
    _yesButton.y = 239;
    _yesButton.addEventListener(MouseEvent.CLICK, _onYesButtonClicked);
    addChild(_yesButton);

    var exitNoButtonNormal = Bitmap(resourceManager.getBitmapData('ExitNoButtonNormal'));
    var exitNoButtonPressed = Bitmap(resourceManager.getBitmapData('ExitNoButtonPressed'));

    _noButton = SimpleButton(
        exitNoButtonNormal, exitNoButtonNormal, exitNoButtonPressed, exitNoButtonPressed);
    _noButton.x = 173;
    _noButton.y = 232;
    _noButton.addEventListener(MouseEvent.CLICK, _onNoButtonClicked);

    addChild(_noButton);

    //---------------------

    addEventListener(Event.ADDED_TO_STAGE, (e) => juggler.add(_timeGauge));
    addEventListener(Event.REMOVED_FROM_STAGE, (e) => juggler.remove(_timeGauge));
  }

  //-----------------------------------------------------------------------------------

  void _onExit(bool exit) {
    if (_doneFunction != null) {
      _doneFunction(exit);
      _doneFunction = null;
    }
  }

  //-----------------------------------------------------------------------------------

  void _onYesButtonClicked(MouseEvent me) {
    _onExit(true);
  }

  void _onNoButtonClicked(MouseEvent me) {
    _onExit(false);
  }

  void _onTimeOver(Event e) {
    _onExit(false);
  }

  //-----------------------------------------------------------------------------------

  void show(Function doneFunction) {
    _doneFunction = doneFunction;
  }
}
