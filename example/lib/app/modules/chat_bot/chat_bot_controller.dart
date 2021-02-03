import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/connection/chat_connection.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/src/omni_bot.dart';
import 'package:omnisaude_chatbot/app/src/omni_video_call.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../../app_controller.dart';
import '../../core/constants/constants.dart';

class ChatBotController extends Disposable {
  final AppController appController = Modular.get<AppController>();

  final OmnisaudeVideoCall omnisaudeVideoCall = new OmnisaudeVideoCall();

  static String _username = USERNAME;
  static String _avatarUrl = AVATAR_URL;

  ChatConnection connection;
  OmniBot omnisaudeChatbot;

  StreamController streamController;
  StreamSubscription _streamSubscription;

  RxNotifier<ConnectionStatus> connectionStatus = new RxNotifier(
    ConnectionStatus.NONE,
  );
  RxNotifier<String> botUsername = new RxNotifier("Bot");
  RxNotifier<bool> botTyping = new RxNotifier(false);
  RxList<WsMessage> messages = new RxList(List());

  Future<void> onInitAndListenStream(String idChat) async {
    connectionStatus.value = ConnectionStatus.WAITING;
    connection = ChatConnection(
      url: "$WSS_BASE_URL/ws/chat/$idChat/",
      username: _username,
      avatarUrl: _avatarUrl,
    );
    omnisaudeChatbot = OmniBot(connection: connection);
    streamController = await connection.onInitSession();
    messages.clear();
    _streamSubscription = streamController.stream.listen(
      (message) async {
        _streamSubscription.pause();
        messages.insert(0, message);
        if (message.eventContent?.eventType == EventType.AUTHENTICATION) {
          await connection.authenticate(
            cpf: "123.123.123.12",
            username: "Leonardo",
            token: "12312312312",
            metadata: {"teste": "teste"},
          );
        }
        _onChangeChatGlobalConfigs(message);
        connectionStatus.value = ConnectionStatus.ACTIVE;
        _streamSubscription.resume();
      },
      onError: ((onError) {
        connectionStatus.value = ConnectionStatus.ERROR;
      }),
      onDone: () {
        connectionStatus.value = ConnectionStatus.DONE;
      },
      cancelOnError: true,
    );
  }

  Future<void> _onChangeChatGlobalConfigs(WsMessage message) async {
    if (message.eventContent?.eventType == EventType.TYPING)
      botTyping.value = true;
    else
      botTyping.value = false;
  }

  @override
  void dispose() async {
    streamController?.close();
    await _streamSubscription?.cancel();
    connection.dispose();
  }
}
