import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/connection/chat_connection.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/src/omnisaude_chatbot.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'historic_conversation_repository.dart';

class HistoricConversationController extends Disposable {
  final RxList<WsMessage> messages = RxList(List.empty(growable: true));
  RxNotifier<ConnectionStatus> connectionStatus =
      RxNotifier(ConnectionStatus.NONE);
  final HistoricConversationRepository _repository =
      new HistoricConversationRepository();

  static final ChatConnection connection = ChatConnection();
  final OmnisaudeChatbot omnisaudeChatbot = OmnisaudeChatbot(
    connection: connection,
  );

  Future<dynamic> getHistoricConversation(
      {String sessionId, String token}) async {
    try {
      connectionStatus.value = ConnectionStatus.WAITING;
      connection.setUserPeer(sessionId);
      final List _messages = await _repository.getHistoricConversation(
        sessionId: sessionId,
        token: token,
      );
      messages.clear();
      _messages.reversed.forEach((element) {
        messages.add(element);
      });
      connectionStatus.value = ConnectionStatus.ACTIVE;
    } on DioError catch (e) {
      connectionStatus.value = ConnectionStatus.ERROR;
    }
  }

  @override
  void dispose() {
    messages.dispose();
    connectionStatus.dispose();
  }
}
