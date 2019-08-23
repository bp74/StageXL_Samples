part of benchmark_startling;

class BenchmarkRenderLoop {

  // This is a special implementation of the [RenderLoop] to achieve
  // frame rates higher than the display refresh rate. This is only
  // useful for benchmarks and should not be used in real world
  // applications.

  final Stopwatch _stopwatch = Stopwatch()..start();
  final List<Stage> _stages = List<Stage>();
  final EnterFrameEvent _enterFrameEvent = EnterFrameEvent(0);
  final ExitFrameEvent _exitFrameEvent = ExitFrameEvent();

  double _deltaTime = 0.0;
  double _currentTime = 0.0;

  BenchmarkRenderLoop() {
    Timer.periodic(Duration(milliseconds: 5), _onTimer);
  }

  void addStage(Stage stage) {
    _stages.add(stage);
  }

  void _onTimer(Timer timer) {

    var elapsedTime = _stopwatch.elapsedMicroseconds / 1000000.0;
    _deltaTime = elapsedTime - _currentTime;
    _currentTime = elapsedTime;

    _enterFrameEvent.passedTime = _deltaTime;
    _enterFrameEvent.dispatch();

    for (var stage in _stages) {
      stage.juggler.advanceTime(_deltaTime);
      stage.materialize(_currentTime, _deltaTime);
    }

    _exitFrameEvent.dispatch();
  }
}
