part of supersonic;

class MissileGame extends Game {

  static const String GAME_NAME = "Missile";
  static const num STD_VOLUME = 1.0;
  static const num STD_SCORE_PER_BARRIER  = 100;
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
  String platformType = "Web";

  //-----------------------------------------------------------------------------------------------

  MissileGame(int gameWidth, int gameHeight):super(gameWidth, gameHeight) {

    this.addEventListener(Event.ADDED_TO_STAGE, (e) {
      this.init();
    });
  }

  set trainingsMode(bool value) {
    _trainingsMode = value;
    this.dispatchEvent(new GameEvent(GameEvent.TYPE_LIVES_CHANGED, this )); // forces ingame menu to update
  }

  bool get trainingsMode => _trainingsMode;

  void init() {

    if (!isInitialized) {

      this.addEventListener(MouseEvent.MOUSE_UP, (e) => this.mouseIsDown = false);
      this.addEventListener(MouseEvent.MOUSE_DOWN, (e) => this.mouseIsDown = true);

      this.readConfigParams();

      // init game eventlisteners

      this.addEventListener(GameEvent.TYPE_GAME_START, this.onGameStart);
      this.addEventListener(GameEvent.TYPE_LIVES_CHANGED, this.onLivesChange);
      this.addEventListener(GameEvent.TYPE_PROGRESS_CHANGED, this.onProgressChange);
      this.addEventListener(GameEvent.TYPE_SCORE_CHANGED, this.onScoreChange);
      this.addEventListener(GameEvent.TYPE_LEVEL_CHANGED, this.onLevelChange);
      this.addEventListener(GameEvent.TYPE_PAUSE_CHANGED, this.onPauseChange);
      this.addEventListener(GameEvent.TYPE_GAME_OVER, this.onGameOver);
      this.addEventListener(GameEvent.TYPE_GAME_ABORT, this.onGameAbort);

      // create children

      this.createChildren();

      this.progress = 0;
      this.score = 0;
      this.lives = 3;
      this.start();

      isInitialized = true;
    }
  }

  String getResource( String key, [List params = null]) {

    var value = resourceManager.getText(key);

    if (params != null) {
      for(int i = 0; i < params.length; i++) {
        value = value.replaceAll("{$i}", params[i].toString());
      }
    }

    return value;
  }

  void readConfigParams() {
    this.soundVolume = STD_VOLUME;
    this.bgColor = STD_BG_COLOR;
    this.scorePerBarrier = STD_SCORE_PER_BARRIER;
    this.freeLives = 5;
    this.gameTimeOut = 60000;
  }

  void createChildren() {

    // create engine
    this.engine = new MissileGameEngine( this );
    this.addChild(this.engine);

    // create exit button
    BitmapData buttonExit = resourceManager.getTextureAtlas("items").getBitmapData("button_exit");
    BitmapData buttonExit2 = resourceManager.getTextureAtlas("items").getBitmapData("button_exit_2");

    this.exitButton = new SimpleButton(new Bitmap(buttonExit), new Bitmap(buttonExit2), new Bitmap(buttonExit), new Bitmap(buttonExit2));
    this.exitButton.width = 75;
    this.exitButton.height = 66;
    this.exitButton.x = 707;//this.gameWidth - this.exitButton.width;
    this.exitButton.y = 525; //this.gameHeight - this.exitButton.height;
    this.exitButton.addEventListener(MouseEvent.MOUSE_DOWN, onExitButtonClick);
    this.addChild(this.exitButton);
    this.exitButton.visible = false;

    // create IngameMenu
    this.inGameMenu = new TopMenu( this, fontName );
    this.inGameMenu.x = 0;
    this.inGameMenu.y = 0;
    this.addChild( this.inGameMenu );
  }

  // menu
  // start restart level menu

  void createRestartLevelMenu() {
    var menu = this.createMenu();
    menu.text = this.getResource("MESSAGE_RESTART_LEVEL"); //"Ooops!\nGet Ready\nFor Restart!"
    menu.addEventListener( MenuEvent.TYPE_OK, this.onRestartLevelMenuOk);
  }

  void createFreeLevelMenu(int testObjectId) {
    var menu = this.createMenu();
    menu.text = this.getResource("MESSAGE_FREE_LEVEL_BARRIER_$testObjectId");
    menu.addEventListener( MenuEvent.TYPE_OK, this.onRestartLevelMenuOk);
  }

  void onRestartLevelMenuOk(MenuEvent event) {
    this.removeMenu( event.menu );
    this.engine.continueLevel();
  }

  // start start level menu

  void createStartLevelMenu() {
    this.engine.flow();
    var menu = this.createMenu( );

    if (this.level == 0) {
      menu.text = this.getResource("MESSAGE_FIRST_LEVEL_WEB");
    } else {
      menu.text = this.getResource("MESSAGE_START_LEVEL", [(this.level + 1)]); //"Get Ready\nFor Level " + (this.level + 1);
    }

    menu.addEventListener( MenuEvent.TYPE_OK, this.onStartLevelMenuOk);
  }

  void onStartLevelMenuOk(MenuEvent event) {
    this.removeMenu( event.menu );
    this.nextLevel();
  }

