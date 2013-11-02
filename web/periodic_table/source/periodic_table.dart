part of periodic_table;

class PeriodicTable extends DisplayObjectContainer {

  Map elements;
  Map table;

  PeriodicTable(this.table, this.elements) {

    for(var elementKey in this.elements.keys) {
      var element = this.elements[elementKey];
      var atomicNumber = element["atomic_number"];
      var groupIndex = _getGroupNumber(atomicNumber) - 1;
      var periodIndex = _getPeriodNumber(atomicNumber) - 1;
      var categoryColor = _getCategoryColor(atomicNumber) | 0xFF000000;

      var elementIcon = new ElementIcon(element, categoryColor);
      elementIcon.x = 30 + groupIndex * 50 + 25;
      elementIcon.y = 10 + periodIndex * 50 + 25;

      if (groupIndex == 2 && periodIndex >= 5) {
        elementIcon.y += 2 * 50 + 25;
        if (atomicNumber >= 57 && atomicNumber <= 71) {
          elementIcon.x += (atomicNumber - 57)* 50;
        }
        if (atomicNumber >= 89 && atomicNumber <= 103) {
          elementIcon.x += (atomicNumber - 89)* 50;
        }
      }
      addChild(elementIcon);
    }
  }

  //-----------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------

  int _getGroupNumber(int atomicNumber) {
    for(Map group in this.table["groups"]) {
      if (group["elements"].contains(atomicNumber)) {
        return group["number"];
      }
    }
    return -1;
  }

  int _getPeriodNumber(int atomicNumber) {
    for(Map period in this.table["periods"]) {
      if (period["elements"].contains(atomicNumber)) {
        return period["number"];
      }
    }
    return -1;
  }

  int _getCategoryColor(int atomicNumber) {
    for(Map category in this.table["categories"]) {
      if (category["elements"].contains(atomicNumber)) {
        return int.parse(category["color"], radix: 16);
      }
    }
    return Color.Magenta;
  }

  //-----------------------------------------------------------------------------------------------


}