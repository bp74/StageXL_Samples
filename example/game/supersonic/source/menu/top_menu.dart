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

  TopMenu(Game game, [String fontName = defaultFont]):super(game) {

    this.font = fontName;
    this.createChildren();

    StringBuffer sb = new StringBuffer();
    sb.write((this.game as MissileGame).getResource("GENlevel"));
    sb.write(": 0");

    levelTextField.text = sb.toString(); //"Level: 0";
  }

  void createChildren() {

    this.bg = new Bitmap(resourceManager.getTextureAtlas("items").getBitmapData("topbar"));
    this.bg.x = 0;
    this.bg.y = 0;
    this.addChild( this.bg );

    // create score textfield

    this.scoreTextField = new TextField();
    this.scoreTextField.defaultTextFormat = new TextFormat(font, 24, 0, bold:true, align:TextFormatAlign.LEFT);
    this.scoreTextField.textColor = 0x000000;
    this.scoreTextField.width = 400;
    this.scoreTextField.height = 100;
    this.scoreTextField.x = 20;
    this.scoreTextField.y = txtY;
    this.addChild( scoreTextField );

    // create lives textfield

    this.livesTextField = new TextField();
    this.livesTextField.defaultTextFormat = new TextFormat(font, 24, 0, bold:true, align:TextFormatAlign.RIGHT);
    this.livesTextField.textColor = 0x000000;
    this.livesTextField.width = 200;
    this.livesTextField.height = 100;
    this.livesTextField.x = (this.game.gameWidth / 2) - this.livesTextField.width + 60;
    this.livesTextField.y = txtY;
    this.addChild( livesTextField );

    // create level textfield

    this.levelTextField = new TextField();
    this.levelTextField.defaultTextFormat = new TextFormat(font, 24, 0, bold:true, align:TextFormatAlign.RIGHT);
    this.levelTextField.textColor = 0x000000;
    this.levelTextField.width = 200;
    this.levelTextField.height = 100;
    this.levelTextField.x = (this.game.gameWidth) - (this.levelTextField.width) - 20;
    this.levelTextField.y = txtY;
    this.addChild( levelTextField );

    // create progress textfield

    this.progressTextField = new TextField();
    this.progressTextField.defaultTextFormat = new TextFormat(font, 24, 0, bold:true, align:TextFormatAlign.CENTER);
    this.progressTextField.textColor = 0x000000;
    this.progressTextField.width = 200;
    this.progressTextField.height = 100;
    this.progressTextField.x = 20;
    this.progressTextField.y = this.game.gameHeight - this.progressTextField.height - 20;
    this.addChild( progressTextField );
    this.progressTextField.visible = false;

    this.progressBar = new Bitmap(resourceManager.getTextureAtlas("items").getBitmapData("progressbar"));
    this.progressBar.x = 25;
    this.progressBar.y = 82;
    this.addChild(this.progressBar);

    this.progressShip = new Bitmap(resourceManager.getTextureAtlas("items").getBitmapData("progressship"));
    this.progressShip.x = 25;
    this.progressShip.y = this.progressBar.y + (this.progressBar.height - (this.progressBar.height - this.progressShip.height)) - (this.progressShip.height);
    this.addChild(this.progressShip);

    // create ships ( lives )

    this.ships = new List<Bitmap>();

    for (var i = 0; i < 3; i++) {
      var spaceShip= new Bitmap(resourceManager.getTextureAtlas("items").getBitmapData("spaceship"));
      spaceShip.y = 10;
      spaceShip.x = (this.game.gameWidth / 2) + 70 +( i * 35);
      this.addChild( spaceShip );
      this.ships.add( spaceShip );
    }
  }

  // Override
  void onProgressChanged(GameEvent event) {
    this.progressShip.x = 25;
    this.progressShip.y = this.progressBar.y + (this.progressBar.height - ((this.progressBar.height - this.progressShip.height) * event.game.progress)) - (this.progressShip.height);
    //this.progressTextField.text = "Progress: " + Math.floor(event.game.progress * 100);
  }

  // Override
  void onLivesChanged(GameEvent event) {

    var mGame = event.game as MissileGame;

    if (mGame.trainingsMode) {
      this.livesTextField.text = mGame.getResource("DISPLAY_TRAINING"); //"Training: ";
    } else {
      this.livesTextField.text = mGame.getResource("DISPLAY_LIVES"); //"Ships: ";
    }

    for (var i = 0; i<this.ships.length; i++) {
      this.ships[i].visible = (!mGame.trainingsMode) && (i < event.game.lives);
    }
  }

  void onScoreChanged(GameEvent event) {

    var mGame = event.game as MissileGame;

    var sb = new StringBuffer();
    sb.write(mGame.getResource("GENscore"));
    sb.write(": ${event.game.scoreRounded.toString()}");

    scoreTextField.text = sb.toString();
  }


  void onLevelChanged(GameEvent event) {

    var mGame = event.game as MissileGame;

    var sb = new StringBuffer();
    sb.write(mGame.getResource("GENlevel"));
    sb.write(": ${event.game.level.toString()}");

    levelTextField.text = sb.toString();
  }

}