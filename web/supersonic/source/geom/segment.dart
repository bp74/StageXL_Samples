part of supersonic;

class Segment {
  Vector2D _ps;
  Vector2D _pe;
  Vector2D _dir;

  Segment(Vector2D ps, Vector2D pe) {
    _ps = ps.clone();
    _pe = pe.clone();

    // ensure that line is a line and not a point

    if (_ps.x == _pe.x && _ps.y == _pe.y) {
      _ps.x -= 0.001;
      _ps.y -= 0.001;
      _pe.x += 0.001;
      _pe.y += 0.001;
    }

    // pre calc dir vector

    _dir = Vector2D(_pe.x - _ps.x, _pe.y - _ps.y);
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  Segment clone() {
    return Segment(_ps.clone(), _pe.clone());
  }

  //-----------------------------------------------------------------------------------------------

  Vector2D get ps => _ps.clone();
  Vector2D get pe => _pe.clone();
  Vector2D get dir => _dir.clone();

  set ps(Vector2D v) {
    _ps = v.clone();
    _dir = Vector2D(_pe.x - _ps.x, _pe.y - _ps.y);
  }

  set pe(Vector2D v) {
    _pe = v.clone();
    _dir = Vector2D(_pe.x - _ps.x, _pe.y - _ps.y);
  }

  //-----------------------------------------------------------------------------------------------

  Segment expand(num length, bool right) {
    var tmp_ps, tmp_pe, tmp_dir;

    if (right) {
      tmp_ps = _ps.clone();
      tmp_dir = _dir.clone();
      tmp_dir.length = length;
      tmp_pe = _pe.add(tmp_dir);
    } else {
      tmp_pe = _pe.clone();
      tmp_dir = _dir.clone();
      tmp_dir.length = -length;
      tmp_ps = _ps.add(tmp_dir);
    }

    return Segment(tmp_ps, tmp_pe);
  }

  //-----------------------------------------------------------------------------------------------

  Segment enlarge(num left, num right) {
    var tmpPs, tmpPe, tmpDir;

    tmpPs = _ps.clone();
    tmpPe = _pe.clone();
    tmpDir = _dir.clone();

    tmpDir.length = right;
    tmpPe = _pe.add(tmpDir);

    tmpDir.length = -left;
    tmpPs = _ps.add(tmpDir);

    return Segment(tmpPs, tmpPe);
  }

  //-----------------------------------------------------------------------------------------------

  Segment rotate(num rotation, [Vector2D rotPoint]) {
    var relPs, relPe, ps, pe;

    if (rotPoint == null) {
      ps = this.ps;
    } else {
      relPs = _ps.subtract(rotPoint);
      relPs.angleRad += rotation;
      ps = rotPoint.add(relPs);
    }

    relPe = this.pe.subtract(rotPoint);
    relPe.angleRad += rotation;
    pe = rotPoint.add(relPe);

    return Segment(ps, pe);
  }

  //-----------------------------------------------------------------------------------------------

  Vector2D getProjectionPoint(Vector2D p) {
    var len = _dir.length;
    var r = (((_ps.y - p.y) * (_ps.y - _pe.y)) - ((_ps.x - p.x) * (_pe.x - _ps.x))) / ((len * len));

    return Vector2D(_ps.x + r * (dir.x), _ps.y + r * (dir.y));
  }

  //-----------------------------------------------------------------------------------------------

  Vector2D intersectStraight(Segment s2) {
    var d = ((_dir.x) * (s2._dir.y) - (_dir.y) * (s2._dir.x));
    var r = ((_ps.y - s2._ps.y) * (s2._dir.x) - (_ps.x - s2._ps.x) * (s2._dir.y)) / d;
    //var s = ((_ps.y - s2._ps.y) * (_dir.x) - (_ps.x - s2._ps.x) * (_dir.y)) / d;
    var x = _ps.x + r * _dir.x;
    var y = _ps.y + r * _dir.y;

    return Vector2D(x, y);
  }

  //-----------------------------------------------------------------------------------------------

  Vector2D intersectSegment(Segment s2) {
    var r = ((_ps.y - s2._ps.y) * (s2._dir.x) - (_ps.x - s2._ps.x) * (s2._dir.y)) /
        ((_dir.x) * (s2._dir.y) - (_dir.y) * (s2._dir.x));
    var s = ((_ps.y - s2._ps.y) * (_dir.x) - (_ps.x - s2._ps.x) * (_dir.y)) /
        ((_dir.x) * (s2._dir.y) - (_dir.y) * (s2._dir.x));

    if (r >= 0 && r <= 1 && s >= 0 && s <= 1) {
      var x = _ps.x + r * _dir.x;
      var y = _ps.y + r * _dir.y;
      return Vector2D(x, y);
    }

    return null;
  }
}
