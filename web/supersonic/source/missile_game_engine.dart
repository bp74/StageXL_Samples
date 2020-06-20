part of supersonic;

class MissileGameEngine extends GameComponent {
  static final num MIN_Z = 0.025;
  static final num MAX_Z = 1.0;
  static final num Z_POWER = 1.0;

  static final int ASSET_SIDELENGTH = 600;

  static final int GAME_WIDTH = 800;
  static final int GAME_HEIGHT = 600;
  static final int GAME_WIDTH_HALF = 400;
  static final int GAME_HEIGHT_HALF = 300;

  static final num GAME_NEAREST_RADIUS =
      math.sqrt(GAME_WIDTH * GAME_WIDTH + GAME_HEIGHT * GAME_HEIGHT);
  static final num ASSET_SCALE = (GAME_NEAREST_RADIUS * 2 / ASSET_SIDELENGTH);

  static final int GAME_NGON_CORNERS = 6;

  //----------------------------------------

  Vector2D center;

  Vector3D nirvana;
  Vector3D nearest;
  RegularPolygon nearestPolygon;

  num pipeRotation = 30.0 * math.pi / 180;
  num pipeRotStep = 1.0 * math.pi / 180;
  num zSpeed = 0.05;

  num pipeObjectRotMin = -1;
  num pipeObjectRotMax = 1;

  Scene scene;
  Bitmap broken; //  : MovieClipLoaderAsset;

  List barrierTypes = [
    'barrier01',
    'barrier02',
    'barrier03',
    'barrier04',
    'barrier05',
    'barrier06',
    'barrier07'
  ];

  Sound bgSound;
  SoundChannel bgSoundChannel;

  Sound crashSound;
  SoundChannel crashSoundChannel;

  Sound swishSound;

  int pipeObjectsNum = 15;

  num lastSpeed;

  bool doZCount = false;
  num currentZ = 0;

  PipeObject finishPipeObject;
  PipeObject accidentPipeObject;

  num accidentZPos = 0.90;
  num scorePerFrame = 0;

  Mask _mask;

  Bitmap bgBitmap;
  Shape tube;

  int freeAccidents = 0;

  Bitmap crosshair;

  bool checkMouseDown = false;

  @override
  num mouseX;

  @override
  num mouseY;

  GlassPlate glassPlate;
  StreamSubscription<EnterFrameEvent> onEnterFrameSubscription;

  //----------------------------------------

  MissileGameEngine(MissileGame game) : super(game) {
    _mask = Mask.rectangle(80, 60, 690, 524);
    mask = _mask;

    bgSound = resourceManager.getSound('speedalizer');
    bgSoundChannel = bgSound.play(true);

    tube = Shape();
    addChild(tube);

    glassPlate = GlassPlate(800, 600);
    addChild(glassPlate);

    mouseX = mouseY = 0;
    stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouse);
    stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
    stage.addEventListener(MouseEvent.MOUSE_UP, onMouse);

