part of supersonic;

class Vector3D {

  num x;
  num y;
  num z;

  Vector3D(this.x, this.y, this.z);

  void reset(num px, num py, num pz) {
    x = px; y = py; z = pz;
  }

  void resetToNegativeInfinity() {
    x = y = z = double.negativeInfinity;
  }

  void resetToPositiveInfinity() {
    x = y = z = double.infinity;
  }

  Vector3D clone() {
    return new Vector3D( x, y, z );
  }

  void copy(Vector3D p) {
    x = p.x;
    y = p.y;
    z = p.z;
  }

  num getNorm() {
    return math.sqrt( x*x + y*y + z*z );
  }

  void setLength(num l) {
    this.normalize();
    this.scale( l );
  }

  Vector3D negate() {
    return new Vector3D( - x, - y, - z );
  }

  Vector3D add(Vector3D v) {
    return new Vector3D(x + v.x, y + v.y, z + v.z);
  }

  Vector3D sub( Vector3D v) {
    return new Vector3D(x - v.x, y - v.y, z - v.z);
  }

  void pow(num exponent) {
    x = math.pow( x, exponent);
    y = math.pow( y, exponent);
    z = math.pow( z, exponent);
  }

  void scale(num n) {
    x *= n;
    y *= n;
    z *= n;
  }

  Vector3D getScaled(num n) {
    var clone  = this.clone();
    clone.x *= n;
    clone.y *= n;
    clone.z *= n;
    return clone;
  }

  num dot(Vector3D w) {
    return ( x * w.x + y * w.y + z * w.z );
  }

  Vector3D cross(Vector3D v) {
    return new Vector3D(
      (y * v.z) - (z * v.y) ,
      (z * v.x) - (x * v.z) ,
      (x * v.y) - (y * v.x)
    );
  }

  void normalize() {
    var norm = getNorm();
    if( norm == 0 || norm == 1) return;

    x /= norm;
    y /= norm;
    z /= norm;
  }

  num getMaxComponent() {
    return math.max( x, math.max( y, z ));
  }

  num getMinComponent() {
    return math.min( x, math.min( y, z ) );
  }

  num getAngle(Vector3D w) {

    var n1 = getNorm();
    var n2 =  w.getNorm();
    var denom = n1 * n2;

    if( denom  == 0 ) {
      return 0;
    } else {
      var ncos = dot( w ) / ( denom );
      var sin2 = 1 - (ncos * ncos);

      if (sin2 < 0)
        sin2 = 0.0;

      return math.atan2(math.sqrt(sin2), ncos);
    }
  }

  bool equals(Vector3D p) {
    return (p.x == x && p.y == y && p.z == z);
  }
}
