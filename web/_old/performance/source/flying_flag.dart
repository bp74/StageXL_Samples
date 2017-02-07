part of performance;

class FlyingFlag extends Bitmap implements Animatable {

    num vx, vy;

    FlyingFlag(BitmapData bitmapData, this.vx, this.vy) : super(bitmapData) {
      this.pivotX = 24;
      this.pivotY = 24;
    }

    bool advanceTime(num time) {
      var tx = x + vx * time;
      var ty = y + vy * time;
      if (tx > 910 || tx < 30) vx = -vx; else x = tx;
      if (ty > 480 || ty < 20) vy = -vy; else y = ty;
      return true;
    }
}
