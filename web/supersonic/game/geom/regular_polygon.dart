part of supersonic;

class RegularPolygon extends Polygon {

  num _radius;
  int _n;

  RegularPolygon(num radius, int n):super() {

    if (n < 3) n = 3;
    if (radius == 0) radius = 1;

    _radius = radius;
    _n = n;
    _deriveSourcePointList();
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  num get radius => _radius;
  num get n => _n;

  set radius(num value) {
    _radius = value;
    _deriveSourcePointList();
  }

  set n(int value) {
	  _n = value;
    _deriveSourcePointList();
  }

  //-----------------------------------------------------------------------------------------------

	_deriveSourcePointList() {

    var pointList = new List<Vector2D>();
    var angle = 0.0;
    var step = 2 * math.PI / _n;

    for (var i = 0; i < _n; i++) {
		  var v = new Vector2D(0, - _radius);
      v.angleRad = angle;
      pointList.add(v);
      angle += step;
    }

		this.pointList = pointList;
  }
}