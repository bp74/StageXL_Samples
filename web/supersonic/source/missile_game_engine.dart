part of supersonic;

class MissileGameEngine extends GameComponent {

  static num MIN_Z = 0.025;
  static num MAX_Z = 1.0;
  static num Z_POWER = 1.0;

  static int ASSET_SIDELENGTH = 600;

  static int GAME_WIDTH = 800;
  static int GAME_HEIGHT = 600;
  static int GAME_WIDTH_HALF = 400;
  static int GAME_HEIGHT_HALF = 300;

  static num GAME_NEAREST_RADIUS = math.sqrt( GAME_WIDTH * GAME_WIDTH + GAME_HEIGHT * GAME_HEIGHT);
  static num ASSET_SCALE = (GAME_NEAREST_RADIUS * 2 / ASSET_SIDELENGTH);

  static int GAME_NGON_CORNERS = 6;

  //----------------------------------------

  Vector2D center;

  Vector3D nirvana;
  Vector3D nearest;
  RegularPolygon nearestPolygon;

  num pipeRotation = 30.0 * math.PI / 180;
  num pipeRotStep = 1.0 * math.PI / 180;
  num zSpeed = 0.05;

  num pipeObjectRotMin = -1;
  num pipeObjectRotMax = 1;

  Scene scene;
  Bitmap broken; //  : MovieClipLoaderAsset;

  List barrierTypes = ["barrier01", "barrier02", "barrier03", "barrier04", "barrier05","barrier06", "barrier07"];

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
  num mouseX, mouseY;

  GlassPlate glassPlate;
  StreamSubscription<EnterFrameEvent> onEnterFrameSubscription;

  //----------------------------------------

