part of periodic_table;

class ElementButton extends Sprite {

  Map element;
  Map category;

  ElementButton(this.element, this.category) {

    var symbol = element["symbol"];
    var atomicNumber = element["atomic_number"];
    var categoryColor = int.parse(category["color"], radix: 16) | 0xFF000000;

    this.pivotX = 50;
    this.pivotY = 50;
    this.scaleX = 0.5;
    this.scaleY = 0.5;
    this.useHandCursor = true;
    this.mouseChildren = false;
    this.onMouseOver.listen(_onMouseOver);
    this.onMouseOut.listen(_onMouseOut);

    this.graphics.beginPath();
    this.graphics.rectRound(6, 6, 88, 88, 8, 8);
    this.graphics.closePath();
    this.graphics.fillColor(categoryColor);
    this.graphics.strokeColor(Color.Black, 1);

    var font =  "Open Sans,Helvetica Neue, Helvetica, Arial, sans-serif";
    var numberTextFormat = new TextFormat(font, 24, Color.Black, bold:true);
    var symbolTextFormat = new TextFormat(font, 40, Color.Black, bold:true);

    var numberTextField = new TextField()
      ..defaultTextFormat = numberTextFormat
      ..x = 0
      ..y = 12
      ..width = 100
      ..cacheAsBitmap = false
      ..autoSize = TextFieldAutoSize.CENTER
      ..mouseEnabled = false
      ..text = atomicNumber.toString();

    var symbolTextField = new TextField()
      ..defaultTextFormat = symbolTextFormat
      ..x = 0
      ..y = 40
      ..width = 100
      ..cacheAsBitmap = false
      ..autoSize = TextFieldAutoSize.CENTER
      ..mouseEnabled = false
      ..text = symbol;

    addChild(symbolTextField);
    addChild(numberTextField);

    applyCache(0,0,100,100);
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  animateTo(num scale, num alpha) {
    var juggler = this.stage.juggler;
    juggler.removeTweens(this);

    juggler.tween(this, 0.25, TransitionFunction.easeOutQuadratic)
      ..animate.scaleX.to(scale)
      ..animate.scaleY.to(scale)
      ..animate.alpha.to(alpha);
  }

  _onMouseOver(Event event) {
    this.parent.addChild(this);
    animateTo(0.70, 1.0);
    dispatchEvent(new Event("ButtonSelected"));
  }

  _onMouseOut(Event event) {
    animateTo(0.5, 1.0);
    dispatchEvent(new Event("ButtonDeselected"));
  }
}