part of escape;

class Lock extends Sprite {
  ResourceManager _resourceManager;
  Juggler _juggler;

  Bitmap _bitmap;
  List<BitmapData> _lockBitmapDatas;
  bool _locked;

  Lock(ResourceManager resourceManager, Juggler juggler, int color) {
    _resourceManager = resourceManager;
    _juggler = juggler;

    _lockBitmapDatas = Grafix.getLock(_resourceManager, color);
    _locked = true;

    _bitmap = Bitmap(_lockBitmapDatas[0]);
    _bitmap.x = -34;
    _bitmap.y = -50;

    addChild(_bitmap);
  }

  //-----------------------------------------------------------------

  bool get locked => _locked;
  set locked(bool value) {
    _locked = value;
  }

  //-----------------------------------------------------------------

  void showLocked(bool locked) {
    _bitmap.bitmapData = _lockBitmapDatas[locked ? 0 : 4];
  }

  void showHappy() {
    var translation = Translation(0.0, 1.0, 2.0, Transition.easeOutCubic);
    translation.onUpdate = (value) {
      scaleX = scaleY = 1.0 + 0.2 * math.sin(value * 4 * math.pi);
    };

    var tween1 = Tween(this, 0.2, Transition.easeOutCubic);
    tween1.animate.alpha.to(0.0);
    tween1.delay = 2.0;
    tween1.onComplete = () => showLocked(_locked);

    var tween2 = Tween(this, 0.2, Transition.easeInCubic);
    tween2.animate.alpha.to(1);
    tween2.delay = 2.2;

    _juggler.add(translation);
    _juggler.add(tween1);
    _juggler.add(tween2);
  }
}
