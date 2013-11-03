part of mask;

class FlowerField extends Sprite {

  FlowerField() {

    this.pivotX = 470;
    this.pivotY = 250;

    // Add 150 rotating flowers to the field.

    var random = new math.Random();

    for(var i = 0; i < 150; i++) {

      var flower = 1 + random.nextInt(3);
      var bitmapData = resourceManager.getBitmapData('flower${flower}');
      var bitmap = new Bitmap(bitmapData)
        ..pivotX = 64
        ..pivotY = 64
        ..x = 64 + random.nextInt(940 - 128)
        ..y = 64 + random.nextInt(500 - 128);

      addChild(bitmap);

      stage.juggler.tween(bitmap, 600, TransitionFunction.linear)
        ..animate.rotation.to(math.PI * 60.0);
    }
  }
}