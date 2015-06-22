part of mask;

class FlowerField extends Sprite {

  FlowerField() {

    // Add 150 rotating flowers to the field.

    var random = new math.Random();
    var textureAtlas = resourceManager.getTextureAtlas("flowers");
    var flowers = textureAtlas.getBitmapDatas("Flower");

    for(var i = 0; i < 150; i++) {

      var flower = flowers[random.nextInt(flowers.length)];
      var bitmap = new Bitmap(flower)
        ..pivotX = 64
        ..pivotY = 64
        ..x = 64 + random.nextInt(940 - 128)
        ..y = 64 + random.nextInt(500 - 128)
        ..addTo(this);

      stage.juggler.addTween(bitmap, 600, Transition.linear)
        ..animate.rotation.to(math.PI * 60.0);
    }
  }
}
