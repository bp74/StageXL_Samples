part of periodic_table;

class PeriodicTable extends DisplayObjectContainer {

  Map elements;
  Map table;

  DisplayObject _detail = null;
  Juggler _juggler = stage.juggler;

  PeriodicTable(this.table, this.elements) {
    _addElementButtons();
    _addCategorieButtons();

    this.onMouseOver.capture(_onMouseOverCapture);
    this.onMouseOut.capture(_onMouseOutCapture);
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  _addElementButtons() {
    for(var element in this.elements["elements"]) {
      var atomicNumber = element["atomic_number"] as int;
      var groupIndex = _getGroupNumber(atomicNumber) - 1;
      var periodIndex = _getPeriodNumber(atomicNumber) - 1;
      var category = _getCategory(atomicNumber);

      var elementButton = new ElementButton(element, category);
      elementButton.x = 30 + groupIndex * 50 + 25;
      elementButton.y = 10 + periodIndex * 50 + 25;

      if (groupIndex == 2 && periodIndex >= 5) {
        elementButton.y += 2 * 50 + 25;
        if (atomicNumber >= 57 && atomicNumber <= 71) {
          elementButton.x += (atomicNumber - 57)* 50;
        }
        if (atomicNumber >= 89 && atomicNumber <= 103) {
          elementButton.x += (atomicNumber - 89)* 50;
        }
      }
      addChild(elementButton);
    }
  }

  _addCategorieButtons() {
    var x = 0;
    for(var category in this.table["categories"]) {
      var categoryButton = new CategoryButton(category);
      categoryButton.x = 80 + x;
      categoryButton.y = 530;
      x += 80;
      addChild(categoryButton);
    }
  }

  //-----------------------------------------------------------------------------------------------

  int _getGroupNumber(int atomicNumber) {
    for(var group in this.table["groups"])
      if (group["elements"].contains(atomicNumber))
        return group["number"];
  }

  int _getPeriodNumber(int atomicNumber) {
    for(var period in this.table["periods"])
      if (period["elements"].contains(atomicNumber))
        return period["number"];
  }

  Map _getCategory(int atomicNumber) {
    for(var category in this.table["categories"])
      if (category["elements"].contains(atomicNumber))
        return category;
  }

  //-----------------------------------------------------------------------------------------------

  _onMouseOverCapture(MouseEvent event) {
    if (event.target is ElementButton) {
      _onMouseOverElementButton(event);
    }
    if (event.target is CategoryButton) {
      _onMouseOverCategoryButton(event);
    }
  }

  _onMouseOutCapture(MouseEvent event) {
    if (event.target is ElementButton) {
      _onMouseOutElementButton(event);
    }
    if (event.target is CategoryButton) {
      _onMouseOutCategoryButton(event);
    }
  }

  _onMouseOverElementButton(MouseEvent event) {
    ElementButton button = event.target;
    this.addChild(button);
    button.animateTo(0.70, 1.0);

    _detail = new ElementDetail(button.element, button.category);
    _detail.x = 150;
    _detail.y = 10;
    _detail.alpha = 0.0;
    _detail.addTo(this);

    _juggler.tween(_detail, 0.3, TransitionFunction.linear)
      ..animate.alpha.to(1.0);

    for(int i = 0; i < this.numChildren; i++) {
      var child = this.getChildAt(i);
      if (child is CategoryButton) {
        if (identical(child.category, button.category)) {
          child.animateTo(0.55, 1.0);
        } else {
          child.animateTo(0.50, 0.4);
        }
      }
    }
  }

  _onMouseOutElementButton(MouseEvent event) {
    ElementButton button = event.target;
    button.animateTo(0.5, 1.0);

    if (_detail != null) {
      _juggler.tween(_detail, 0.3, TransitionFunction.linear)
        ..animate.alpha.to(0.0)
        ..onComplete = _detail.removeFromParent;
      _detail = null;
    }

    for(int i = 0; i < this.numChildren; i++) {
      var child = this.getChildAt(i);
      if (child is CategoryButton) {
        child.animateTo(0.50, 1.0);
      }
    }
  }

  _onMouseOverCategoryButton(MouseEvent event) {
    CategoryButton button = event.target;
    this.addChild(button);
    button.animateTo(0.70, 1.0);

    _detail = new CategoryDetail(button.category);
    _detail.x = 150;
    _detail.y = 10;
    _detail.alpha = 0.0;
    _detail.addTo(this);

    _juggler.tween(_detail, 0.3, TransitionFunction.linear)
      ..animate.alpha.to(1.0);

    for(int i = 0; i < this.numChildren; i++) {
      var child = this.getChildAt(i);
      if (child is ElementButton) {
        if (identical(child.category, button.category)) {
          child.animateTo(0.55, 1.0);
        } else {
          child.animateTo(0.5, 0.4);
        }
      }
    }
  }

  _onMouseOutCategoryButton(MouseEvent event) {
    CategoryButton button = event.target;
    button.animateTo(0.5, 1.0);

    if (_detail != null) {
      _juggler.tween(_detail, 0.3, TransitionFunction.linear)
        ..animate.alpha.to(0.0)
        ..onComplete = _detail.removeFromParent;
      _detail = null;
    }

    for(int i = 0; i < this.numChildren; i++) {
      var child = this.getChildAt(i);
      if (child is ElementButton) {
        child.animateTo(0.5, 1.0);
      }
    }
  }

}