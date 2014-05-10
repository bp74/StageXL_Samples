part of text_field;

class TextSweet extends DisplayObjectContainer {

  TextSweet() {

    var gradient = new GraphicsGradient.linear(0, 0, 0, 160)
        ..addColorStop(0.0, 0xFFFAD93E)
        ..addColorStop(1.0, 0xFFD2731F);

    var textField = new TextField(" Sweet!")
        ..width = 530
        ..height = 220
        ..defaultTextFormat.font = 'Parisienne'
        ..defaultTextFormat.bold = true
        ..defaultTextFormat.size = 160
        ..defaultTextFormat.fillGradient = gradient
        ..defaultTextFormat.strokeColor = 0x4A2209
        ..defaultTextFormat.strokeWidth = 10;

    addChild(textField);
  }
}
