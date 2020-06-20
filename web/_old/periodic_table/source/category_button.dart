part of periodic_table;

class CategoryButton extends Sprite {
  Map category;

  CategoryButton(this.category) {
    var name = category['name'];
    var color = int.parse(category['color'], radix: 16) | 0xFF000000;

    pivotX = 80;
    pivotY = 50;
    scaleX = 0.5;
    scaleY = 0.5;
    useHandCursor = true;
    mouseChildren = false;

    graphics.beginPath();
    graphics.rectRound(6, 6, 148, 88, 8, 8);
    graphics.closePath();
    graphics.fillColor(color);
    graphics.strokeColor(Color.Black, 1);

    var font = 'Open Sans, Helvetica Neue, Helvetica, Arial, sans-serif';
    var textFormat = TextFormat(font, 20, Color.Black, bold: true, align: TextFormatAlign.CENTER);

    var textField = TextField()
      ..defaultTextFormat = textFormat
      ..x = 5
      ..y = 12
      ..wordWrap = true
      ..multiline = true
      ..width = 150
      ..height = 100
      ..cacheAsBitmap = false
      ..mouseEnabled = false
      ..text = name;

    textField.height = textField.textHeight + 1;
    textField.y = (100 - textField.textHeight) ~/ 2;

    addChild(textField);
    applyCache(0, 0, 200, 100);
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  void animateTo(num scale, num alpha) {
    stage.juggler.removeTweens(this);
    stage.juggler.addTween(this, 0.25, Transition.easeOutQuadratic)
      ..animate.scaleX.to(scale)
      ..animate.scaleY.to(scale)
      ..animate.alpha.to(alpha);
  }
}
