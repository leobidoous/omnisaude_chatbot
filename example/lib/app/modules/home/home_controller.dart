import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:omnisaude_chatbot/app/connection/mobile_connection.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/omnisaude_chatbot_controller.dart';
part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  static String _url =
      "wss://dev.saudemobi.com/ws/chat/f507cfbe-e1c0-4143-a4f8-f2f46f4d1564/";
  static String _username = "Test User";
  static String _avatarUrl =
      "https://img.icons8.com/color/2x/user-male-skin-type-4.png";

  OmnisaudeChatbot omnisaudeChatbot = OmnisaudeChatbot();
  final MobileConnection mobileConnection = MobileConnection(
    _url,
    _username,
    _avatarUrl,
  );
  final ScrollController scrollController = ScrollController();

  StreamController streamController;

  @observable
  String botUsername = "Bot";
  @observable
  bool botTyping = false;
  @observable
  ObservableList messages = ObservableList<WsMessage>();

  Future<void> onInitAndListenStream() async {
    try {
      streamController = await mobileConnection.onInitSession();
      streamController.stream.listen((message) {
        messages.add(message);
        _onScrollListToBottom();
        _onChangeChatGlobalConfigs(message);
      });
    } catch (e) {
      print("erro ao inicializar stream: $e");
    }
  }

  @action
  Future<void> _onScrollListToBottom() async {
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
    streamController.close();
    mobileConnection.dispose();
  }

}
