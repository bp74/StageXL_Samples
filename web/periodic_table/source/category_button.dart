part of periodic_table;

class CategoryButton extends Sprite {

  Map category;

  CategoryButton(this.category) {

    var name = this.category["name"];
    var color = int.parse(category["color"], radix: 16) | 0xFF000000;

    this.pivotX = 80;
    this.pivotY = 50;
    this.scaleX = 0.5;
    this.scaleY = 0.5;
    this.useHandCursor = true;
    this.mouseChildren = false;

    this.graphics.beginPath();
    this.graphics.rectRound(6, 6, 148, 88, 8, 8);
    this.graphics.closePath();
    this.graphics.fillColor(color);
    this.graphics.strokeColor(Color.Black, 1);

    var font =  "Open Sans, Helvetica Neue, Helvetica, Arial, sans-serif";
    var textFormat = new TextFormat(font, 20, Color.Black, bold:true,
        align: TextFormatAlign.CENTER);

    var textField = new TextField()
      ..defaultTextFormat = textFormat
      ..x = 5
      ..y = 12
      ..wordWrap = true
      ..multiline = true
      ..width = 150
      ..height= 100
      ..cacheAsBitmap = false
      ..mouseEnabled = false
      ..text = name;

    textField.height = textField.textHeight + 1;
    textField.y = (100 -textField.textHeight) ~/ 2;

    addChild(textField);
    applyCache(0, 0, 200, 100);
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  animateTo(num scale, num alpha) {
    this.stage.juggler.removeTweens(this);
    this.stage.juggler.addTween(this, 0.25, Transition.easeOutQuadratic)
      ..animate.scaleX.to(scale)
      ..animate.scaleY.to(scale)
      ..animate.alpha.to(alpha);
  }

}
