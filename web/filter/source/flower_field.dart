part of filter;

class FlowerField extends Sprite {

  FlowerField() {

    // Add 100 rotating flowers to the field.

    var random = new math.Random();
    var textureAtlas = resourceManager.getTextureAtlas("flowers");
    var flowers = textureAtlas.getBitmapDatas("Flower");

    for(var i = 0; i < 100; i++) {

      var flower = flowers[random.nextInt(flowers.length)];
      var bitmap = new Bitmap(flower)
        ..pivotX = 64
        ..pivotY = 64
        ..x = 80 + random.nextInt(640 - 160)
        ..y = 80 + random.nextInt(500 - 160)
        ..addTo(this);

      stage.juggler.tween(bitmap, 3600, TransitionFunction.linear)
        ..animate.rotation.to(math.PI * 360.0);
    }
  }
}