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
    normalize();
    multNum(value);
  }

  num get length {
    return math.sqrt(x * x + y * y);
  }

  void normalize() {
    var mod = length;
    if (mod == 0) throw UnsupportedError('divided by 0');
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
    return Vector2D(y, -x);
  }

  Vector2D getRightNormal() {
    return Vector2D(-y, x);
  }

  num inverseSkalar(Vector2D v) {
    return (-x * v.x) + (-y * v.y);
  }

  num get angleRad {
    num angle = math.pi - math.atan2(x, y);
    if (angle < 0) angle += 2 * math.pi;
    return angle;
  }

  set angleRad(num angle) {
    var l = length;
    var p = Point.polar(l, angle - math.pi / 2);
    x = p.x;
    y = p.y;
  }

  num getAngleRadToVector(Vector2D v) {
    return v.angleRad - angleRad;
  }
}
