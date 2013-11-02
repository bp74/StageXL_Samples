part of escape;

class Grafix {

  static Bitmap getChain(ResourceManager resourceManager, int color, int direction) {

    Bitmap bitmap = new Bitmap(resourceManager.getTextureAtlas("Elements").getBitmapData("Chain${color}${direction}"));
    bitmap.pivotX = 25;
    bitmap.pivotY = 25;

    return bitmap;
  }

  //--------------------------------------------------------------------------------------------

  static Bitmap getLink(ResourceManager resourceManager, int color, int direction) {

    Bitmap bitmap = new Bitmap(resourceManager.getTextureAtlas("Elements").getBitmapData("Link${color}${direction}"));
    bitmap.pivotX = 25;
    bitmap.pivotY = 25;

    return bitmap;
  }

  //--------------------------------------------------------------------------------------------

  static Bitmap getWhiteLink(ResourceManager resourceManager, int direction){

    Bitmap bitmap = new Bitmap(resourceManager.getTextureAtlas("Elements").getBitmapData("Link8${direction}"));
    bitmap.pivotX = 25;
    bitmap.pivotY = 25;

    return bitmap;
  }

  //--------------------------------------------------------------------------------------------

  static Bitmap getSpecial(ResourceManager resourceManager, String special) {

    Bitmap bitmap = new Bitmap(resourceManager.getTextureAtlas("Elements").getBitmapData(special));
    bitmap.pivotX = 25;
    bitmap.pivotY = 25;

    return bitmap;
  }

  //--------------------------------------------------------------------------------------------

  static Sprite getLevelUpAnimation(ResourceManager resourceManager, Juggler juggler) {

    Sprite sprite = new Sprite();
    num offset = 0;

    TextureAtlas textureAtlas = resourceManager.getTextureAtlas("Levelup");

    for(int i = 0; i < 7; i++)
    {
      Bitmap bitmap = new Bitmap(textureAtlas.getBitmapData("LevelUp${i}"));
      bitmap.x = - bitmap.width / 2;
      bitmap.y = - bitmap.height / 2;
      //bitmap.filters = [new GlowFilter(0x000000, 0.5, 30, 30)];  // ToDo

      Sprite subSprite = new Sprite();
      subSprite.addChild(bitmap);
      subSprite.x = offset + bitmap.width / 2;
      subSprite.scaleX = 0;
      subSprite.scaleY = 0;

      sprite.addChild(subSprite);

      Tween tween1 = new Tween(subSprite, 2.0, TransitionFunction.easeOutElastic);
      tween1.animate.scaleX.to(1.0);
      tween1.animate.scaleY.to(1.0);
      tween1.delay = i * 0.05;

      Tween tween2 = new Tween(subSprite, 0.4, TransitionFunction.linear);
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

    TextureAtlas textureAtlas = resourceManager.getTextureAtlas("Elements");

    List<BitmapData> tmp = new List<BitmapData>();
    tmp.add(textureAtlas.getBitmapData("JokerChain${direction}0"));
    tmp.add(textureAtlas.getBitmapData("JokerChain${direction}1"));
    tmp.add(textureAtlas.getBitmapData("JokerChain${direction}2"));
    tmp.add(textureAtlas.getBitmapData("JokerChain${direction}3"));
    tmp.add(textureAtlas.getBitmapData("JokerChain${direction}4"));
    return tmp;
  }

  static List<BitmapData> getJokerLink(ResourceManager resourceManager, int direction) {

    TextureAtlas textureAtlas = resourceManager.getTextureAtlas("Elements");

    List<BitmapData> tmp = new List<BitmapData>();
    tmp.add(textureAtlas.getBitmapData("JokerLink${direction}0"));
    tmp.add(textureAtlas.getBitmapData("JokerLink${direction}1"));
    tmp.add(textureAtlas.getBitmapData("JokerLink${direction}2"));
    tmp.add(textureAtlas.getBitmapData("JokerLink${direction}3"));
    tmp.add(textureAtlas.getBitmapData("JokerLink${direction}4"));
    return tmp;
  }

  static List<BitmapData> getLock(ResourceManager resourceManager, int color) {

    TextureAtlas textureAtlas = resourceManager.getTextureAtlas("Locks");

    List<BitmapData> tmp = new List<BitmapData>();
    tmp.add(textureAtlas.getBitmapData("Lock${color}0"));
    tmp.add(textureAtlas.getBitmapData("Lock${color}1"));
    tmp.add(textureAtlas.getBitmapData("Lock${color}2"));
    tmp.add(textureAtlas.getBitmapData("Lock${color}3"));
    tmp.add(textureAtlas.getBitmapData("Lock${color}4"));
    return tmp;
  }

  static List<BitmapData> getHeads(ResourceManager resourceManager) {

    TextureAtlas textureAtlas = resourceManager.getTextureAtlas("Head");

    List<BitmapData> tmp = new List<BitmapData>();
    tmp.add(textureAtlas.getBitmapData("Head1"));
    tmp.add(textureAtlas.getBitmapData("Head2"));
    tmp.add(textureAtlas.getBitmapData("Head3"));
    tmp.add(textureAtlas.getBitmapData("Head2"));
    tmp.add(textureAtlas.getBitmapData("Head1"));
    return tmp;
  }

  static List<BitmapData> getAlarms(ResourceManager resourceManager) {

    TextureAtlas textureAtlas = resourceManager.getTextureAtlas("Alarm");

    List<BitmapData> tmp = new List<BitmapData>();
    tmp.add(textureAtlas.getBitmapData("Alarm0"));
    tmp.add(textureAtlas.getBitmapData("Alarm1"));
    tmp.add(textureAtlas.getBitmapData("Alarm2"));
    tmp.add(textureAtlas.getBitmapData("Alarm3"));
    tmp.add(textureAtlas.getBitmapData("Alarm4"));
    tmp.add(textureAtlas.getBitmapData("Alarm5"));
    return tmp;
  }
}