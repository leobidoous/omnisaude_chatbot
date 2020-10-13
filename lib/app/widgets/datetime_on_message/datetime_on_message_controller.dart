import 'package:mobx/mobx.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';

part 'datetime_on_message_controller.g.dart';

class DatetimeOnMessageController = _DatetimeOnMessageControllerBase
    with _$DatetimeOnMessageController;

abstract class _DatetimeOnMessageControllerBase with Store {

  bool oShowMessageDateTimeContent(WsMessage message) {
    // int _countMessages = _chatbotController.countMessages;
    // if (_countMessages > 1) {
    //   final int _indexOf = _chatbotController.messages.indexOf(message);
    //   if (_indexOf + 1 == _countMessages) return true;
    //   final WsMessage _next = _chatbotController.messages[_indexOf + 1];
    //
    //   final DateTime _nextDate = DateTime.parse(_next.datetime).toLocal();
    //   final DateTime _date = DateTime.parse(message.datetime).toLocal();
    //
    //   final int _diff = _date.difference(_nextDate).inSeconds;
    //
    //   if (message.peer == _next.peer && _diff < 1) {
    //     if (_next.inputContent != null) {
    //       return true;
    //     } else {
    //       return false;
    //     }
    //   } else {
    //     return true;
    //   }
    // } else {
    //   return false;
    // }
    return true;
  }
}
