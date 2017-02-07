part of supersonic;

class Menu extends GameComponent implements Animatable {

    static int menuWidth = 588;
    static int menuHeight = 314;
    static int menuBorder = 100;
    static int menuGap = 5;
    static int menuCornerRadius = 10;
    static num autoStartDelay = 10.0;

    Bitmap bg ;
    TextField textField;
    num _timeProgress;
    num showTime;

    String fontName;

    Menu(Game game, [bool autoStart = true, String fontName = defaultFont]):super(game) {

      this.fontName = fontName;
      this.width  = Menu.menuWidth;
      this.height = Menu.menuHeight;

      this.bg = new Bitmap(resourceManager.getTextureAtlas("items").getBitmapData("menu_bg"));
      this.addChild( this.bg );

      this.textField = new TextField();
      this.textField.textColor = 0x000000;
      this.textField.wordWrap = true;
      this.textField.defaultTextFormat = new TextFormat(fontName, 30, 0x000000, bold:true, align:TextFormatAlign.CENTER);
      this.textField.width = 476;
      this.textField.height = 250;//182;
      this.textField.x = 60;
      this.textField.y = 90;
      this.addChild( this.textField );

      this.addEventListener( MouseEvent.MOUSE_DOWN, this.onClick);

      if (autoStart) {
        this.timeProgress = 0;
        this.showTime = 0;
        renderJuggler.add(this);
      } else {
        this.timeProgress = 1;
      }

      this.alpha = 0;
  }

  bool advanceTime(num time) {

    this.showTime += time;

    if (this.showTime > autoStartDelay) {
      destroy();
      defaultAction();
      return false;
    }

    return true;
  }

  set text( String value) {

      if (value == null) return;

      var tf = new TextFormat(fontName, 30, 0x000000, bold:true, align:TextFormatAlign.CENTER);
      tf.size = (value.length <= 30) ? 45 : 30;

      this.textField.defaultTextFormat = tf;
      this.textField.text = value;
    }

    void onClick(MouseEvent event) {
      destroy();
      defaultAction();
    }

    void defaultAction() {
      this.dispatchEvent(new MenuEvent(MenuEvent.TYPE_OK, this));
    }

    set timeProgress( num value ) {

      if (value < 0) value = 1;
      if (value > 1) value = 1;
      _timeProgress = value;

      //var ratio = (255 * _timeProgress).round().toInt();
      //var mat:Matrix = new Matrix();
      //mat.createGradientBox( 314, 5, 0, 140, 280 );
      //this.graphics.beginFill( 0xffffff, 1 );
      //this.graphics.drawRect( 138, 277, 318, 10 );
      //this.graphics.beginGradientFill(GradientType.LINEAR,[0xc00000, 0xffffff],[1,1],[ratio/2, ratio],mat);
      //this.graphics.beginFill(0xc00000, 1);
      //this.graphics.drawRect( 140, 280, 314, 5 );
    }

    num get timeProgress {
      return _timeProgress;
    }

    void destroy() {
      renderJuggler.remove(this);
    }

  }
