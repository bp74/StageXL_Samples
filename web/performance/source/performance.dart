part of performance;

class Performance extends DisplayObjectContainer {

  Performance() {

    // let's start with 500 flags
    _addFlags(500);

    // add html-button event listeners
    html.querySelector('#minus100').onClick.listen((e) => _removeFlags(100));
    html.querySelector('#plus100').onClick.listen((e) => _addFlags(100));
  }

  //---------------------------------------------------------------------------------

  _addFlags(int amount) {

    var random = new math.Random();
    var textureAtlas = resourceManager.getTextureAtlas('flags');
    var flagNames = textureAtlas.frameNames;
    var juggler = stage.juggler;

    while(--amount >= 0) {
      var flagName = flagNames[random.nextInt(flagNames.length)];
      var flagBitmapData = textureAtlas.getBitmapData(flagName);
      var velocityX = random.nextInt(200) - 100;
      var velocityY = random.nextInt(200) - 100;

      var flyingFlag = new FlyingFlag(flagBitmapData, velocityX, velocityY);
      flyingFlag.x = 30 + random.nextInt(940 - 60);
      flyingFlag.y = 30 + random.nextInt(500 - 60);
      addChild(flyingFlag);

      juggler.add(flyingFlag);
    }

    html.querySelector('#flagCounter').innerHtml = 'Flags: ${numChildren}';
  }

  //---------------------------------------------------------------------------------

  _removeFlags(int amount) {

    var juggler = stage.juggler;

    while(--amount >= 0 && numChildren > 0) {
      var displayObject = getChildAt(0);
      displayObject.removeFromParent();
      juggler.remove(displayObject);
    }

    html.querySelector('#flagCounter').innerHtml = 'Flags: ${numChildren}';
  }
}