  MissileGameEngine(MissileGame game) : super(game) {

    _mask = new Mask.rectangle(80,60, 690, 524);
    this.mask = _mask;

    this.bgSound = resourceManager.getSound("speedalizer");
    this.bgSoundChannel = this.bgSound.play(true);

    this.tube = new Shape();
    this.addChild(this.tube);

    glassPlate = new GlassPlate(800, 600);
    addChild(glassPlate);

    mouseX = mouseY = 0;
    stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouse);
    stage.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouse);
    stage.addEventListener(MouseEvent.MOUSE_UP, this.onMouse);

    onEnterFrameSubscription = this.onEnterFrame.listen(this._onEnterFrame);
  }

  void onMouse(MouseEvent me) {
    mouseX = me.stageX;
    mouseY = me.stageY;
  }

  void raiseScore() {
    var oldScore = this.game.score;
    this.game.score = oldScore + (this.game as MissileGame).scorePerBarrier * (this.game.level * this.game.lives);
  }

  void onGameSizeChanged(GameEvent event) {
  }

  void onLevelChanged(GameEvent event) {
    super.onLevelChanged( event );
    this.startLevel();
  }

  void startLevel() {

    checkMouseDown = false;
    onEnterFrameSubscription.pause();

    // create pipe - outline - polygon

    this.currentZ = 0;
    this.game.progress = 0;
    this.doZCount = false;

    num nFactor = 60;
    this.nearestPolygon = new RegularPolygon( GAME_NEAREST_RADIUS, GAME_NGON_CORNERS * nFactor );

    for(var p = this.nearestPolygon.pointList.length; p >= 0; p--) {
      if ( p % nFactor != 0 && p % nFactor != 1 ) {
        this.nearestPolygon.removePoint(p);
      }
    }

    // set game params of current level

    this.center = new Vector2D( GAME_WIDTH_HALF, GAME_HEIGHT_HALF);
    this.nirvana = new Vector3D( 0, 0, 0);
    this.nearest = new Vector3D( 0, 0, MAX_Z);

    this.pipeRotStep = (1 + (0.1 * this.game.level)) * math.PI / 180;
    this.zSpeed = 0.015 + (0.004 * this.game.level);
    this.pipeObjectRotMax = 2 + this.game.level;
    this.pipeObjectRotMin = -this.pipeObjectRotMax;

    this.scorePerFrame = this.game.level * 2;

    this.pipeObjectsNum = 15 + (this.game.level);

    // create children

    this.createChildren();
    this.createPipeObjects();
    onEnterFrameSubscription.resume();
  }

  void createChildren() {

    if (this.scene != null) this.removeChild(this.scene);

    this.scene = new Scene();
    this.addChild( this.scene );

    //----------------------------

    if (this.crosshair != null) this.removeChild(this.crosshair);

    this.crosshair = new Bitmap(resourceManager.getTextureAtlas("items").getBitmapData("crosshair"));
    this.crosshair.scaleX = 0.5;
    this.crosshair.scaleY = 0.5;
    this.crosshair.x = (GAME_WIDTH / 2) - this.crosshair.width / 2;
    this.crosshair.y = (GAME_HEIGHT / 2) - this.crosshair.height / 2;
    this.addChild(this.crosshair);
  }

  void flow() {

    this.checkMouseDown = false;
    this.onEnterFrameSubscription.pause();

    // create pipe - outline - polygon

    var nFactor = 60;
    this.nearestPolygon = new RegularPolygon( GAME_NEAREST_RADIUS, GAME_NGON_CORNERS * nFactor );

    for(var p = this.nearestPolygon.pointList.length; p >= 0; p--)
      if ( p % nFactor != 0 && p % nFactor != 1 )
        this.nearestPolygon.removePoint(p);

    // set game params of current level

    this.center = new Vector2D( GAME_WIDTH_HALF, GAME_HEIGHT_HALF);
    this.nirvana = new Vector3D( 0, 0, 0);
    this.nearest = new Vector3D( 0, 0, MAX_Z);

    this.pipeRotStep = 2 * math.PI / 180;
    //this.zSpeed = 0.05;
    this.pipeObjectRotMax = 0;
    this.pipeObjectRotMin = 0;

    // create children

    if (this.scene != null) {
      this.removeChild(this.scene);
      this.scene = null;
    }

    this.scene = new Scene();
    this.addChild( this.scene );

    if (this.broken != null) {
      this.removeChild(this.broken);
      this.broken = null;
    }

    // create dummy pipe slices

    this.createDummySlices();
    this.onEnterFrameSubscription.resume();
  }

  void createDummySlices() {

    // dummy pipe slices

    var pob = new PipeObject( null );
    pob.continued = -1;
    pob.rotStep = 0;
    pob.position = this.nirvana.clone();
    pob.position.z = 0.5;
    this.scene.addPipeObject( pob );
  }

  void createCountdownObjects() {

    var pob = new PipeObject(new Bitmap(resourceManager.getTextureAtlas("items").getBitmapData("countdown01")));
    pob.continued = 0;
    pob.rotStep = 0;
    pob.position = this.nirvana.clone();
    pob.position.z = 0.5;
    pob.countDownId = 0;
    pob.isCountdown = true;
    this.scene.addPipeObject( pob );

    pob = new PipeObject(new Bitmap(resourceManager.getTextureAtlas("items").getBitmapData("countdown02")));
    pob.continued = 0;
    pob.rotStep = 0;
    pob.position = this.nirvana.clone();
    pob.position.z = 0;
    pob.countDownId = 1;
    pob.isCountdown = true;
    this.scene.addPipeObject( pob );

    pob = new PipeObject(new Bitmap(resourceManager.getTextureAtlas("items").getBitmapData("countdown03")));
    pob.continued = 0;
    pob.rotStep = 0;
    pob.position = this.nirvana.clone();
    pob.position.z = -0.5;
    pob.countDownId = 2;
    pob.isCountdown = true;
    this.scene.addPipeObject( pob );

    pob = new PipeObject(new Bitmap(resourceManager.getTextureAtlas("items").getBitmapData("countdown04")));
    pob.continued = 0;
    pob.rotStep = 0;
    pob.position = this.nirvana.clone();
    pob.position.z = -1;
    pob.countDownId = 3;
    pob.isCountdown = true;

    this.scene.addPipeObject( pob );
  }

  PipeObject createRandomBarrier() {

    var maxId = 1 + this.game.level;

    if (maxId >= this.barrierTypes.length)
      maxId = this.barrierTypes.length - 1;

    var rndId = RandomUtils.getIntByRange(0, maxId);
    var type = this.barrierTypes[rndId];

    var pob = new PipeObject(new Bitmap(resourceManager.getBitmapData(type)));
    pob.isBarrier = true;
    pob.rotation = RandomUtils.getIntByRange(0,359) * math.PI / 180;
    pob.rotStep = RandomUtils.getNumberByRange(this.pipeObjectRotMin, this.pipeObjectRotMax) * math.PI / 180;
    pob.position = this.nirvana.clone();

    return pob;
  }

  void createPipeObjects() {

    // create countdown objects
    this.createCountdownObjects();

    // create dummy pipe slices
    this.createDummySlices();

    // create barriers

    var count= 0;
    for (var i = 0; i < pipeObjectsNum; i++) {

      var pob = null;

      if ( i == pipeObjectsNum-1 ) {
        //create finish-object here ...
        pob = new PipeObject(new Bitmap(resourceManager.getBitmapData("finish")));
        pob.rotation = 0;
        pob.rotStep = 5 * math.PI / 180;
        pob.position = this.nirvana.clone();
        pob.continued = 0;
        pob.isBarrier = true;
        pob.isFinish = true;
        this.finishPipeObject = pob;
      } else {
        // create random object here ...
        count ++;
        if (this.game.level == 1 && count <= 3) {
          if (count == 1) {
            pob = new PipeObject(new Bitmap(resourceManager.getBitmapData("training01")));
            pob.isBarrier = true;
            pob.rotation = 0;//RandomUtils.getIntByRange(0,359);
            pob.rotStep = 0;//RandomUtils.getNumberByRange(this.pipeObjectRotMin, this.pipeObjectRotMax);
            pob.position = this.nirvana.clone();
            pob.testObjectId = 1;
          } else if (count == 2) {
            pob = new PipeObject(new Bitmap(resourceManager.getBitmapData("training02")));
            pob.isBarrier = true;
            pob.rotation = 135 * math.PI / 180;//RandomUtils.getIntByRange(0,359);
            pob.rotStep = 0;//RandomUtils.getNumberByRange(this.pipeObjectRotMin, this.pipeObjectRotMax);
            pob.position = this.nirvana.clone();
            pob.testObjectId = 2;
          } else if (count == 3) {
            pob = new PipeObject(new Bitmap(resourceManager.getBitmapData("training02")));
            pob.isBarrier = true;
            pob.rotation = 315 * math.PI / 180;//RandomUtils.getIntByRange(0,359);
            pob.rotStep = 0;//RandomUtils.getNumberByRange(this.pipeObjectRotMin, this.pipeObjectRotMax);
            pob.position = this.nirvana.clone();
            pob.testObjectId = 3;
          }
        } else {
          pob = this.createRandomBarrier();
        }
      }

      pob.originalZ = -i*1 - 3;
      pob.position.z = pob.originalZ;
      pob.continued = 0;
      this.scene.addPipeObject( pob );
    }
  }

  void onLevelFinished() {
    this.doZCount = false;
    var mGame = game as MissileGame;
    mGame.flowEngine();
    mGame.createStartLevelMenu();
  }

  void _onEnterFrame(Event event) {

    if (this.game.paused == false) {
      this.redrawObjects();
      var mGame = this.game as MissileGame;
      if (mGame.trainingsMode && this.checkMouseDown && !mGame.mouseIsDown)
        mGame.onScreenRelease();
    } else {
      lastFrameTime = -1;
    }
  }

  bool hitTest(PipeObject obj) {

    Point localPoint = new Point(this.center.x, this.center.y);
    localPoint = this.localToGlobal( localPoint );
    localPoint = obj.globalToLocal( localPoint );
    return obj.hitTest( localPoint );
  }

  void continueLevel() {

    this.checkMouseDown = false;

    for (var i = 0; i < this.scene.pipeObjects.length; i++) {
      this.scene.pipeObjects[i].position.z -= (2.5 + 1 - accidentZPos) + 1;
    }

    accidentPipeObject.position.z += (1 - accidentZPos);
    this.createCountdownObjects();

    this.doZCount = false;
    this.zSpeed = this.lastSpeed;
    this.broken.visible = false;
  }

  void onAccident() {

    var mGame = this.game as MissileGame;
    mGame.exitButton.visible = false;

    this.doZCount = false;

    this.checkMouseDown = false;

    this.lastSpeed = this.zSpeed;
    this.zSpeed = 0;

    if (this.broken != null) this.removeChild(this.broken);
    this.broken = new Bitmap(resourceManager.getBitmapData("broken"));
    this.addChild(this.broken);

    if ( this.accidentPipeObject.testObjectId > 0 && ++this.freeAccidents <= 5 ) {
      renderJuggler.delayCall(() {
        mGame.createFreeLevelMenu(this.accidentPipeObject.testObjectId);
      }, 2.0);
    } else {
      this.game.lives--;

      if (this.game.lives > 0)
        renderJuggler.delayCall(mGame.createRestartLevelMenu, 2.0);
    }

    this.bgSoundChannel.stop();
    this.bgSoundChannel = this.bgSound.play(true);

    this.crashSound = resourceManager.getSound("crash");
    this.crashSoundChannel = this.crashSound.play();
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
        this.currentZ -= (this.zSpeed * speedFactor);
        var oldScore = this.game.score;
        this.game.score = oldScore + (this.scorePerFrame * speedFactor);
      }

      this.scene.sortPipeObject();

      this.pipeRotation += (this.pipeRotStep * speedFactor);

      this.nearest.x = -(this.mouseX - this.center.x) * 3;
      this.nearest.y = -(this.mouseY - this.center.y) * 3;

      if (this.nearest.getNorm() > GAME_NEAREST_RADIUS * 0.7) {
        this.nearest.setLength(GAME_NEAREST_RADIUS * 0.7);
      }

      this.nearest.z = MAX_Z;

      this.nirvana = this.nearest.clone();
      this.nirvana.z = MIN_Z;

      this.redrawLines();

      for (var i = 0; i < this.scene.pipeObjects.length; i++) {
        var pob = this.scene.pipeObjects[i];

        pob.position.z += (zSpeed * speedFactor);

        if (pob.position.z >= 1) {

          if (pob.isCountdown && pob.countDownId == 3) checkMouseDown = true;

          if (pob.bitmap != null) {
            this.swishSound = resourceManager.getSound("swish");
            this.swishSound.play();
          }

          if (pob.isBarrier) {
            doZCount = true;
          }
          if (pob.originalZ != 0) {
            this.currentZ = pob.originalZ;
          }

          if (pob.isBarrier && hitTest(pob)) {
            pob.position.z = accidentZPos;
            accidentPipeObject = pob;
            this.onAccident();
          } else {
            if (pob.testObjectId == 3) {
              (this.game as MissileGame).trainingsMode = false;
            }
            if (pob.isBarrier) {
              this.raiseScore();
            }
            if (pob.isFinish) {
              this.onLevelFinished();
            } else if (pob.continued == 0) {
              this.scene.removePipeObject( pob );
            } else {
              pob.position.z += pob.continued;
            }
          }
        }

        var pos3D = this.nearest.clone();
        pos3D.z = pob.position.z;

        if ( pos3D.z < 0 || pos3D.z > 1 ) {
          pob.x = 100000; //visible = false;
        } else {
          var pos2D = this.v3DtoV2D( pos3D );
          pos2D = pos2D.add( this.center );
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

      if (this.finishPipeObject != null)
        this.game.progress = (this.currentZ+3) / (this.finishPipeObject.originalZ+3);
  }

  Vector2D v3DtoV2D(Vector3D v) {
    var v2d = new Vector2D( v.x, v.y );
    v2d.x *= zToScaleFactor(v.z);
    v2d.y *= zToScaleFactor(v.z);
    return v2d;
  }

  num zToScaleFactor(num z) {
    var fl = MIN_Z;
    if (z < 0) return 0;
    if (z > 1) return 1;
    return fl / (fl + (1-z));
  }

  void redrawLines() {
    if (tube == null) return;

    var sf = 2;
    var nv = this.nearest.clone();
    nv.scale( sf );

    var nearest_transformed = this.nearestPolygon.transform(
      zToScaleFactor(nv.z) * sf,
      this.pipeRotation,
      this.v3DtoV2D( nv )
    );

    var nirvana_transformed = this.nearestPolygon.transform(
      zToScaleFactor(this.nirvana.z),
      this.pipeRotation,
      this.v3DtoV2D( this.nirvana )
    );

    var lastCirclePos = this.v3DtoV2D( this.nirvana ).add( this.center );

    tube.graphics.clear();

    tube.graphics.beginPath();
    tube.graphics.circle(lastCirclePos.x, lastCirclePos.y, this.nearestPolygon.radius * zToScaleFactor(this.nirvana.z));
    tube.graphics.closePath();
    tube.graphics.strokeColor(0xffcccccc, 1);

    tube.graphics.beginPath();

    for (var i = 0; i < nearest_transformed.pointList.length; i += 2) {
      tube.graphics.moveTo(
        nearest_transformed.pointList[i].x + this.center.x,
        nearest_transformed.pointList[i].y + this.center.y
      );

      tube.graphics.lineTo(
        nearest_transformed.pointList[i+1].x + this.center.x,
        nearest_transformed.pointList[i+1].y + this.center.y
      );

      tube.graphics.lineTo(
        nirvana_transformed.pointList[i+1].x + this.center.x,
        nirvana_transformed.pointList[i+1].y + this.center.y
      );

      tube.graphics.lineTo(
        nirvana_transformed.pointList[i].x + this.center.x,
        nirvana_transformed.pointList[i].y + this.center.y
      );

      tube.graphics.lineTo(
        nearest_transformed.pointList[i].x + this.center.x,
        nearest_transformed.pointList[i].y + this.center.y
      );
    }

    tube.graphics.closePath();
    tube.graphics.fillColor(0xFF000000);
  }
}
