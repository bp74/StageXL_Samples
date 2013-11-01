part of supersonic;

class Polygon {

  List<Vector2D> pointList;

	Polygon([List<Vector2D> pointList]) {
    this.pointList = (pointList != null) ? pointList : new List();
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  int addPoint(Vector2D p) {
    this.pointList.add( p );
    return this.pointList.length;
  }

  //-----------------------------------------------------------------------------------------------

  removePoint(int i) {
    if ( i < pointList.length) {
		  this.pointList.removeAt(i);
    }
  }

  //-----------------------------------------------------------------------------------------------

  bool hitTest(Vector2D p) {

    var edgeNum = this.pointList.length;
		var j = edgeNum - 1;
    var oddNodes = false;

    for (var i = 0; i < edgeNum; i++) {
      if (pointList[i].y < p.y && pointList[j].y >= p.y || pointList[j].y < p.y && pointList[i].y >= p.y) {
        if (pointList[i].x + (p.y - pointList[i].y) / (pointList[j].y - pointList[i].y) * (pointList[j].x - pointList[i].x) < p.x) {
          oddNodes = !oddNodes;
        }
      }
      j = i;
    }

  	return oddNodes;
  }

  //-----------------------------------------------------------------------------------------------

  Polygon rotate( num angleRad) {

    var edgeNum = this.pointList.length;
    var pointList = new List<Vector2D>(edgeNum);

    for (var i = 0; i < edgeNum; i++) {
		  var p = this.pointList[i].clone();
      p.angleRad += angleRad;
      pointList[i] = p;
    }

		return new Polygon(pointList);
  }

  //-----------------------------------------------------------------------------------------------

  Polygon translate(Vector2D delta) {

    var edgeNum = this.pointList.length;
    var pointList = new List<Vector2D>(edgeNum);

    for (var i = 0; i < edgeNum; i++) {
		  pointList[i] = this.pointList[i].add( delta );
    }

    return new Polygon( pointList );
  }

  //-----------------------------------------------------------------------------------------------

  Polygon scale(num n) {

    if (n == 0) n = double.MIN_POSITIVE;

    var edgeNum = this.pointList.length;
    var pointList = new List<Vector2D>(edgeNum);

    for (var i = 0; i < edgeNum; i++) {
		  var p = this.pointList[i].clone();
      p.scale(n);
			pointList[i] = p;
    }

    return new Polygon( pointList );
	}

  //-----------------------------------------------------------------------------------------------

  Polygon transform(num scalation, num rotation, Vector2D translation) {

	  var edgeNum = this.pointList.length;
    var pointList = new List<Vector2D>(edgeNum);

    for (var i = 0; i < edgeNum; i++) {
		  var p = this.pointList[i].clone();
      p.scale( scalation );
			p.angleRad += rotation;
			pointList[i] = p.add(translation);
    }

    return new Polygon( pointList );
  }
}
