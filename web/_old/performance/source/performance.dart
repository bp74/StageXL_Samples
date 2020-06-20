part of performance;

class Performance extends DisplayObjectContainer implements Animatable {
  final ResourceManager _resourceManager;
  final Juggler _juggler = Juggler();

  Performance(this._resourceManager);

  @override
  bool advanceTime(num time) {
    _juggler.advanceTime(time);
    return true;
  }

  //---------------------------------------------------------------------------

  void addFlags(int amount) {
    var random = math.Random();
    var textureAtlas = _resourceManager.getTextureAtlas('flags');
    var flagNames = textureAtlas.frameNames;

    while (--amount >= 0) {
      var flagName = flagNames[random.nextInt(flagNames.length)];
      var flagBitmapData = textureAtlas.getBitmapData(flagName);
      var velocityX = random.nextInt(200) - 100;
      var velocityY = random.nextInt(200) - 100;
      var flyingFlag = FlyingFlag(flagBitmapData, velocityX, velocityY);
      flyingFlag.x = 30 + random.nextInt(940 - 60);
      flyingFlag.y = 30 + random.nextInt(500 - 60);
      addChild(flyingFlag);
      _juggler.add(flyingFlag);
    }
  }

  //---------------------------------------------------------------------------

  void removeFlags(int amount) {
    while (--amount >= 0 && numChildren > 0) {
      var flyingFlag = getChildAt(0) as FlyingFlag;
      flyingFlag.removeFromParent();
      _juggler.remove(flyingFlag);
    }
  }
}
