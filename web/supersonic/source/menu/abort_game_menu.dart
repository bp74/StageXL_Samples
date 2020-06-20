part of supersonic;

class AbortGameMenu extends Menu {
  SimpleButton btn_yes;
  SimpleButton btn_no;

  TextField text_yes;
  TextField text_no;

  int buttonBorderBottom = 40;
  int buttonBorderH = 30;

  AbortGameMenu(Game game, [String fontName = defaultFont]) : super(game, true, fontName) {
    this.fontName = fontName;

    removeEventListeners(MouseEvent.CLICK);
    removeEventListeners(MouseEvent.MOUSE_DOWN);

    createChildren();
  }

  void createChildren() {
    var mGame = game as MissileGame;

    textField.wordWrap = true;
    text = mGame.getResource('GENexitquery');

    btn_yes = SimpleButton(
        Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('but_yes')),
        Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('but_yes2')),
        Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('but_yes2')),
        Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('but_yes2')));

    btn_yes.x = buttonBorderH;
    btn_yes.y = Menu.menuHeight - btn_yes.height - buttonBorderBottom;
    btn_yes.addEventListener(MouseEvent.CLICK, yes);
    addChild(btn_yes);

    btn_no = SimpleButton(
        Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('but_no')),
        Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('but_no2')),
        Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('but_no2')),
        Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('but_no2')));

    btn_no.x = Menu.menuWidth - btn_no.width - buttonBorderH;
    btn_no.y = Menu.menuHeight - btn_yes.height - buttonBorderBottom;
    btn_no.addEventListener(MouseEvent.CLICK, no);
    addChild(btn_no);

    text_yes = TextField();
    text_yes.addEventListener(MouseEvent.CLICK, btn_yes.dispatchEvent);
    text_yes.textColor = 0x000000;
    text_yes.defaultTextFormat = TextFormat(fontName, 48, 0, bold: true, align: TextFormatAlign.LEFT);
    text_yes.height = 60;
    text_yes.x = btn_yes.x + btn_yes.width;
    text_yes.y = btn_yes.y + 5;
    addChild(text_yes);
    text_yes.text = mGame.getResource('GENyes');

    text_no = TextField();
    text_no.addEventListener(MouseEvent.CLICK, btn_no.dispatchEvent);
    text_no.textColor = 0x000000;
    text_no.defaultTextFormat = TextFormat(fontName, 48, 0, bold: true, align: TextFormatAlign.RIGHT);
    text_no.height = 60;
    text_no.x = btn_no.x - text_no.width;
    text_no.y = btn_yes.y + 5;
    addChild(text_no);
    text_no.text = mGame.getResource('GENno');
  }

  @override
  void defaultAction() {
    no(null);
  }

  void yes(Event event) {
    destroy();
    dispatchEvent(MenuEvent(MenuEvent.TYPE_OK, this));
  }

  void no(Event event) {
    destroy();
    dispatchEvent(MenuEvent(MenuEvent.TYPE_CANCEL, this));
  }
}
