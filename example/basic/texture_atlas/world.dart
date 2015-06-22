part of texture_atlas_example;

class World extends Sprite implements Animatable {

  final Sprite layerSky = new Sprite();
  final Sprite layerMountain = new Sprite();
  final Sprite layerGround = new Sprite();
  final Sprite layerMonsters = new Sprite();
  final Sprite layerBoys = new Sprite();

  num _animationTime = 0.0;

  World(TextureAtlas textureAtlas) {

    // get all BitmapDatas from the TextureAltas
    var sky = textureAtlas.getBitmapData("background/sky");
    var mountain = textureAtlas.getBitmapData("background/mountain");
    var ground = textureAtlas.getBitmapData("background/ground");
    var monsters = textureAtlas.getBitmapDatas("monster/frame");
    var boys = textureAtlas.getBitmapDatas("boy/frame");

    // add the layers
    this.addChild(layerSky);
    this.addChild(layerMountain);
    this.addChild(layerGround);
    this.addChild(layerMonsters);
    this.addChild(layerBoys);

    // add Bitmaps to the layers
    layerSky.addChild(new Bitmap(sky)..x = 0);
    layerSky.addChild(new Bitmap(sky)..x = 1199);
    layerSky.addChild(new Bitmap(sky)..x = 2398);
    layerMountain.addChild(new Bitmap(mountain)..x = 0);
    layerMountain.addChild(new Bitmap(mountain)..x = 1199);
    layerMountain.addChild(new Bitmap(mountain)..x = 2398);
    layerGround.addChild(new Bitmap(ground)..x = 0);
    layerGround.addChild(new Bitmap(ground)..x = 1199);
    layerGround.addChild(new Bitmap(ground)..x = 2398);

    // create FlipBooks with the monster animation
    for (int i = 0; i < 6; i++) {
      layerMonsters.addChild(new FlipBook(monsters, 10)
        ..pivotX = monsters.first.width / 2
        ..pivotY = monsters.first.height / 2
        ..x = 100 + i * 160
        ..y = 150 + 50 * math.sin(i * 2.0)
        ..play());
    }

    // create FlipBooks with the boy animation
    for (int i = 0; i < 3; i++) {
      layerBoys.addChild(new FlipBook(boys, 10)
        ..pivotX = boys.first.width / 2
        ..pivotY = boys.first.height
        ..x = 200 + 300 * i
        ..y = 530
        ..play());
    }
  }

  bool advanceTime(num time) {

    _animationTime += time;

    layerSky.x = -600 - ((_animationTime / 16.0) % 1.0) * 1200;
    layerMountain.x = -600 - ((_animationTime / 12.0) % 1.0) * 1200;
    layerGround.x = -600 - ((_animationTime / 8.0) % 1.0) * 1200;
    layerMonsters.children.forEach((c) => c.advanceTime(time));
    layerBoys.children.forEach((c) => c.advanceTime(time));

    return true;
  }
}