    onEnterFrameSubscription = onEnterFrame.listen(_onEnterFrame);
  }

  void onMouse(MouseEvent me) {
    mouseX = me.stageX;
    mouseY = me.stageY;
  }

  void raiseScore() {
    var oldScore = game.score;
    game.score = oldScore + (game as MissileGame).scorePerBarrier * (game.level * game.lives);
  }

  @override
  void onGameSizeChanged(GameEvent event) {}

  @override
  void onLevelChanged(GameEvent event) {
    super.onLevelChanged(event);
    startLevel();
  }

  void startLevel() {
    checkMouseDown = false;
    onEnterFrameSubscription.pause();

    // create pipe - outline - polygon

    currentZ = 0;
    game.progress = 0;
    doZCount = false;

    num nFactor = 60;
    nearestPolygon = RegularPolygon(GAME_NEAREST_RADIUS, GAME_NGON_CORNERS * nFactor);

    for (var p = nearestPolygon.pointList.length; p >= 0; p--) {
      if (p % nFactor != 0 && p % nFactor != 1) {
        nearestPolygon.removePoint(p);
      }
    }

    // set game params of current level

    center = Vector2D(GAME_WIDTH_HALF, GAME_HEIGHT_HALF);
    nirvana = Vector3D(0, 0, 0);
    nearest = Vector3D(0, 0, MAX_Z);

    pipeRotStep = (1 + (0.1 * game.level)) * math.pi / 180;
    zSpeed = 0.015 + (0.004 * game.level);
    pipeObjectRotMax = 2 + game.level;
    pipeObjectRotMin = -pipeObjectRotMax;

    scorePerFrame = game.level * 2;

    pipeObjectsNum = 15 + (game.level);

    // create children

    createChildren();
    createPipeObjects();
    onEnterFrameSubscription.resume();
  }

  void createChildren() {
    if (scene != null) removeChild(scene);

    scene = Scene();
    addChild(scene);

    //----------------------------

    if (crosshair != null) removeChild(crosshair);

    crosshair = Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('crosshair'));
    crosshair.scaleX = 0.5;
    crosshair.scaleY = 0.5;
    crosshair.x = (GAME_WIDTH / 2) - crosshair.width / 2;
    crosshair.y = (GAME_HEIGHT / 2) - crosshair.height / 2;
    addChild(crosshair);
  }

  void flow() {
    checkMouseDown = false;
    onEnterFrameSubscription.pause();

    // create pipe - outline - polygon

    var nFactor = 60;
    nearestPolygon = RegularPolygon(GAME_NEAREST_RADIUS, GAME_NGON_CORNERS * nFactor);

    for (var p = nearestPolygon.pointList.length; p >= 0; p--) {
      if (p % nFactor != 0 && p % nFactor != 1) {
        nearestPolygon.removePoint(p);
      }
    }

    // set game params of current level

    center = Vector2D(GAME_WIDTH_HALF, GAME_HEIGHT_HALF);
    nirvana = Vector3D(0, 0, 0);
    nearest = Vector3D(0, 0, MAX_Z);

    pipeRotStep = 2 * math.pi / 180;
    //zSpeed = 0.05;
    pipeObjectRotMax = 0;
    pipeObjectRotMin = 0;

    // create children

    if (scene != null) {
      removeChild(scene);
      scene = null;
    }

    scene = Scene();
    addChild(scene);

    if (broken != null) {
      removeChild(broken);
      broken = null;
    }

    // create dummy pipe slices

    createDummySlices();
    onEnterFrameSubscription.resume();
  }

  void createDummySlices() {
    // dummy pipe slices

    var pob = PipeObject(null);
    pob.continued = -1;
    pob.rotStep = 0;
    pob.position = nirvana.clone();
    pob.position.z = 0.5;
    scene.addPipeObject(pob);
  }

  void createCountdownObjects() {
    var pob =
        PipeObject(Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('countdown01')));
    pob.continued = 0;
    pob.rotStep = 0;
    pob.position = nirvana.clone();
    pob.position.z = 0.5;
    pob.countDownId = 0;
    pob.isCountdown = true;
    scene.addPipeObject(pob);

    pob = PipeObject(Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('countdown02')));
    pob.continued = 0;
    pob.rotStep = 0;
    pob.position = nirvana.clone();
    pob.position.z = 0;
    pob.countDownId = 1;
    pob.isCountdown = true;
    scene.addPipeObject(pob);

    pob = PipeObject(Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('countdown03')));
    pob.continued = 0;
    pob.rotStep = 0;
    pob.position = nirvana.clone();
    pob.position.z = -0.5;
    pob.countDownId = 2;
    pob.isCountdown = true;
    scene.addPipeObject(pob);

    pob = PipeObject(Bitmap(resourceManager.getTextureAtlas('items').getBitmapData('countdown04')));
    pob.continued = 0;
    pob.rotStep = 0;
    pob.position = nirvana.clone();
    pob.position.z = -1;
    pob.countDownId = 3;
    pob.isCountdown = true;

    scene.addPipeObject(pob);
  }

  PipeObject createRandomBarrier() {
    var maxId = 1 + game.level;

    if (maxId >= barrierTypes.length) {
      maxId = barrierTypes.length - 1;
    }

    var rndId = RandomUtils.getIntByRange(0, maxId);
    var type = barrierTypes[rndId];

    var pob = PipeObject(Bitmap(resourceManager.getBitmapData(type)));
    pob.isBarrier = true;
    pob.rotation = RandomUtils.getIntByRange(0, 359) * math.pi / 180;
    pob.rotStep =
        RandomUtils.getNumberByRange(pipeObjectRotMin, pipeObjectRotMax) * math.pi / 180;
    pob.position = nirvana.clone();

    return pob;
  }

  void createPipeObjects() {
    // create countdown objects
    createCountdownObjects();

    // create dummy pipe slices
    createDummySlices();

    // create barriers

    var count = 0;
    for (var i = 0; i < pipeObjectsNum; i++) {
      PipeObject pob;

      if (i == pipeObjectsNum - 1) {
        //create finish-object here ...
        pob = PipeObject(Bitmap(resourceManager.getBitmapData('finish')));
        pob.rotation = 0;
        pob.rotStep = 5 * math.pi / 180;
        pob.position = nirvana.clone();
        pob.continued = 0;
        pob.isBarrier = true;
        pob.isFinish = true;
        finishPipeObject = pob;
      } else {
        // create random object here ...
        count++;
        if (game.level == 1 && count <= 3) {
          if (count == 1) {
            pob = PipeObject(Bitmap(resourceManager.getBitmapData('training01')));
            pob.isBarrier = true;
            pob.rotation = 0; //RandomUtils.getIntByRange(0,359);
            pob.rotStep =
                0; //RandomUtils.getNumberByRange(this.pipeObjectRotMin, this.pipeObjectRotMax);
            pob.position = nirvana.clone();
            pob.testObjectId = 1;
          } else if (count == 2) {
            pob = PipeObject(Bitmap(resourceManager.getBitmapData('training02')));
            pob.isBarrier = true;
            pob.rotation = 135 * math.pi / 180; //RandomUtils.getIntByRange(0,359);
            pob.rotStep =
                0; //RandomUtils.getNumberByRange(this.pipeObjectRotMin, this.pipeObjectRotMax);
            pob.position = nirvana.clone();
            pob.testObjectId = 2;
          } else if (count == 3) {
            pob = PipeObject(Bitmap(resourceManager.getBitmapData('training02')));
            pob.isBarrier = true;
            pob.rotation = 315 * math.pi / 180; //RandomUtils.getIntByRange(0,359);
            pob.rotStep =
                0; //RandomUtils.getNumberByRange(this.pipeObjectRotMin, this.pipeObjectRotMax);
            pob.position = nirvana.clone();
            pob.testObjectId = 3;
          }
        } else {
          pob = createRandomBarrier();
        }
      }

      pob.originalZ = -i * 1 - 3;
      pob.position.z = pob.originalZ;
      pob.continued = 0;
      scene.addPipeObject(pob);
    }
  }

  void onLevelFinished() {
    doZCount = false;
    var mGame = game as MissileGame;
    mGame.flowEngine();
    mGame.createStartLevelMenu();
  }

  void _onEnterFrame(Event event) {
    if (game.paused == false) {
      redrawObjects();
      var mGame = game as MissileGame;
      if (mGame.trainingsMode && checkMouseDown && !mGame.mouseIsDown) {
        mGame.onScreenRelease();
      }
    } else {
      lastFrameTime = -1;
    }
  }

  bool hitTest(PipeObject obj) {
    var localPoint = Point(center.x, center.y);
    localPoint = localToGlobal(localPoint);
    localPoint = obj.globalToLocal(localPoint);
    return obj.hitTest(localPoint);
  }

  void continueLevel() {
    checkMouseDown = false;

    for (var i = 0; i < scene.pipeObjects.length; i++) {
      scene.pipeObjects[i].position.z -= (2.5 + 1 - accidentZPos) + 1;
    }

    accidentPipeObject.position.z += (1 - accidentZPos);
    createCountdownObjects();

    doZCount = false;
    zSpeed = lastSpeed;
    broken.visible = false;
  }

  void onAccident() {
    var mGame = game as MissileGame;
    mGame.exitButton.visible = false;

    doZCount = false;

    checkMouseDown = false;

    lastSpeed = zSpeed;
    zSpeed = 0;

    if (broken != null) removeChild(broken);
    broken = Bitmap(resourceManager.getBitmapData('broken'));
    addChild(broken);

    if (accidentPipeObject.testObjectId > 0 && ++freeAccidents <= 5) {
      renderJuggler.delayCall(() {
        mGame.createFreeLevelMenu(accidentPipeObject.testObjectId);
      }, 2.0);
    } else {
      game.lives--;

      if (game.lives > 0) {
        renderJuggler.delayCall(mGame.createRestartLevelMenu, 2.0);
      }
    }

    bgSoundChannel.stop();
    bgSoundChannel = bgSound.play(true);

    crashSound = resourceManager.getSound('crash');
    crashSoundChannel = crashSound.play();
  }

  num lastFrameTime = -1;

  void redrawObjects() {
    var time = renderJuggler.elapsedTime;
    var speedFactor = 1.0;

    if (lastFrameTime == -1) lastFrameTime = time;

    // this game was originally designed to run with 40 fps
    speedFactor = math.min(time - lastFrameTime, 1.0000) * 40;
    lastFrameTime = time;

    //------------------------------------------------------------------

    if (doZCount) {
      currentZ -= (zSpeed * speedFactor);
      var oldScore = game.score;
      game.score = oldScore + (scorePerFrame * speedFactor);
    }

    scene.sortPipeObject();

    pipeRotation += (pipeRotStep * speedFactor);

    nearest.x = -(mouseX - center.x) * 3;
    nearest.y = -(mouseY - center.y) * 3;

    if (nearest.getNorm() > GAME_NEAREST_RADIUS * 0.7) {
      nearest.setLength(GAME_NEAREST_RADIUS * 0.7);
    }

    nearest.z = MAX_Z;

    nirvana = nearest.clone();
    nirvana.z = MIN_Z;

    redrawLines();

    for (var i = 0; i < scene.pipeObjects.length; i++) {
      var pob = scene.pipeObjects[i];

      pob.position.z += (zSpeed * speedFactor);

      if (pob.position.z >= 1) {
        if (pob.isCountdown && pob.countDownId == 3) checkMouseDown = true;

        if (pob.bitmap != null) {
          swishSound = resourceManager.getSound('swish');
          swishSound.play();
        }

        if (pob.isBarrier) {
          doZCount = true;
        }
        if (pob.originalZ != 0) {
          currentZ = pob.originalZ;
        }

        if (pob.isBarrier && hitTest(pob)) {
          pob.position.z = accidentZPos;
          accidentPipeObject = pob;
          onAccident();
        } else {
          if (pob.testObjectId == 3) {
            (game as MissileGame).trainingsMode = false;
          }
          if (pob.isBarrier) {
            raiseScore();
          }
          if (pob.isFinish) {
            onLevelFinished();
          } else if (pob.continued == 0) {
            scene.removePipeObject(pob);
          } else {
            pob.position.z += pob.continued;
          }
        }
      }

      var pos3D = nearest.clone();
      pos3D.z = pob.position.z;

      if (pos3D.z < 0 || pos3D.z > 1) {
        pob.x = 100000; //visible = false;
      } else {
        var pos2D = v3DtoV2D(pos3D);
        pos2D = pos2D.add(center);
        //pob.visible = true;
        var alpha = (20 * (pos3D.z * pos3D.z));
        if (alpha > 1) alpha = 1;

        pob.alpha = alpha;
        pob.x = pos2D.x;
        pob.y = pos2D.y;
        pob.rotation += (pob.rotStep * speedFactor);
        pob.setScale(zToScaleFactor(pob.position.z) * ASSET_SCALE);
        //pob.bitmap.scaleX = pob.bitmap.scaleY = sf;
      }
    }

    if (finishPipeObject != null) {
      game.progress = (currentZ + 3) / (finishPipeObject.originalZ + 3);
    }
  }

  Vector2D v3DtoV2D(Vector3D v) {
    var v2d = Vector2D(v.x, v.y);
    v2d.x *= zToScaleFactor(v.z);
    v2d.y *= zToScaleFactor(v.z);
    return v2d;
  }

  num zToScaleFactor(num z) {
    var fl = MIN_Z;
    if (z < 0) return 0;
    if (z > 1) return 1;
    return fl / (fl + (1 - z));
  }

  void redrawLines() {
    if (tube == null) return;

    var sf = 2;
    var nv = nearest.clone();
    nv.scale(sf);

    var nearest_transformed = nearestPolygon
        .transform(zToScaleFactor(nv.z) * sf, pipeRotation, v3DtoV2D(nv));

    var nirvana_transformed = nearestPolygon
        .transform(zToScaleFactor(nirvana.z), pipeRotation, v3DtoV2D(nirvana));

    var lastCirclePos = v3DtoV2D(nirvana).add(center);

    tube.graphics.clear();

    tube.graphics.beginPath();
    tube.graphics.circle(
        lastCirclePos.x, lastCirclePos.y,
        nearestPolygon.radius * zToScaleFactor(nirvana.z));
    tube.graphics.closePath();
    tube.graphics.strokeColor(0xffcccccc, 1);

    tube.graphics.beginPath();

    for (var i = 0; i < nearest_transformed.pointList.length; i += 2) {
      tube.graphics.moveTo(nearest_transformed.pointList[i].x + center.x,
          nearest_transformed.pointList[i].y + center.y);

      tube.graphics.lineTo(nearest_transformed.pointList[i + 1].x + center.x,
          nearest_transformed.pointList[i + 1].y + center.y);

      tube.graphics.lineTo(nirvana_transformed.pointList[i + 1].x + center.x,
          nirvana_transformed.pointList[i + 1].y + center.y);

      tube.graphics.lineTo(nirvana_transformed.pointList[i].x + center.x,
          nirvana_transformed.pointList[i].y + center.y);

      tube.graphics.lineTo(nearest_transformed.pointList[i].x + center.x,
          nearest_transformed.pointList[i].y + center.y);
    }

    tube.graphics.closePath();
    tube.graphics.fillColor(0xFF000000);
  }
}
