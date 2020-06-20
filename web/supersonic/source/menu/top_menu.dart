part of supersonic;

class TopMenu extends GameComponent {
  Bitmap bg;

  TextField scoreTextField;
  TextField livesTextField;
  TextField levelTextField;
  TextField progressTextField;

  Bitmap progressBar;
  Bitmap progressShip;

  String font;
  int txtY = 30;

  List<Bitmap> ships;

  TopMenu(Game game, [String fontName = defaultFont]) : super(game) {
    font = fontName;
    createChildren();

    var sb = StringBuffer();
    sb.write((this.game as MissileGame).getResource('GENlevel'));
    sb.write(': 0');

    levelTextField.text = sb.toString(); //"Level: 0";
  }

  void createChildren() {
    bg = Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('topbar'));
    bg.x = 0;
    bg.y = 0;
    addChild(bg);

    // create score textfield

    scoreTextField = TextField();
    scoreTextField.defaultTextFormat = TextFormat(font, 24, 0, bold: true, align: TextFormatAlign.LEFT);
    scoreTextField.textColor = 0x000000;
    scoreTextField.width = 400;
    scoreTextField.height = 100;
    scoreTextField.x = 20;
    scoreTextField.y = txtY;
    addChild(scoreTextField);

    // create lives textfield

    livesTextField = TextField();
    livesTextField.defaultTextFormat = TextFormat(font, 24, 0, bold: true, align: TextFormatAlign.RIGHT);
    livesTextField.textColor = 0x000000;
    livesTextField.width = 200;
    livesTextField.height = 100;
    livesTextField.x = (game.gameWidth / 2) - livesTextField.width + 60;
    livesTextField.y = txtY;
    addChild(livesTextField);

    // create level textfield

    levelTextField = TextField();
    levelTextField.defaultTextFormat = TextFormat(font, 24, 0, bold: true, align: TextFormatAlign.RIGHT);
    levelTextField.textColor = 0x000000;
    levelTextField.width = 200;
    levelTextField.height = 100;
    levelTextField.x = (game.gameWidth) - (levelTextField.width) - 20;
    levelTextField.y = txtY;
    addChild(levelTextField);

    // create progress textfield

    progressTextField = TextField();
    progressTextField.defaultTextFormat = TextFormat(font, 24, 0, bold: true, align: TextFormatAlign.CENTER);
    progressTextField.textColor = 0x000000;
    progressTextField.width = 200;
    progressTextField.height = 100;
    progressTextField.x = 20;
    progressTextField.y = game.gameHeight - progressTextField.height - 20;
    addChild(progressTextField);
    progressTextField.visible = false;

    progressBar = Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('progressbar'));
    progressBar.x = 25;
    progressBar.y = 82;
    addChild(progressBar);

    progressShip = Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('progressship'));
    progressShip.x = 25;
    progressShip.y = progressBar.y + (progressBar.height - (progressBar.height - progressShip.height)) - (progressShip.height);
    addChild(progressShip);

    // create ships ( lives )

    ships = <Bitmap>[];

    for (var i = 0; i < 3; i++) {
      var spaceShip = Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('spaceship'));
      spaceShip.y = 10;
      spaceShip.x = (game.gameWidth / 2) + 70 + (i * 35);
      addChild(spaceShip);
      ships.add(spaceShip);
    }
  }

  @override
  void onProgressChanged(GameEvent event) {
    progressShip.x = 25;
    progressShip.y = progressBar.y 
      + (progressBar.height - ((progressBar.height - progressShip.height) * event.game.progress)) 
      - (progressShip.height);
    //this.progressTextField.text = "Progress: " + Math.floor(event.game.progress * 100);
  }

  @override
  void onLivesChanged(GameEvent event) {
    var mGame = event.game as MissileGame;

    if (mGame.trainingsMode) {
      livesTextField.text = mGame.getResource('DISPLAY_TRAINING'); //"Training: ";
    } else {
      livesTextField.text = mGame.getResource('DISPLAY_LIVES'); //"Ships: ";
    }

    for (var i = 0; i < ships.length; i++) {
      ships[i].visible = (!mGame.trainingsMode) && (i < event.game.lives);
    }
  }

  @override
  void onScoreChanged(GameEvent event) {
    var mGame = event.game as MissileGame;

    var sb = StringBuffer();
    sb.write(mGame.getResource('GENscore'));
    sb.write(': ${event.game.scoreRounded.toString()}');

    scoreTextField.text = sb.toString();
  }

  @override
  void onLevelChanged(GameEvent event) {
    var mGame = event.game as MissileGame;

    var sb = StringBuffer();
    sb.write(mGame.getResource('GENlevel'));
    sb.write(': ${event.game.level.toString()}');

    levelTextField.text = sb.toString();
  }
}
