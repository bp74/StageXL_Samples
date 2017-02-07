#Periodic Table

[Try it here][tryit]

---

This is a more advanced StageXL sample and it shows the periodic table of
chemical elements. This sample uses different features of the StageXL library -
mainly vector graphics, display object caching, text fields and animations.

### Initialization

Most of the samples in this GitHub repository are using a fixed size Stage. This
sample uses a Stage that spans the whole browser window and scales it's
DisplayObjects automatically. To get this configuration we have to set some CSS
properties and two properties of the Stage class.

We add this configuration to our stylesheets: 

    body.stage-full-window { margin: 0; padding: 0; overflow: hidden; }
    canvas.stage-full-window { width: 100%; height: 100%; position:fixed; }
  
And this is how we use the Canvas element in HTML:
   
    <body class="stage-full-window">
      <canvas id="stage" class="stage-full-window"></canvas>
 
The Stage class is initialized and the *scaleMode* and *align* properties are
set. To get more detailed information about Stage scaling, please check out this
article: [Scaling the Stage][stagescaling]. In this sample we use a
coordinate system of 960x570 pixels. Please note that this is only the virtual
grid we use for our DisplayObjects and does not necessarily accord with the real
pixels on the screen.

    var canvas = html.querySelector('#stage');
    stage = new Stage(canvas, width: 960, height: 570);
    stage.scaleMode = StageScaleMode.SHOW_ALL;
    stage.align = StageAlign.NONE;

    renderLoop = new RenderLoop();
    renderLoop.addStage(stage);

Next we load two JSON files with the definitions of the periodic table. The
first JSON file (elements.json) contains a list of all 118 elements with
detailed information about each element. The second JSON file (table.json)
contains information how the elements are arranged in groups, periods and
categories. Once the ResourceManager has loaded those two files we create an
instance of PeriodicTable and add it to the Stage.

    resourceManager = new ResourceManager()
      ..addTextFile("table", "data/table.json")
      ..addTextFile("elements", "data/elements.json")
      ..load().then((result) {
        var table = JSON.decode(resourceManager.getTextFile("table"));
        var elements = JSON.decode(resourceManager.getTextFile("elements"));
        var periodicTable = new PeriodicTable(table, elements);
        stage.addChild(periodicTable);
      });

### Class PeriodicTable

The PeriodicTable class is the main class in this sample. It derives from
DisplayObjectContainer and contains all the element and cateogy buttons. It also
controls the animations whenever the user moves the mouse over an element or a
category.

When the user moves the mouse over an element or a category, not only this child
is effected but all the other children too. We use two event listeners to
capture the MouseOver and MouseOut event type to those children.

    PeriodicTable(this.table, this.elements) {
      _addElementButtons();
      _addCategorieButtons();

      this.onMouseOver.capture(_onMouseOverCapture);
      this.onMouseOut.capture(_onMouseOutCapture);
    }

The rest of the class is mostly about controlling the different animations. You
should be familiar with the Juggler framework and the display list in general.
If you need more information about this, please check out the wiki articles on
the StageXL homepage [here][wikiarticles]. Most of the magic is happening in
those four methods:

    _onElementButtonMouseOver(ElementButton button)  
    _onElementButtonMouseOut(ElementButton button)
    _onCategoryButtonMouseOver(CategoryButton button)
    _onCategoryButtonMouseOut(CategoryButton button)

### Class ElementButton

To show those 118 chemical elements of the periodic table we need 118 instances
of the ElementButton class. Therefore the ElementButton class extends the
StageXL Sprite class and adds some children. We use the *graphics* property of
the Sprite class to draw the background of the button in different colors,
according to the category the element belongs too.

    this.graphics.beginPath();
    this.graphics.rectRound(6, 6, 88, 88, 8, 8);
    this.graphics.closePath();
    this.graphics.fillColor(categoryColor);
    this.graphics.strokeColor(Color.Black, 1);

Then we create two TextFields for the periodic number and the symbol of the
chemical element. This TextFields are added as children to the ElementButton
class.

*Note: This is a shortened version of the code. See the full source code for
*more details.

    var numberTextField = new TextField()
      ..autoSize = TextFieldAutoSize.CENTER
      ..text = atomicNumber.toString();

    var symbolTextField = new TextField()
      ..autoSize = TextFieldAutoSize.CENTER
      ..text = symbol;

    addChild(symbolTextField);
    addChild(numberTextField);

The general performance of vector graphics and TextFields are okay, but in this
sample we create 118 instances of the ElementButton - each one contains the
vector graphic background and two TextFields. To improve the performance of this
sample dramatically we use the cache feature of StageXL. We apply a cache to
every ElementButton instance, this way the vector graphics are drawn once and
later a cached bitmap is drawn to the screen. We know that the size of one
ElementButton is 100x100 pixels, so the right thing to do is this:

    applyCache(0, 0, 100, 100);

There is also a method to control the animation of the ElementButton. The actual
animation is triggered from the PeriodicTable class because it's easier to
control all animations in one place. But the actual tweening happens here:

    animateTo(num scale, num alpha) {
      this.stage.juggler.removeTweens(this);
      this.stage.juggler.tween(this, 0.25, TransitionFunction.easeOutQuadratic)
        ..animate.scaleX.to(scale)
        ..animate.scaleY.to(scale)
        ..animate.alpha.to(alpha);
    }

### Class CategoryButton

This class is pretty much the same as the ElementButton class but it is used for
the category buttons on the bottom of the screen. The background is drawn as
vector graphics again and one TextField contains the name of the category. To
make the rendering fast we also apply a cache.

### Class ElementDetail

When the user moves the mouse over a chemical element, we want to show some
details about this element. This details are the full name, atomic number,
atomic weight, atomic radius, density, melding point and bouling point.

We could create one instance of this class and update the details every time we
want to show a new element. But if you look closely you can see that the details
are cross faded from the old element to the new element. Therefore we create a
new instance everytime the user moves the mouse to a new element. Then we use
the Juggler to animate the alpha-property of the old ElementDetail instance to
0.0 and the alpha-property of the new ElementDetail instance to 1.0. This
actually happens in the PeriodicTable class because it's easier to control all
animations in one place.

### Class CategoryDetail

This class is pretty much the same as the ELementDetail class but it is used for
the category details. When the user moves the mouse over a category button, we
show the name of the category and a short explaination.

---

To learn more about Dart and the StageXL library, please follow these links: 

* Dart programming language: <http://www.dartlang.org/>
* StageXL homepage: <http://www.stagexl.org/>
* StageXL on GitHub: <http://www.github.com/bp74/StageXL>


[tryit]: http://www.stagexl.org/samples/periodic_table/
[stagescaling]: http://www.stagexl.org/docs/wiki-articles.html?article=stagescale
[wikiarticles]: http://www.stagexl.org/docs/wiki-articles.html