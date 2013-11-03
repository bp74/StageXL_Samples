part of periodic_table;

class CategoryDetail extends DisplayObjectContainer {

  Map category;

  CategoryDetail(this.category) {

    var name = category["name"];
    var info = category["info"];

    var font =  "Open Sans, Helvetica Neue, Helvetica, Arial, sans-serif";
    var nameTextFormat = new TextFormat(font, 30, Color.Black, bold:true);
    var infoTextFormat = new TextFormat(font, 12, Color.Black);

    var nameTextField = new TextField()
      ..defaultTextFormat = nameTextFormat
      ..cacheAsBitmap = false
      ..autoSize = TextFieldAutoSize.LEFT
      ..text = name;

    var infoTextField = new TextField()
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