  // create gameover menu

  void createGameOverMenu() {
    var menu = this.createMenu( );
    menu.text = this.getResource("MESSAGE_GAME_OVER"); //"Game\nOver";
    menu.addEventListener(MenuEvent.TYPE_OK, this.onGameOverMenuOk);
  }

  void onGameOverMenuOk(MenuEvent event) {
    this.removeMenu( event.menu );
  }

  Menu createMenu([Menu menu = null, num tweenDuration = 1.0, bool autoStart = true]) {

    if (this.currentMenu != null) this.removeMenu(this.currentMenu);

    this.exitButton.visible = false;
    this.inGameMenu.visible = true;

    if (menu == null) {
      this.currentMenu = new Menu(this, autoStart, fontName );
    } else {
      this.currentMenu = menu;
    }

    this.currentMenu.width = Menu.menuWidth;
    this.currentMenu.height = Menu.menuHeight;
    this.currentMenu.x = (this.gameWidth / 2) - (Menu.menuWidth / 2) + 30;
    this.currentMenu.y = (this.gameHeight / 2) - (Menu.menuHeight / 2);
    this.currentMenu.alpha = 0;

    this.addChild( this.currentMenu );

    var tween = new Tween(this.currentMenu, tweenDuration, Transition.linear);
    tween.animate.alpha.to(1);
    renderJuggler.add(tween);

    return this.currentMenu;
  }

  void removeMenu(Menu menu) {

    this.paused = false;
    this.inGameMenu.visible = true;
    this.exitButton.visible = true;

    if (menu == null) return;
    menu.destroy();

    if (this.contains( menu )) {
      this.removeChild( menu );
    }

    this.currentMenu = null;
  }

  //-----------------------------------------------------------------------------------------------

  // Event Handlers

  void gameTimeOutFunc() {

    renderJuggler.remove(gameTimeOutCall);

    if (this.hasScreenReleaseHint) this.onScreenReleaseMessageOk( null );

    this.mouseIsDown = true;
    this.trainingsMode = false;
  }

  //-----------------------------------------------------------------------------------------------

  void onScreenRelease() {

    if (this.currentMenu != null) return;
    if (platformType.toLowerCase() == "web") return;

    renderJuggler.remove(gameTimeOutCall);

    this.gameTimeOutCall = new DelayedCall(this.gameTimeOutFunc, this.gameTimeOut);
    renderJuggler.add(this.gameTimeOutCall);

    this.hasScreenReleaseHint = true;
    this.paused = true;
    var screenReleaseMenu = this.createMenu( null, 200, false );

    this.exitButton.visible = true;

    screenReleaseMenu.text = this.getResource("MESSAGE_FIRST_LEVEL");
    screenReleaseMenu.addEventListener(MenuEvent.TYPE_OK, this.onScreenReleaseMessageOk);
  }

  void onScreenReleaseMessageOk(MenuEvent event) {

    renderJuggler.remove(this.gameTimeOutCall);

    this.hasScreenReleaseHint = false;
    this.currentMenu.removeEventListeners(MenuEvent.TYPE_OK);
    this.removeMenu(this.currentMenu);
  }

  //-----------------------------------------------------------------------------------------------

  void onExitButtonClick(MouseEvent event) {

    if (this.currentMenu is AbortGameMenu) return;

    var abortGameMenu = new AbortGameMenu( this, fontName );

    this.createMenu( abortGameMenu );
    this.paused = true;

    abortGameMenu.addEventListener( MenuEvent.TYPE_OK, this.onAbortGameMenuOK);
    abortGameMenu.addEventListener( MenuEvent.TYPE_CANCEL, this.onAbortGameMenuCancel);
  }

  void onAbortGameMenuOK(MenuEvent event) {

    this.dispatchEvent(new GameEvent(GameEvent.TYPE_GAME_ABORT, this));

    this.currentMenu.removeEventListeners(MenuEvent.TYPE_OK);
    this.currentMenu.removeEventListeners(MenuEvent.TYPE_CANCEL);

    this.removeMenu( this.currentMenu );
    this.paused = true;
  }

  void onAbortGameMenuCancel(MenuEvent event) {

    this.currentMenu.removeEventListeners(MenuEvent.TYPE_OK);
    this.currentMenu.removeEventListeners(MenuEvent.TYPE_CANCEL);

    this.removeMenu( currentMenu );
  }

//-----------------------------------------------------------------------------------------------

  void onGameStart(GameEvent event) {

    this.engine.flow();
    renderJuggler.delayCall(this.createStartLevelMenu, 0.5);
  }

  void flowEngine() {
    this.engine.flow();
  }

  void onProgressChange(GameEvent event) {
  }

  void onLivesChange(GameEvent event) {
  }

  void onScoreChange(GameEvent event) {
  }

  void onLevelChange(GameEvent event) {
  }

  void onPauseChange(GameEvent event) {
  }

  void onGameOver(GameEvent event) {
    renderJuggler.delayCall(this.createGameOverMenu, 2.0);
  }

  void onGameAbort(GameEvent event) {
  }
}
