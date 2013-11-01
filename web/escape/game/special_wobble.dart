part of escape;

class SpecialWobble extends Sprite implements Animatable {

  Bitmap _bitmap;
  num _currentTime;

  SpecialWobble(ResourceManager resourceManager, Juggler juggler, String special) {

    this.mouseEnabled = false;

    _currentTime = 0.0;
    _bitmap = Grafix.getSpecial(resourceManager, special);

    addChild(_bitmap);

    addEventListener(Event.ADDED_TO_STAGE, (e) => juggler.add(this));
    addEventListener(Event.REMOVED_FROM_STAGE, (e) => juggler.remove(this));
  }

  //------------------------------------------------

  bool advanceTime(num time) {

    _currentTime += time;
    this.rotation = math.sin(_currentTime * 7) * 10 * math.PI / 180;
    return true;
  }

}