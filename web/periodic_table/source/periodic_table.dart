part of periodic_table;

class PeriodicTable extends DisplayObjectContainer {

  Map elements;
  Map table;

  ElementDetail _elementDetail = null;

  PeriodicTable(this.table, this.elements) {
    _addElementButtons();
    _addCategorieButtons();

    this.on("ButtonSelected").capture(_onSelectEvent);
    this.on("ButtonDeselected").capture(_onSelectEvent);
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  _addElementButtons() {
    for(var element in this.elements["elements"]) {
      var atomicNumber = element["atomic_number"];
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
    for(var group in this.table["groups"]) {
      if (group["elements"].contains(atomicNumber)) {
        return group["number"];
      }
    }
    return -1;
  }

  int _getPeriodNumber(int atomicNumber) {
    for(var period in this.table["periods"]) {
      if (period["elements"].contains(atomicNumber)) {
        return period["number"];
      }
    }
    return -1;
  }

  Map _getCategory(int atomicNumber) {
    for(var category in this.table["categories"]) {
      if (category["elements"].contains(atomicNumber)) {
        return category;
      }
    }
    return null;
  }

  //-----------------------------------------------------------------------------------------------

  _onSelectEvent(Event event) {
    if (event.target is CategoryButton) {
      _onSelectCategoryButtonEvent(event);
    }
    if (event.target is ElementButton) {
      _onSelectElementButtonEvent(event);
    }
  }

  _onSelectCategoryButtonEvent(Event event) {
    var button = event.target as CategoryButton;
    for(int i = 0; i < this.numChildren; i++) {
      var child = this.getChildAt(i);
      if (child is ElementButton) {
        if (event.type == "ButtonSelected") {
          if (child.category != button.category) {
            child.animateTo(0.5, 0.4);
          } else {
            child.animateTo(0.55, 1.0);
          }
        } else {
          child.animateTo(0.5, 1.0);
        }
      }
    }
  }

  _onSelectElementButtonEvent(Event event) {
    var button = event.target as ElementButton;
    if (event.type == "ButtonSelected") {
      _elementDetail = new ElementDetail(button.element, button.category);
      _elementDetail.x = 150;
      _elementDetail.y = 15;
      _elementDetail.alpha = 0.0;
      _elementDetail.addTo(this);
      stage.juggler.tween(_elementDetail, 0.3, TransitionFunction.linear)
        ..animate.alpha.to(1.0);
    } else {
      if (_elementDetail != null) {
        stage.juggler.tween(_elementDetail, 0.3, TransitionFunction.linear)
          ..animate.alpha.to(0.0)
          ..onComplete = _elementDetail.removeFromParent;
      }
    }
  }

}