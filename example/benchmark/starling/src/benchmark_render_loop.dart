part of benchmark_startling;

class BenchmarkRenderLoop {

  // This is a special implementation of the [RenderLoop] to achieve
  // frame rates higher than the display refresh rate. This is only
  // useful for benchmarks and should not be used in real world
  // applications.

  final Stopwatch _stopwatch = new Stopwatch();
  final List<Stage> _stages = new List<Stage>();
  final EnterFrameEvent _enterFrameEvent = new EnterFrameEvent(0);
  final ExitFrameEvent _exitFrameEvent = new ExitFrameEvent();

  double _currentTime = 0.0;
  double _deltaTime = 0.0;

  BenchmarkRenderLoop() {
    _stopwatch.start();
    new Timer.periodic(new Duration(milliseconds: 1), _onTimer);
  }

  void addStage(Stage stage) {
    _stages.add(stage);
  }

  void _onTimer(Timer timer) {

    _deltaTime = _stopwatch.elapsed.inMicroseconds / 1000000.0;
    _currentTime += _deltaTime;
    _enterFrameEvent.passedTime = _deltaTime;
    _enterFrameEvent.dispatch();
    _stopwatch.reset();

    for (var stage in _stages) {
      stage.juggler.advanceTime(_deltaTime);
      stage.materialize(_currentTime, _deltaTime);
    }

    _exitFrameEvent.dispatch();
  }
}
