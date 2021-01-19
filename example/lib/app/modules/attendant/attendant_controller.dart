import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:omnisaude_chatbot/app/connection/chat_connection.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/src/omnisaude_chatbot.dart';

import '../../app_controller.dart';
import '../../core/constants/constants.dart';

part 'attendant_controller.g.dart';

@Injectable()
class AttendantController = _AttendantControllerBase with _$AttendantController;

abstract class _AttendantControllerBase with Store {
  final AppController appController = Modular.get<AppController>();

  static String _username = USERNAME;
  static String _avatarUrl = AVATAR_URL;

  ChatConnection connection;
  OmnisaudeChatbot omnisaudeChatbot;
  final ScrollController scrollController = ScrollController();

  StreamController streamController;

  @observable
  ConnectionStatus connectionStatus = ConnectionStatus.NONE;
  @observable
  bool chooseUser = true;
  @observable
  String botUsername = "Bot";
  @observable
  bool botTyping = false;
  @observable
  ObservableList<WsMessage> messages = new ObservableList();

  Future<void> onInitAndListenStream(String token) async {
    connection = ChatConnection(
      "$WSS_BASE_URL/ws/attendance/?token=$token",
      _username,
      _avatarUrl,
    );
    omnisaudeChatbot = OmnisaudeChatbot(connection: connection);
    streamController = await connection.onInitSession();
    streamController.stream.listen(
      (message) {
        messages.insert(0, message);
        onScrollListToBottom();
        _onChangeChatGlobalConfigs(message);
        connectionStatus = ConnectionStatus.ACTIVE;
      },
      onError: ((onError) {
        connectionStatus = ConnectionStatus.ERROR;
      }),
      onDone: () {
        connectionStatus = ConnectionStatus.DONE;
      },
    );
  }

  @action
  Future<void> onScrollListToBottom() async {
    if (scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 300)).whenComplete(
        () {
          scrollController.animateTo(
            0.0,
            duration: Duration(milliseconds: 300),
            curve: Curves.decelerate,
          );
        },
      );
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
    messages.clear();
    scrollController.dispose();
    omnisaudeChatbot.dispose();
    streamController.close();
    connection.dispose();
  }
}
