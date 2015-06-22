part of periodic_table;

class PeriodicTable extends DisplayObjectContainer {

  Map elements;
  Map table;

  DisplayObject _detail = null;

  PeriodicTable(this.table, this.elements) {
    _addElementButtons();
    _addCategoryButtons();

    this.onMouseOver.capture(_onMouseOverCapture);
    this.onMouseOut.capture(_onMouseOutCapture);
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  void _addElementButtons() {
    for(var element in this.elements["elements"]) {
      var atomicNumber = element["atomic_number"] as int;
      var groupIndex = _getGroupNumber(atomicNumber) - 1;
      var periodIndex = _getPeriodNumber(atomicNumber) - 1;
      var category = _getCategory(atomicNumber);

      var elementButton = new ElementButton(element, category);
      elementButton.x = 30 + groupIndex * 50 + 25;
      elementButton.y = 10 + periodIndex * 50 + 25;

      if (atomicNumber >= 57 && atomicNumber <= 71) {
        elementButton.x += (atomicNumber - 57)* 50;
        elementButton.y += 2 * 50 + 25;
      }
      if (atomicNumber >= 89 && atomicNumber <= 103) {
        elementButton.x += (atomicNumber - 89)* 50;
        elementButton.y += 2 * 50 + 25;
      }
      addChild(elementButton);
    }
  }

  void _addCategoryButtons() {
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
    for(var group in this.table["groups"]) {
      if (group["elements"].contains(atomicNumber)) return group["number"];
    }
    return -1;
  }

  int _getPeriodNumber(int atomicNumber) {
    for(var period in this.table["periods"]) {
      if (period["elements"].contains(atomicNumber)) return period["number"];
    }
    return -1;
  }

  Map _getCategory(int atomicNumber) {
    for(var category in this.table["categories"]) {
      if (category["elements"].contains(atomicNumber)) return category;
    }
    return null;
  }

  //-----------------------------------------------------------------------------------------------

  void _onMouseOverCapture(MouseEvent event) {
    if (event.target is ElementButton) {
      _onElementButtonMouseOver(event.target);
    }
    if (event.target is CategoryButton) {
      _onCategoryButtonMouseOver(event.target);
    }
  }

  void _onMouseOutCapture(MouseEvent event) {
    if (event.target is ElementButton) {
      _onElementButtonMouseOut(event.target);
    }
    if (event.target is CategoryButton) {
      _onCategoryButtonMouseOut(event.target);
    }
  }

  //-----------------------------------------------------------------------------------------------

  void _onElementButtonMouseOver(ElementButton button) {
    this.addChild(button);
    button.animateTo(0.70, 1.0);

    _detail = new ElementDetail(button.element, button.category);
    _detail.x = 150;
    _detail.y = 10;
    _detail.alpha = 0.0;
    _detail.addTo(this);

    stage.juggler.addTween(_detail, 0.3, Transition.linear)
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

  void _onElementButtonMouseOut(ElementButton button) {
    button.animateTo(0.5, 1.0);

    if (_detail != null) {
      stage.juggler.addTween(_detail, 0.3, Transition.linear)
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

  //-----------------------------------------------------------------------------------------------

  void _onCategoryButtonMouseOver(CategoryButton button) {
    this.addChild(button);
    button.animateTo(0.70, 1.0);

    _detail = new CategoryDetail(button.category);
    _detail.x = 150;
    _detail.y = 10;
    _detail.alpha = 0.0;
    _detail.addTo(this);

    stage.juggler.addTween(_detail, 0.3, Transition.linear)
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

  void _onCategoryButtonMouseOut(CategoryButton button) {
    button.animateTo(0.5, 1.0);

    if (_detail != null) {
      stage.juggler.addTween(_detail, 0.3, Transition.linear)
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
