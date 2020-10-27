import 'package:mobx/mobx.dart';
import 'package:omnisaude_chatbot/app/connection/connection.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';

part 'switch_content_controller.g.dart';

class SwitchContentController = _SwitchContentControllerBase
    with _$SwitchContentController;

abstract class _SwitchContentControllerBase with Store {
  @observable
  ObservableList<Option> optionsSelecteds = ObservableList<Option>();
  @observable
  ObservableList<Option> searchOptions = ObservableList<Option>();

  @action
  Future<void> onSendOptionsMessage(Connection connection) async {
    try {
      final List<String> _options = List<String>();
      optionsSelecteds.forEach((option) => _options.add(option.id));
      final MessageContent _messageContent = MessageContent(
        extras: {"options": _options},
      );
      final WsMessage _message = WsMessage(messageContent: _messageContent);
      await connection.onSendMessage(_message);
      optionsSelecteds.clear();
    } catch (e) {
      print("erro ao enviar uma option message: $e");
    }
  }
}
