#Mask

[Try it here](http://www.stagexl.org/samples/mask/ "StageXL Mask Sample")

---

This is a simple demo showing some flowers and the effect when different masks
are applied. A mask hides the area of a DisplayObject which is outside of the
bounds of the mask. Only the pixels inside of the mask are visible.

The Mask demo uses 3 masks with different shapes. The first two masks are simple
shapes in the form of a rectangle and a circle. The third mask uses a custom
shape which is defined by a list of points - in this example the shape of a
star. You can also create masks with a shape that follows the graphics path of a
StageXL Shape class, but this is outside of the scope of this sample.

If you look at the source code, you see that the sample starts with the
initialization of the StageXL Stage and RenderLoop. Nothing special here. Next
the instances of the masks are created.

    var rectangleMask = new Mask.rectangle(100, 100, 740, 300);
    var circleMask = new Mask.circle(470, 250, 200);
    var customMask = new Mask.custom(starPath);

The HTML of this sample contains 4 buttons. Button 1 removes the mask and
buttons 2 to 4 assigns one of the three masks shown above. When the user clicks
on one of the buttons we assign a new value to the *flowerField.mask* property.

    querySelector('#mask-none').onClick.listen((e) => flowerField.mask = null);
    querySelector('#mask-rectangle').onClick.listen((e) => flowerField.mask = rectangleMask);
    querySelector('#mask-circle').onClick.listen((e) => flowerField.mask = circleMask);
    querySelector('#mask-custom').onClick.listen((e) => flowerField.mask = customMask);

Now we only have to load some nice looking flower images and create a field of
flowers. We use the ResourceManager and a texture atlas which contains the images
of three different flowers. Once the ResourceManager has finished loading we 
create a new instance of FlowerField (see source code).

    resourceManager = new ResourceManager()
      ..addTextureAtlas('flowers', 'images/Flowers.json', TextureAtlasFormat.JSONARRAY)
      ..load().then((_) {
        flowerField = new FlowerField();
        flowerField.x = 470;
        flowerField.y = 250;
        stage.addChild(flowerField);
      });

The sample also shows one additional button labeled with "Spin". If the users
clicks on this button the field of flowers and the mask are rotated around it's
center.

    stage.juggler.tween(flowerField, 2.0, TransitionFunction.easeInOutBack)
      ..animate.rotation.to(math.PI * 4.0)
      ..onComplete = () => flowerField.rotation = 0.0;

---

To learn more about Dart and the StageXL library, please follow these links:

* Dart programming language: <http://www.dartlang.org/>
* StageXL homepage: <http://www.stagexl.org/>
* StageXL on GitHub: <http://www.github.com/bp74/StageXL>

