part of escape;

class Head extends Sprite {

  ResourceManager _resourceManager;
  Juggler _juggler;

  List<BitmapData> _headBitmapDatas;
  Bitmap _headBitmap;

  Translation _nodTranslation;

  //--------------------------------------------------------------------------------------------

  Head(ResourceManager resourceManager, Juggler juggler) {

    _resourceManager = resourceManager;
    _juggler = juggler;
    _headBitmapDatas = Grafix.getHeads(_resourceManager);

    _headBitmap = new Bitmap(_headBitmapDatas[0]);
    _headBitmap.x = -_headBitmap.width / 2;
    _headBitmap.y = -_headBitmap.height / 2;

    addChild(_headBitmap);

    _nodTranslation = null;
  }

  //--------------------------------------------------------------------------------------------

  void nod(int count) {

    _juggler.remove(_nodTranslation);

    _nodTranslation = new Translation(0, count, 0.5 * count, Transition.linear);

    _nodTranslation.onUpdate = (value) {
      int frame = ((value * _headBitmapDatas.length) % _headBitmapDatas.length).toInt();
      _headBitmap.bitmapData = _headBitmapDatas[frame];
      _headBitmap.y = math.sin(value * 2 * math.PI) * 3 - _headBitmap.height / 2;
    };

    _juggler.add(_nodTranslation);
  }

  void nodStop() {

    _juggler.remove(_nodTranslation);
    _headBitmap.bitmapData = _headBitmapDatas[0];
  }

}
