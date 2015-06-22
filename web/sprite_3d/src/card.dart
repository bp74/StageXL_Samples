part of example;

class Card extends Sprite3D {

  final int id;
  final ResourceManager resourceManager;

  bool concealed = false;

  Sprite _front = new Sprite();
  Sprite _back = new Sprite();

  Card(this.resourceManager, this.id, BitmapData iconBitmapData) {

    var atlas = resourceManager.getTextureAtlas("atlas");
    var frontBitmap = new Bitmap(atlas.getBitmapData("card-front"));
    var backBitmap = new Bitmap(atlas.getBitmapData("card-back"));
    var iconBitmap = new Bitmap(iconBitmapData);

    frontBitmap.pivotX = frontBitmap.width / 2.0;
    frontBitmap.pivotY = frontBitmap.height / 2.0;

    backBitmap.pivotX = backBitmap.width / 2.0;
    backBitmap.pivotY = backBitmap.height / 2.0;

    iconBitmap.pivotX = iconBitmap.width / 2.0;
    iconBitmap.pivotY = iconBitmap.height / 2.0;
    iconBitmap.scaleX = 0.8;
    iconBitmap.scaleY = 0.8;

    _front.addChild(frontBitmap);
    _front.addChild(iconBitmap);
    _front.addTo(this);

    _back.addChild(backBitmap);
    _back.addTo(this);

    this.perspectiveProjection = new PerspectiveProjection.none();
    this.mouseChildren = false;
  }

  //---------------------------------------------------------------------------

  @override
  void render(RenderState renderState) {

    var isForwardFacing = this.isForwardFacing;
    _front.visible = isForwardFacing;
    _back.visible = !isForwardFacing;

    super.render(renderState);
  }

}
