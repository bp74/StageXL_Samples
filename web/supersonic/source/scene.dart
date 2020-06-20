part of supersonic;

class Scene extends Sprite {
  List<PipeObject> pipeObjects;

  Scene() {
    pipeObjects = <PipeObject>[];
  }

  void sortPipeObject() {
    pipeObjects.sort(zSort);
  }

  void addPipeObject(PipeObject obj) {
    if (contains(obj)) return;

    addChild(obj);
    pipeObjects.add(obj);
  }

  void removePipeObject(PipeObject obj) {
    if (pipeObjects.isNotEmpty) {
      var id = pipeObjects.indexOf(obj);
      if (id >= 0) pipeObjects.removeAt(id);
    }

    if (contains(obj)) {
      removeChild(obj);
    }
  }

  int zSort(PipeObject a, PipeObject b) {
    // -1, if a should appear before b in the sorted sequence
    //  0, if a equals b
    //  1, if a should appear after b in the sorted sequence

    if (!contains(a)) {
      return (contains(b) ? 1 : 0);
    }

    if (!contains(b)) {
      return (contains(a) ? -1 : 0);
    }

    if (a.position.z > b.position.z) {
      if (getChildIndex(a) < getChildIndex(b)) {
        swapChildren(a, b);
      } else {
        return 1;
      }
    }

    if (a.position.z < b.position.z) {
      if (getChildIndex(a) > getChildIndex(b)) {
        swapChildren(a, b);
      } else {
        return -1;
      }
    }

    return 0;
  }
}
