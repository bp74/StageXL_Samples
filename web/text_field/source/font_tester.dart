part of text_field;

class FontTester {

  final String fontFamily;
  html.SpanElement _node;
  num _widthWithoutFont;

  FontTester(this.fontFamily, String cssRule, {String textToTest: 'giItT1WQy@!-/#'}) {

    _node = new html.SpanElement()
        ..text = textToTest
        ..style.position = 'absolute'
        ..style.left = '-10000px'
        ..style.top = '-10000px'
        ..style.fontSize = '300px'
        ..style.fontFamily = 'serif'
        ..style.fontStyle = 'normal'
        ..style.fontWeight = '400'
        ..style.fontVariant = 'normal'
        ..style.letterSpacing = '0';

    html.document.body.children.add(_node);

    _widthWithoutFont = _node.offsetWidth;

    html.document.head.children.add(new html.StyleElement()..text = cssRule);

    _node.style.fontFamily = "'${fontFamily}', serif";
  }

  bool get isLoaded => _node.offsetWidth != _widthWithoutFont;

  Future wait(Duration timeout) {

    Completer completer = new Completer();
    DateTime timeoutTime = new DateTime.now().add(timeout);
    Timer timer;

    timer = new Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (isLoaded || timeoutTime.isBefore(new DateTime.now())) {
        timer.cancel();
        completer.complete();
      }
    });

    return completer.future;
  }
}
