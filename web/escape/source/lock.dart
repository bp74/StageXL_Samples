part of escape;

class Lock extends Sprite {

  ResourceManager _resourceManager;
  Juggler _juggler;

  int _color;
  Bitmap _bitmap;
  List<BitmapData> _lockBitmapDatas;
  bool _locked;

  Lock(ResourceManager resourceManager, Juggler juggler, int color) {

    _resourceManager = resourceManager;
    _juggler = juggler;

    _color = color;
    _lockBitmapDatas = Grafix.getLock(_resourceManager, color);
    _locked = true;

    _bitmap = new Bitmap(_lockBitmapDatas[0]);
    _bitmap.x = -34;
    _bitmap.y = -50;

    addChild(_bitmap);
  }

  //-----------------------------------------------------------------

  bool get locked => _locked;
  void set locked(bool value) { _locked = value; }

  //-----------------------------------------------------------------

  void showLocked(bool locked) {
    _bitmap.bitmapData = _lockBitmapDatas[locked ? 0 : 4];
  }

  void showHappy() {

    Transition transition = new Transition(0.0, 1.0, 2.0, TransitionFunction.easeOutCubic);
    transition.onUpdate = (value) {
      scaleX = scaleY = 1.0 + 0.2 * math.sin(value * 4 * math.PI);
    };

    Tween tween1 = new Tween(this, 0.2, TransitionFunction.easeOutCubic);
    tween1.animate.alpha.to(0.0);
    tween1.delay = 2.0;
    tween1.onComplete = () => showLocked(_locked);

    Tween tween2 = new Tween(this, 0.2, TransitionFunction.easeInCubic);
    tween2.animate.alpha.to(1);
    tween2.delay = 2.2;

    _juggler.add(transition);
    _juggler.add(tween1);
    _juggler.add(tween2);
  }

}