part of escape;

class Grafix {
  static Bitmap getChain(ResourceManager resourceManager, int color, int direction) {
    var bitmap = Bitmap(
        resourceManager.getTextureAtlas('Elements').getBitmapData('Chain${color}${direction}'));
    bitmap.pivotX = 25;
    bitmap.pivotY = 25;

    return bitmap;
  }

  //--------------------------------------------------------------------------------------------

  static Bitmap getLink(ResourceManager resourceManager, int color, int direction) {
    var bitmap = Bitmap(
        resourceManager.getTextureAtlas('Elements').getBitmapData('Link${color}${direction}'));
    bitmap.pivotX = 25;
    bitmap.pivotY = 25;

    return bitmap;
  }

  //--------------------------------------------------------------------------------------------

  static Bitmap getWhiteLink(ResourceManager resourceManager, int direction) {
    var bitmap =
        Bitmap(resourceManager.getTextureAtlas('Elements').getBitmapData('Link8${direction}'));
    bitmap.pivotX = 25;
    bitmap.pivotY = 25;

    return bitmap;
  }

  //--------------------------------------------------------------------------------------------

  static Bitmap getSpecial(ResourceManager resourceManager, String special) {
    var bitmap = Bitmap(resourceManager.getTextureAtlas('Elements').getBitmapData(special));
    bitmap.pivotX = 25;
    bitmap.pivotY = 25;

    return bitmap;
  }

  //--------------------------------------------------------------------------------------------

  static Sprite getLevelUpAnimation(ResourceManager resourceManager, Juggler juggler) {
    var sprite = Sprite();
    num offset = 0;

    var textureAtlas = resourceManager.getTextureAtlas('Levelup');

    for (var i = 0; i < 7; i++) {
      var bitmap = Bitmap(textureAtlas.getBitmapData('LevelUp${i}'));
      bitmap.x = -bitmap.width / 2;
      bitmap.y = -bitmap.height / 2;
      //bitmap.filters = [GlowFilter(0x000000, 0.5, 30, 30)];  // ToDo

      var subSprite = Sprite();
      subSprite.addChild(bitmap);
      subSprite.x = offset + bitmap.width / 2;
      subSprite.scaleX = 0;
      subSprite.scaleY = 0;

      sprite.addChild(subSprite);

      var tween1 = Tween(subSprite, 2.0, Transition.easeOutElastic);
      tween1.animate.scaleX.to(1.0);
      tween1.animate.scaleY.to(1.0);
      tween1.delay = i * 0.05;

      var tween2 = Tween(subSprite, 0.4, Transition.linear);
      tween2.animate.scaleX.to(0.0);
      tween2.animate.scaleY.to(0.0);
      tween2.delay = 3.0;

      juggler.add(tween1);
      juggler.add(tween2);

      offset = offset + 5 + bitmap.width;
    }

    return sprite;
  }

  //--------------------------------------------------------------------------------------------

  static List<BitmapData> getJokerChain(ResourceManager resourceManager, int direction) {
    var textureAtlas = resourceManager.getTextureAtlas('Elements');

    var tmp = <BitmapData>[];
    tmp.add(textureAtlas.getBitmapData('JokerChain${direction}0'));
    tmp.add(textureAtlas.getBitmapData('JokerChain${direction}1'));
    tmp.add(textureAtlas.getBitmapData('JokerChain${direction}2'));
    tmp.add(textureAtlas.getBitmapData('JokerChain${direction}3'));
    tmp.add(textureAtlas.getBitmapData('JokerChain${direction}4'));
    return tmp;
  }

  static List<BitmapData> getJokerLink(ResourceManager resourceManager, int direction) {
    var textureAtlas = resourceManager.getTextureAtlas('Elements');

    var tmp = <BitmapData>[];
    tmp.add(textureAtlas.getBitmapData('JokerLink${direction}0'));
    tmp.add(textureAtlas.getBitmapData('JokerLink${direction}1'));
    tmp.add(textureAtlas.getBitmapData('JokerLink${direction}2'));
    tmp.add(textureAtlas.getBitmapData('JokerLink${direction}3'));
    tmp.add(textureAtlas.getBitmapData('JokerLink${direction}4'));
    return tmp;
  }

  static List<BitmapData> getLock(ResourceManager resourceManager, int color) {
    var textureAtlas = resourceManager.getTextureAtlas('Locks');

    var tmp = <BitmapData>[];
    tmp.add(textureAtlas.getBitmapData('Lock${color}0'));
    tmp.add(textureAtlas.getBitmapData('Lock${color}1'));
    tmp.add(textureAtlas.getBitmapData('Lock${color}2'));
    tmp.add(textureAtlas.getBitmapData('Lock${color}3'));
    tmp.add(textureAtlas.getBitmapData('Lock${color}4'));
    return tmp;
  }

  static List<BitmapData> getHeads(ResourceManager resourceManager) {
    var textureAtlas = resourceManager.getTextureAtlas('Head');

    var tmp = <BitmapData>[];
    tmp.add(textureAtlas.getBitmapData('Head1'));
    tmp.add(textureAtlas.getBitmapData('Head2'));
    tmp.add(textureAtlas.getBitmapData('Head3'));
    tmp.add(textureAtlas.getBitmapData('Head2'));
    tmp.add(textureAtlas.getBitmapData('Head1'));
    return tmp;
  }

  static List<BitmapData> getAlarms(ResourceManager resourceManager) {
    var textureAtlas = resourceManager.getTextureAtlas('Alarm');

    var tmp = <BitmapData>[];
    tmp.add(textureAtlas.getBitmapData('Alarm0'));
    tmp.add(textureAtlas.getBitmapData('Alarm1'));
    tmp.add(textureAtlas.getBitmapData('Alarm2'));
    tmp.add(textureAtlas.getBitmapData('Alarm3'));
    tmp.add(textureAtlas.getBitmapData('Alarm4'));
    tmp.add(textureAtlas.getBitmapData('Alarm5'));
    return tmp;
  }
}
