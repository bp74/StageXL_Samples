part of periodic_table;

class ElementIcon extends Sprite {

  Tween _mouseOverTween = null;

  ElementIcon(Map element, int categoryColor) {

    this.pivotX = 25;
    this.pivotY = 25;
    this.useHandCursor = true;
    this.mouseChildren = false;
    this.onMouseOver.listen(_onMouseOver);
    this.onMouseOut.listen(_onMouseOut);

    this.graphics.beginPath();
    this.graphics.rectRound(3, 3, 44, 44, 4, 4);
    this.graphics.closePath();
    this.graphics.fillColor(categoryColor);
    this.graphics.strokeColor(Color.Black, 1);

    var symbol = element["symbol"];
    var atomicNumber = element["atomic_number"];

    var numberTextFormat = new TextFormat("Arial", 12, Color.Black);
    var symbolTextFormat = new TextFormat("Arial", 20, Color.Black);

    var numberTextField = new TextField()
      ..defaultTextFormat = numberTextFormat
      ..x = 0
      ..y = 6
      ..width = 50
      ..cacheAsBitmap = false
      ..autoSize = TextFieldAutoSize.CENTER
      ..mouseEnabled = false
      ..text = atomicNumber.toString();

    var symbolTextField = new TextField()
      ..defaultTextFormat = symbolTextFormat
      ..x = 0
      ..y = 20
      ..width = 50
      ..cacheAsBitmap = false
      ..autoSize = TextFieldAutoSize.CENTER
      ..mouseEnabled = false
      ..text = symbol;

    addChild(symbolTextField);
    addChild(numberTextField);
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  _onMouseOver(Event event) {

    this.parent.addChild(this);

    var juggler = this.stage.juggler;
    juggler.remove(_mouseOverTween);

    _mouseOverTween = new Tween(this, 0.25, TransitionFunction.easeOutQuadratic);
    _mouseOverTween.animate.scaleX.to(1.5);
    _mouseOverTween.animate.scaleY.to(1.5);
    juggler.add(_mouseOverTween);
  }

  //-----------------------------------------------------------------------------------------------

  _onMouseOut(Event event) {

    this.parent.addChild(this);

    var juggler = this.stage.juggler;
    juggler.remove(_mouseOverTween);

    _mouseOverTween = new Tween(this, 0.25, TransitionFunction.easeOutQuadratic);
    _mouseOverTween.animate.scaleX.to(1.0);
    _mouseOverTween.animate.scaleY.to(1.0);
    juggler.add(_mouseOverTween);
  }


}