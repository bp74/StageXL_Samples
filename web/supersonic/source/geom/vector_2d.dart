part of supersonic;

class Vector2D {
  num x;
  num y;

  Vector2D(this.x, this.y);

  static Vector2D create(num x, num y) {
    return Vector2D(x, y);
  }

  static Vector2D pointToVector(Point p) {
    return Vector2D(p.x, p.y);
  }

  static Point vectorToPoint(Vector2D v) {
    return Point(v.x, v.y);
  }

  static Vector2D cartesianToFlashCoords(Vector2D v) {
    if (v == null) return null;
    return Vector2D(v.x, -v.y);
  }

  set length(num value) {
    this.normalize();
    this.multNum(value);
  }

  num get length {
    return math.sqrt(x * x + y * y);
  }

  void normalize() {
    var mod = this.length;
    if (mod == 0) throw UnsupportedError("divided by 0");
    if (mod == 1) return;
    x /= mod;
    y /= mod;
  }

  void scale(num n) {
    x *= n;
    y *= n;
  }

  Vector2D clone() {
    return Vector2D(x, y);
  }

  Vector2D add(Vector2D v) {
    if (v == null) return null;
    return Vector2D(x + v.x, y + v.y);
  }

  Vector2D subtract(Vector2D v) {
    if (v == null) return null;
    return Vector2D(x - v.x, y - v.y);
  }

  num distance(Vector2D v) {
    return v.subtract(this).length;
  }

  num mult(Vector2D v) {
    return (x * v.x) + (y * v.y);
  }

  void multNum(num value) {
    x *= value;
    y *= value;
  }

  num crossProduct(Vector2D v) {
    return v.y * x - v.x * y;
  }

  Vector2D getLeftNormal() {
    return Vector2D(this.y, -this.x);
  }

  Vector2D getRightNormal() {
    return Vector2D(-this.y, this.x);
  }

  num inverseSkalar(Vector2D v) {
    return (-x * v.x) + (-y * v.y);
  }

  num get angleRad {
    num angle = math.pi - math.atan2(this.x, this.y);
    if (angle < 0) angle += 2 * math.pi;
    return angle;
  }

  set angleRad(num angle) {
    var l = this.length;
    var p = Point.polar(l, angle - math.pi / 2);
    this.x = p.x;
    this.y = p.y;
  }

  num getAngleRadToVector(Vector2D v) {
    return v.angleRad - angleRad;
  }
}
