part of supersonic;

class MissileGame extends Game {
  static const String GAME_NAME = 'Missile';
  static const num STD_VOLUME = 1.0;
  static const num STD_SCORE_PER_BARRIER = 100;
  static const int STD_BG_COLOR = 0xFFFFFF;

  num soundVolume = STD_VOLUME;
  int freeLives = 5;

  MissileGameEngine engine;
  bool isInitialized = false;

  num scorePerBarrier = 500;
  int bgColor = 0xffffff;

  SimpleButton exitButton;
  Menu currentMenu;

  TopMenu inGameMenu;

  bool _trainingsMode = true;
  bool mouseIsDown = false;

  num gameTimeOut = 60.0;
  DelayedCall gameTimeOutCall;

  String fontName = defaultFont;
  bool hasScreenReleaseHint = false;
  String platformType = 'Web';

  //-----------------------------------------------------------------------------------------------

  MissileGame(int gameWidth, int gameHeight) : super(gameWidth, gameHeight) {
    addEventListener(Event.ADDED_TO_STAGE, (e) {
      init();
    });
  }

  set trainingsMode(bool value) {
    _trainingsMode = value;
    dispatchEvent(
        GameEvent(GameEvent.TYPE_LIVES_CHANGED, this)); // forces ingame menu to update
  }

  bool get trainingsMode => _trainingsMode;

  void init() {
    if (!isInitialized) {
      addEventListener(MouseEvent.MOUSE_UP, (e) => mouseIsDown = false);
      addEventListener(MouseEvent.MOUSE_DOWN, (e) => mouseIsDown = true);

      readConfigParams();

      // init game eventlisteners

      addEventListener(GameEvent.TYPE_GAME_START, onGameStart);
      addEventListener(GameEvent.TYPE_LIVES_CHANGED, onLivesChange);
      addEventListener(GameEvent.TYPE_PROGRESS_CHANGED, onProgressChange);
      addEventListener(GameEvent.TYPE_SCORE_CHANGED, onScoreChange);
      addEventListener(GameEvent.TYPE_LEVEL_CHANGED, onLevelChange);
      addEventListener(GameEvent.TYPE_PAUSE_CHANGED, onPauseChange);
      addEventListener(GameEvent.TYPE_GAME_OVER, onGameOver);
      addEventListener(GameEvent.TYPE_GAME_ABORT, onGameAbort);

      // create children

      createChildren();

      progress = 0;
      score = 0;
      lives = 3;
      start();

      isInitialized = true;
    }
  }

  String getResource(String key, [List params]) {
    var value = resourceManager.getText(key);

    if (params != null) {
      for (var i = 0; i < params.length; i++) {
        value = value.replaceAll('{$i}', params[i].toString());
      }
    }

    return value;
  }

  void readConfigParams() {
    soundVolume = STD_VOLUME;
    bgColor = STD_BG_COLOR;
    scorePerBarrier = STD_SCORE_PER_BARRIER;
    freeLives = 5;
    gameTimeOut = 60000;
  }

  void createChildren() {
    // create engine
    engine = MissileGameEngine(this);
    addChild(engine);

    // create exit button
    var buttonExit = resourceManager.getTextureAtlas('items').getBitmapData('button_exit');
    var buttonExit2 = resourceManager.getTextureAtlas('items').getBitmapData('button_exit_2');

    exitButton = SimpleButton(Bitmap(buttonExit), Bitmap(buttonExit2), Bitmap(buttonExit), Bitmap(buttonExit2));
    exitButton.width = 75;
    exitButton.height = 66;
    exitButton.x = 707; //this.gameWidth - this.exitButton.width;
    exitButton.y = 525; //this.gameHeight - this.exitButton.height;
    exitButton.addEventListener(MouseEvent.MOUSE_DOWN, onExitButtonClick);
    addChild(exitButton);
    exitButton.visible = false;

    // create IngameMenu
    inGameMenu = TopMenu(this, fontName);
    inGameMenu.x = 0;
    inGameMenu.y = 0;
    addChild(inGameMenu);
  }

  // menu
  // start restart level menu

  void createRestartLevelMenu() {
    var menu = createMenu();
    menu.text = getResource('MESSAGE_RESTART_LEVEL'); //"Ooops!\nGet Ready\nFor Restart!"
    menu.addEventListener(MenuEvent.TYPE_OK, onRestartLevelMenuOk);
  }

  void createFreeLevelMenu(int testObjectId) {
    var menu = createMenu();
    menu.text = getResource('MESSAGE_FREE_LEVEL_BARRIER_$testObjectId');
    menu.addEventListener(MenuEvent.TYPE_OK, onRestartLevelMenuOk);
  }

  void onRestartLevelMenuOk(MenuEvent event) {
    removeMenu(event.menu);
    engine.continueLevel();
  }

  // start start level menu

