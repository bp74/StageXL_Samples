part of supersonic;

class PipeObject extends Sprite {

  Bitmap _bitmap;
  Shape _shape;
  Sprite _blood;

  Vector3D position;

  num continued = -1;
  num rotStep  = 0;
  num sf = 1;

  bool isBarrier = false;
  bool isFinish = false;
  bool isCountdown = false;
  bool isStart = false;

  int countDownId = 0;
  int testObjectId = 0;

  num originalZ = 0;

  PipeObject(Bitmap bitmap) {
    _blood = new Sprite();
    addChild(_blood);

    this.bitmap = bitmap;
    if (this.bitmap == null) return;
    this.x = 100000;
  }

  set bitmap(Bitmap b) {
    if (_bitmap != null) this.removeChild(_bitmap);
    if (_shape != null) this.removeChild(_shape);

    _bitmap = null;
    _shape = null;

    if (b != null) {
      _bitmap = b;
      _bitmap.pivotX = MissileGameEngine.ASSET_SIDELENGTH / 2;
      _bitmap.pivotY = MissileGameEngine.ASSET_SIDELENGTH / 2;
      addChild(_bitmap);
    } else {
      _shape = new Shape();
      addChild(_shape);
    }

    addChild(_blood);
  }

  Bitmap get bitmap => _bitmap;

  void setScale( num sf) {
    this.sf = sf;
    if (_shape != null) {
      _shape.graphics.clear();
      _shape.graphics.beginPath();
      _shape.graphics.circle(0, 0, MissileGameEngine.ASSET_SIDELENGTH / 2 * sf);
      _shape.graphics.closePath();
      _shape.graphics.strokeColor(0xff999999, 1);
    }

    if (_bitmap != null) {
      _bitmap.scaleX = _bitmap.scaleY = sf;
    }

    _blood.scaleX = _blood.scaleY = sf;
  }

  bool hitTest(Point localPoint) {

    if (_bitmap == null) return false;

    var localPointInBitmap = this.localToGlobal(localPoint);
    localPointInBitmap = _bitmap.globalToLocal(localPointInBitmap);

    var color = this.bitmap.bitmapData.getPixel32(localPointInBitmap.x.toInt(), localPointInBitmap.y.toInt());
    var alpha = (color >> 24) & 0xFF;
    var hit = false;

    if (alpha > 0) {
      hit = true;
      var bloodBitmap = new Bitmap(resourceManager.getTextureAtlas("items").getBitmapData("blood"));
      bloodBitmap.pivotX = 50;
      bloodBitmap.pivotY = 50;
      bloodBitmap.x = localPointInBitmap.x - MissileGameEngine.ASSET_SIDELENGTH / 2;
      bloodBitmap.y = localPointInBitmap.y - MissileGameEngine.ASSET_SIDELENGTH / 2;
      _blood.addChild(bloodBitmap);
    }

    return hit;
  }

}
