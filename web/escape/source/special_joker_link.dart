part of escape;

class SpecialJokerLink extends Sprite implements Animatable {

  Bitmap _bitmap;
  List<BitmapData> _jokerBitmapDatas;
  num _currentTime;

  SpecialJokerLink(ResourceManager resourceManager, Juggler juggler, int direction) {

    this.mouseEnabled = false;

    _currentTime = 0.0;
    _jokerBitmapDatas = Grafix.getJokerLink(resourceManager, direction);

     _bitmap = new Bitmap(_jokerBitmapDatas[0]);
     _bitmap.x = -25;
     _bitmap.y = -25;
    addChild(_bitmap);

    addEventListener(Event.ADDED_TO_STAGE, (e) => juggler.add(this));
    addEventListener(Event.REMOVED_FROM_STAGE, (e) => juggler.remove(this));
  }

  //------------------------------------------------

  bool advanceTime(num time) {

    _currentTime += time;

    int frame = (_currentTime * 10).toInt() % _jokerBitmapDatas.length;
    _bitmap.bitmapData = _jokerBitmapDatas[frame];

    return true;
  }

}