  void createStartLevelMenu() {
    engine.flow();
    var menu = createMenu();

    if (level == 0) {
      menu.text = getResource('MESSAGE_FIRST_LEVEL_WEB');
    } else {
      menu.text = getResource('MESSAGE_START_LEVEL', [(level + 1)]); 
    }

    menu.addEventListener(MenuEvent.TYPE_OK, onStartLevelMenuOk);
  }

  void onStartLevelMenuOk(MenuEvent event) {
    removeMenu(event.menu);
    nextLevel();
  }

  // create gameover menu

  void createGameOverMenu() {
    var menu = createMenu();
    menu.text = getResource('MESSAGE_GAME_OVER'); //"Game\nOver";
    menu.addEventListener(MenuEvent.TYPE_OK, onGameOverMenuOk);
  }

  void onGameOverMenuOk(MenuEvent event) {
    removeMenu(event.menu);
  }

  Menu createMenu([Menu menu, num tweenDuration = 1.0, bool autoStart = true]) {
    if (currentMenu != null) removeMenu(currentMenu);

    exitButton.visible = false;
    inGameMenu.visible = true;

    if (menu == null) {
      currentMenu = Menu(this, autoStart, fontName);
    } else {
      currentMenu = menu;
    }

    currentMenu.width = Menu.menuWidth;
    currentMenu.height = Menu.menuHeight;
    currentMenu.x = (gameWidth / 2) - (Menu.menuWidth / 2) + 30;
    currentMenu.y = (gameHeight / 2) - (Menu.menuHeight / 2);
    currentMenu.alpha = 0;

    addChild(currentMenu);

    var tween = Tween(currentMenu, tweenDuration, Transition.linear);
    tween.animate.alpha.to(1);
    renderJuggler.add(tween);

    return currentMenu;
  }

  void removeMenu(Menu menu) {
    paused = false;
    inGameMenu.visible = true;
    exitButton.visible = true;

    if (menu == null) return;
    menu.destroy();

    if (contains(menu)) {
      removeChild(menu);
    }

    currentMenu = null;
  }

  //-----------------------------------------------------------------------------------------------

  // Event Handlers

  void gameTimeOutFunc() {
    renderJuggler.remove(gameTimeOutCall);

    if (hasScreenReleaseHint) onScreenReleaseMessageOk(null);

    mouseIsDown = true;
    trainingsMode = false;
  }

  //-----------------------------------------------------------------------------------------------

  void onScreenRelease() {
    if (currentMenu != null) return;
    if (platformType.toLowerCase() == 'web') return;

    renderJuggler.remove(gameTimeOutCall);

    gameTimeOutCall = DelayedCall(gameTimeOutFunc, gameTimeOut);
    renderJuggler.add(gameTimeOutCall);

    hasScreenReleaseHint = true;
    paused = true;
    var screenReleaseMenu = createMenu(null, 200, false);

    exitButton.visible = true;

    screenReleaseMenu.text = getResource('MESSAGE_FIRST_LEVEL');
    screenReleaseMenu.addEventListener(MenuEvent.TYPE_OK, onScreenReleaseMessageOk);
  }

  void onScreenReleaseMessageOk(MenuEvent event) {
    renderJuggler.remove(gameTimeOutCall);

    hasScreenReleaseHint = false;
    currentMenu.removeEventListeners(MenuEvent.TYPE_OK);
    removeMenu(currentMenu);
  }

  //-----------------------------------------------------------------------------------------------

  void onExitButtonClick(MouseEvent event) {
    if (currentMenu is AbortGameMenu) return;

    var abortGameMenu = AbortGameMenu(this, fontName);

    createMenu(abortGameMenu);
    paused = true;

    abortGameMenu.addEventListener(MenuEvent.TYPE_OK, onAbortGameMenuOK);
    abortGameMenu.addEventListener(MenuEvent.TYPE_CANCEL, onAbortGameMenuCancel);
  }

  void onAbortGameMenuOK(MenuEvent event) {
    dispatchEvent(GameEvent(GameEvent.TYPE_GAME_ABORT, this));

    currentMenu.removeEventListeners(MenuEvent.TYPE_OK);
    currentMenu.removeEventListeners(MenuEvent.TYPE_CANCEL);

    removeMenu(currentMenu);
    paused = true;
  }

  void onAbortGameMenuCancel(MenuEvent event) {
    currentMenu.removeEventListeners(MenuEvent.TYPE_OK);
    currentMenu.removeEventListeners(MenuEvent.TYPE_CANCEL);

    removeMenu(currentMenu);
  }

//-----------------------------------------------------------------------------------------------

  void onGameStart(GameEvent event) {
    engine.flow();
    renderJuggler.delayCall(createStartLevelMenu, 0.5);
  }

  void flowEngine() {
    engine.flow();
  }

  void onProgressChange(GameEvent event) {}

  void onLivesChange(GameEvent event) {}

  void onScoreChange(GameEvent event) {}

  void onLevelChange(GameEvent event) {}

  void onPauseChange(GameEvent event) {}

  void onGameOver(GameEvent event) {
    renderJuggler.delayCall(createGameOverMenu, 2.0);
  }

  void onGameAbort(GameEvent event) {}
}
