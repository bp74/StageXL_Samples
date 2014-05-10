part of text_field;

class Font {

  static const Duration _DEFAULT_TIME_OUT = const Duration(seconds: 10);
  final String family;

  Font._(this.family);

  static Future<Font> loadGoogleFont(String family, [int weight]) {

    var url = 'http://fonts.googleapis.com/css?family=${Uri.encodeComponent(family)}';
    if (weight != null) url += ':$weight';

    var tester = new FontTester(family, "@import url('$url');");
    return tester.wait(_DEFAULT_TIME_OUT).then((_) => new Font._(family));
  }
}
