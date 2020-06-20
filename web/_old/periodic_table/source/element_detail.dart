part of periodic_table;

class ElementDetail extends DisplayObjectContainer {
  Map element;
  Map category;

  ElementDetail(this.element, this.category) {
    var symbol = element['symbol'];
    var name = element['name'];
    var atomicNumber = element['atomic_number'];
    var atomicWeight = element['atomic_weight'];
    var atomicRadius = element['atomic_radius pm'];
    var density = element['density g/cm'];
    var meltingPoint = element['melting_point K'];
    var boilingPoint = element['boiling_point K'];

    var font = 'Open Sans,Helvetica Neue, Helvetica, Arial, sans-serif';
    var nameTextFormat = TextFormat(font, 30, Color.Black, bold: true);

    var nameTextField = TextField()
      ..defaultTextFormat = nameTextFormat
      ..cacheAsBitmap = false
      ..autoSize = TextFieldAutoSize.LEFT
      ..text = '$name ($symbol)';

    addChild(nameTextField);

    _addDataTextField('Atomic Number: $atomicNumber', 20, 44);
    _addDataTextField('Atomic Weight: $atomicWeight', 20, 64);
    _addDataTextField('Atomic Radius: $atomicRadius', 20, 84);
    _addDataTextField('Density g/cm: $density', 20, 104);
    _addDataTextField('Melting Point K: $meltingPoint', 220, 44);
    _addDataTextField('Boiling Point K: $boilingPoint', 220, 64);
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  void _addDataTextField(String text, int x, int y) {
    var font = 'Open Sans, Helvetica Neue, Helvetica, Arial, sans-serif';
    var dataTextFormat = TextFormat(font, 14, Color.Black);

    var dataTextField = TextField()
      ..defaultTextFormat = dataTextFormat
      ..x = x
      ..y = y
      ..cacheAsBitmap = false
      ..autoSize = TextFieldAutoSize.LEFT
      ..text = text;

    addChild(dataTextField);
  }
}
