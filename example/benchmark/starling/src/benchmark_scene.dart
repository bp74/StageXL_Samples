part of benchmark_startling;

class BenchmarkScene extends Sprite implements Animatable {

  // The implementation of the benchmark scene is slightly different to
  // the one of Starling. Since StageXL is capable of rendering much more
  // Bitmaps per frame, we need to add Bitmaps faster and scale down old
  // Bitmaps less aggressive compared to the original benchmark.

  final int targetFrameRate;
  final BitmapData bitmapData;

  final Random _random = new Random();
  final BitmapContainer _container = new BitmapContainer();
  final html.Element _counterElement = html.querySelector("#counter");

  num _averageFrameRate = 60.0;
  num _deltaToggleSign = 0;
  int _deltaToggleCount = 0;

  BenchmarkScene(this.bitmapData, this.targetFrameRate) {
    _container.x = 320 / 2;
    _container.y = 480 / 2;
    _container.addTo(this);
  }

  bool advanceTime(num time) {

    _averageFrameRate = 0.05 / time + 0.95 * _averageFrameRate;

    var children = _container.children;
    var childCount = max(1, children.length);
    var deltaCount = (_averageFrameRate / targetFrameRate - 1.0) * childCount;
    var speedCount = min(50, pow(deltaCount.abs().ceil(), 0.30));
    var scale = pow(0.99, childCount / 512);

    _container.rotation += time * 0.5;
    _container.scaleX = _container.scaleY = scale;

    // add a few bitmaps

    if (deltaCount > 0) {
      for(int i = 0; i < speedCount; i++) {
        var bitmap = new Bitmap(bitmapData);
        var bitmapScale = 1.0 / scale;
        var angle  = _random.nextDouble() * PI * 2.0;
        var distance = (50 + _random.nextInt(150)) * bitmapScale;
        bitmap.x = cos(angle) * distance;
        bitmap.y = sin(angle) * distance;
        bitmap.pivotX = bitmapData.width / 2.0;
        bitmap.pivotY = bitmapData.height / 2.0;
        bitmap.rotation = angle + PI / 2.0;
        bitmap.scaleX = bitmap.scaleY = bitmapScale;
        children.add(bitmap);
      }
    }

    // remove a few bitmaps

    if (deltaCount < 0) {
      speedCount = min(speedCount, children.length);
      for(int i = 0; i < speedCount; i++) {
        children.removeLast();
      }
    }

    // check for steady state

    _counterElement.text = children.length.toString();

    if (_deltaToggleSign != deltaCount.sign) {
      _deltaToggleSign = deltaCount.sign;
      _deltaToggleCount += 1;
    }

    if (_deltaToggleCount >= 10) {
      _container.removeFromParent();
      _benchmarkComplete();
      return false;
    } else {
      return true;
    }
  }

  void _benchmarkComplete() {

    var numChildren = _container.numChildren;
    var targetFps = this.targetFrameRate;
    var resultText = new TextField();
    var textFormat = new TextFormat("Arial, Helvetica", 30, Color.Black);

    resultText.width = 240;
    resultText.height = 200;
    resultText.text = "Result:\n$numChildren objects\nwith $targetFps fps";
    resultText.defaultTextFormat = textFormat;
    resultText.x = 160 -  resultText.width / 2;
    resultText.y = 240 -  resultText.height / 2;
    addChild(resultText);
  }
}

