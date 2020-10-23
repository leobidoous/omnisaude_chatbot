import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/src/omnisaude_chatbot.dart';
import 'package:omnisaude_chatbot_example/app/core/constants/constants.dart';
import 'package:omnisaude_chatbot/app/connection/connection.dart';

part 'chat_controller.g.dart';

@Injectable()
class ChatController = _ChatControllerBase with _$ChatController;

abstract class _ChatControllerBase with Store {
  static String _username = USERNAME;
  static String _avatarUrl = AVATAR_URL;

  Connection connection;
  OmnisaudeChatbot omnisaudeChatbot;
  final ScrollController scrollController = ScrollController();

  StreamController streamController;

  @observable
  String botUsername = "Bot";
  @observable
  bool botTyping = false;
  @observable
  ObservableList messages = ObservableList<WsMessage>();

  Future<void> onInitAndListenStream(String idChat) async {
    try {
      connection = Connection(
        "$WSS_BASE_URL/ws/chat/$idChat/",
        _username,
        _avatarUrl,
      );
      omnisaudeChatbot = OmnisaudeChatbot(connection: connection);
      streamController = await connection.onInitSession();
      streamController.stream.listen((message) {
        messages.add(message);
        onScrollListToBottom();
        _onChangeChatGlobalConfigs(message);
      });
    } catch (e) {
      print("erro ao inicializar stream: $e");
    }
  }

  @action
  Future<void> onScrollListToBottom() async {
    if (scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 300)).whenComplete(() {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.decelerate,
        );
      });
    }
  }

  @action
  Future<void> _onChangeChatGlobalConfigs(WsMessage message) async {
    if (message.eventContent?.eventType == EventType.TYPING)
      botTyping = true;
    else
      botTyping = false;
  }

  void dispose() {
    scrollController.dispose();
    omnisaudeChatbot.dispose();
    streamController.close();
    connection.dispose();
  }
}
