part of periodic_table;

class CategoryDetail extends DisplayObjectContainer {
  Map category;

  CategoryDetail(this.category) {
    var name = category["name"];
    var info = category["info"];

    var font = "Open Sans, Helvetica Neue, Helvetica, Arial, sans-serif";
    var nameTextFormat = TextFormat(font, 30, Color.Black, bold: true);
    var infoTextFormat = TextFormat(font, 12, Color.Black);

    var nameTextField = TextField()
      ..defaultTextFormat = nameTextFormat
      ..cacheAsBitmap = false
      ..autoSize = TextFieldAutoSize.LEFT
      ..text = name;

    var infoTextField = TextField()
      ..defaultTextFormat = infoTextFormat
      ..cacheAsBitmap = false
      ..wordWrap = true
      ..multiline = true
      ..y = 40
      ..width = 460
      ..height = 110
      ..text = info;

    addChild(nameTextField);
    addChild(infoTextField);
  }
}
