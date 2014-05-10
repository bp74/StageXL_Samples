part of text_field;

class FontManager {
  final List<Future> _futures = [];

  Future load() {
    return Future.wait(_futures);
  }

  addGoogleFont(String family, [int weight]) {
    _futures.add(Font.loadGoogleFont(family, weight));
  }
}
