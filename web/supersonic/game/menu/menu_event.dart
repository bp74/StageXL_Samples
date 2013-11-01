part of supersonic;

class MenuEvent extends Event {

  static const String TYPE_OK = "MenuEvent.TYPE_OK";
  static const String TYPE_CANCEL = "MenuEvent.TYPE_CANCEL";
  static const String TYPE_NEXT = "MenuEvent.TYPE_NEXT";
  static const String TYPE_BACK = "MenuEvent.TYPE_BACK";
  static const String TYPE_ABORT= "MenuEvent.TYPE_ABORT";

  Menu menu;

  MenuEvent(String type, Menu menu, [bool bubbles = false]):super(type, bubbles) {
    this.menu = menu;
  }
}
