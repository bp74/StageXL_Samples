part of escape;

class Alarm extends Sprite {

  ResourceManager _resourceManager;
  Juggler _juggler;

  List<BitmapData> _alarmBitmapDatas;
  Bitmap _alarmBitmap;

  Sound _warning;
  SoundChannel _warningChannel;
  Translation _translation;

  //--------------------------------------------------------------------------------------------

  Alarm(ResourceManager resourceManager, Juggler juggler) {

    _resourceManager= resourceManager;
    _juggler = juggler;

    _alarmBitmapDatas = Grafix.getAlarms(_resourceManager);
    _alarmBitmap = new Bitmap(_alarmBitmapDatas[0]);

    _warning = _resourceManager.getSound("Warning");
    _warningChannel = null;

    addChild(_alarmBitmap);
  }

  //--------------------------------------------------------------------------------------------

  void start() {

    _warningChannel = _warning.play();
    _juggler.remove(_translation);
    _translation = new Translation(0, 80, 9.0, Transition.linear);

    _translation.onUpdate = (value) {
      int frame = value.toInt() % 8;
      _alarmBitmap.bitmapData = _alarmBitmapDatas[(frame <= 4) ? frame + 1 : 8 - frame];
    };

    _juggler.add(_translation);
  }

  void stop() {

    if (_warningChannel != null) {
      _warningChannel.stop();
      _warningChannel = null;
    }

    _juggler.remove(_translation);
    _alarmBitmap.bitmapData = _alarmBitmapDatas[0];
  }

}
