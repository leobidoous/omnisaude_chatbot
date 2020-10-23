enum UploadInputType { GALERY, FILE, CAMERA }
enum SwitchType { HORIZONTAL, SLIDE, VERTICAL }
enum RenderType { LIST, SEARCH }
enum EventType { DEBUG, ERROR, HUMAN_ATTENDANCE, TYPING, SYSTEM, CONNECTED, NLU_START, NLU_END }
enum MessageType { HTML, IMAGE, TEXT }
enum Layout { AVATAR_CARD, BUTTON, CARD, IMAGE_CARD }
enum KeyboardType { DATE, EMAIL, NUMBER, TEXT }
enum InputType { DATE, TEXT }
enum ContentFileType { CUSTOM, IMAGE, PDF, ANY }

final layoutValues = EnumValues({
  "avatar_card": Layout.AVATAR_CARD,
  "button": Layout.BUTTON,
  "card": Layout.CARD,
  "image_card": Layout.IMAGE_CARD
});

final renderTypeValues = EnumValues({
  "list": RenderType.LIST,
  "search": RenderType.SEARCH
});

final messageTypeValues = EnumValues({
  "html": MessageType.HTML,
  "image": MessageType.IMAGE,
  "text": MessageType.TEXT
});

final switchTypeValues = EnumValues({
  "horizontal": SwitchType.HORIZONTAL,
  "slide": SwitchType.SLIDE,
  "vertical": SwitchType.VERTICAL
});

final eventTypeValues = EnumValues({
  "debug": EventType.DEBUG,
  "error": EventType.ERROR,
  "typing": EventType.TYPING,
  "system": EventType.SYSTEM,
  "connected": EventType.CONNECTED,
  "human_attendance": EventType.HUMAN_ATTENDANCE,
  "nlu_start": EventType.NLU_START,
  "nlu_end": EventType.NLU_END
});

final contentFileTypeValues = EnumValues({
  "any": ContentFileType.ANY,
  "custom": ContentFileType.CUSTOM,
  "image": ContentFileType.IMAGE,
  "pdf": ContentFileType.PDF
});

final keyboardTypeValues = EnumValues({
  "date": KeyboardType.DATE,
  "email": KeyboardType.EMAIL,
  "number": KeyboardType.NUMBER,
  "text": KeyboardType.TEXT
});

final inputTypeValues =
    EnumValues({"date": InputType.DATE, "text": InputType.TEXT});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
