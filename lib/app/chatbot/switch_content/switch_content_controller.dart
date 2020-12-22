import 'package:mobx/mobx.dart';
import 'package:omnisaude_chatbot/app/connection/connection.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';

part 'switch_content_controller.g.dart';

class SwitchContentController = _SwitchContentControllerBase
    with _$SwitchContentController;

abstract class _SwitchContentControllerBase with Store {
  @observable
  ObservableList<Option> selectedOptions = ObservableList<Option>();
  @observable
  ObservableList<Option> searchOptions = ObservableList<Option>();
  @observable
  ObservableList<Option> filteredOptions;

  @action
  Future<void> onSendOptionsMessage(Connection connection) async {
    try {
      final List<String> _options = List<String>();
      selectedOptions.forEach((option) => _options.add(option.id));
      final MessageContent _messageContent = MessageContent(
        extras: {"options": _options},
      );
      final WsMessage _message = WsMessage(messageContent: _messageContent);
      await connection.onSendMessage(_message);
      selectedOptions.clear();
    } catch (e) {
      print("erro ao enviar uma option message: $e");
    }
  }

  @action
  Future<void> onSearchIntoOptions(List<Option> options, String filter) async {
    filteredOptions.clear();
    options.forEach(
      (Option option) {
        if (option.title.toLowerCase().contains(filter) ||
            option.id.toLowerCase().contains(filter)) {
          filteredOptions.add(option);
        }
      },
    );
    print("essease: $filteredOptions");
  }
}
