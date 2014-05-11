part of text_field;

class TextSweet extends DisplayObjectContainer {

  TextSweet() {

    var gradient = new GraphicsGradient.linear(0, 0, 0, 40)
        ..addColorStop(0.0, 0xFFFAD93E)
        ..addColorStop(1.0, 0xFFD2731F);

    var textField = new TextField("Sweet!")
        ..cacheAsBitmap = false
        ..width = 110
        ..height = 45
        ..defaultTextFormat.font = 'Parisienne'
        ..defaultTextFormat.bold = true
        ..defaultTextFormat.size = 32
        ..defaultTextFormat.leftMargin = 8
        ..defaultTextFormat.fillGradient = gradient
        ..defaultTextFormat.strokeColor = 0x4A2209
        ..defaultTextFormat.strokeWidth = 2;

    addChild(textField);
  }
}
