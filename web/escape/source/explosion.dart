part of escape;

class ExplosionParticle {
  Bitmap bitmap;
  num startX;
  num startY;
  num angle;
  num velocity;
  num rotation;
}

class Explosion extends Sprite implements Animatable {

  List<ExplosionParticle> _particles;
  num _currentTime;

  Explosion(ResourceManager resourceManager, Juggler juggler, int color, int direction) {

    _particles = List<ExplosionParticle>();
    _currentTime = 0.0;

    this.mouseEnabled = false;

    var chain = Grafix.getChain(resourceManager, color, direction);
    var random = math.Random();

    num angle;
    num velocity;

    for(int y = 0; y <= 1; y++) {
      for(int x = 0; x <= 1; x++) {

        if (x == 0 && y == 0) { angle = math.pi * 1.15; rotation = - math.pi * 2; }
        if (x == 1 && y == 0) { angle = math.pi * 1.85; rotation =   math.pi * 2; }
        if (x == 1 && y == 1) { angle = math.pi * 0.15; rotation =   math.pi * 2; }
        if (x == 0 && y == 1) { angle = math.pi * 0.85; rotation = - math.pi * 2; }

        angle = angle + 0.2 * math.pi * random.nextDouble();
        velocity = 80.0 + 40.0 * random.nextDouble();

        Rectangle rectangle = Rectangle(x * 25, y * 25, 25, 25);
        BitmapData bitmapData = BitmapData.fromBitmapData(chain.bitmapData, rectangle);
        Bitmap bitmap = Bitmap(bitmapData);
        bitmap.pivotX = 12.5;
        bitmap.pivotY = 12.5;
        bitmap.x = x * 25;
        bitmap.y = y * 25;
        addChild(bitmap);

        ExplosionParticle particle = ExplosionParticle();
        particle.bitmap = bitmap;
        particle.startX = x * 25 + 12.5;
        particle.startY = y * 25 + 12.5;
        particle.angle = angle;
        particle.velocity = velocity;
        particle.rotation = rotation;

        _particles.add(particle);
      }
    }
  }

  //----------------------------------------------------------------------------------------------------------

  @override
  bool advanceTime(num time) {

    _currentTime = math.min(0.8, _currentTime + time);

    num gravity = 981.0;

    for(var particle in _particles) {

      var bitmap = particle.bitmap;
      var angle = particle.angle;
      var velocity = particle.velocity;
      var rotation = particle.rotation;
      var posX = particle.startX + _currentTime * (math.cos(angle) * velocity);
      var posY = particle.startY + _currentTime * (math.sin(angle) * velocity + _currentTime * gravity * 0.5);

      bitmap.x = posX;
      bitmap.y = posY;
      bitmap.rotation = _currentTime * rotation;
    }

    if (_currentTime >= 0.6) {
      this.alpha = (0.8 - _currentTime) / 0.2;
    }

    if (_currentTime >= 0.8) {
      this.removeFromParent();
    }

    return (_currentTime < 0.8);
  }

}
