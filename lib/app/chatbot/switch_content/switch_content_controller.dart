import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../connection/chat_connection.dart';
import '../../core/models/message_content_model.dart';
import '../../core/models/option_model.dart';
import '../../core/models/ws_message_model.dart';

class SwitchContentController extends Disposable {
  RxList<Option> selectedOptions = RxList();
  RxList<Option> filteredOptions = RxList();

  Future<void> onSendOptionsMessage(ChatConnection connection) async {
    try {
      final List<String> _options = List<String>.empty(growable: true);
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

  void onSearchIntoOptions(List<Option> options, String filter) {
    filteredOptions.clear();
    options.forEach(
      (Option option) {
        if (option.title.toLowerCase().contains(filter.toLowerCase()) ||
            option.id.toLowerCase().contains(filter)) {
          filteredOptions.add(option);
        }
      },
    );
  }

  @override
  void dispose() {
    selectedOptions.dispose();
    filteredOptions.dispose();
  }
}
