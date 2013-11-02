part of supersonic;

class Scene extends Sprite {

  List<PipeObject> pipeObjects;

  Scene() {
    pipeObjects = new List<PipeObject>();
  }

  void sortPipeObject() {
    this.pipeObjects.sort(zSort);
  }

  void addPipeObject(PipeObject obj) {

    if (this.contains(obj)) return;

    this.addChild( obj );
    this.pipeObjects.add( obj );
  }

  void removePipeObject(PipeObject obj) {

    if (this.pipeObjects.length > 0) {
      var id = this.pipeObjects.indexOf(obj);
      if (id >= 0) this.pipeObjects.removeAt(id);
    }

    if (this.contains(obj)) {
      this.removeChild( obj );
    }
  }

  int zSort(PipeObject a, PipeObject b) {

    // -1, if a should appear before b in the sorted sequence
    //  0, if a equals b
    //  1, if a should appear after b in the sorted sequence

    if (!this.contains(a)) {
      return (this.contains(b) ? 1 : 0);
    }

    if (!this.contains(b)) {
      return (this.contains(a) ? -1 : 0);
    }

    if (a.position.z > b.position.z) {
      if (this.getChildIndex( a ) < this.getChildIndex( b )) {
        this.swapChildren( a, b);
      } else {
        return 1;
      }
    }

    if (a.position.z < b.position.z) {
      if (this.getChildIndex( a ) > this.getChildIndex( b )) {
        this.swapChildren( a, b);
      } else {
        return -1;
      }
    }

    return 0;
  }

}