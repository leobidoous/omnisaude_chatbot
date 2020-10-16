import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/connection/mobile_connection.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';
import 'package:omnisaude_chatbot/app/omnisaude_chatbot_controller.dart';
import 'package:omnisaude_chatbot_example/app/core/constants/constants.dart';
import 'package:omnisaude_chatbot_example/app/modules/home/home_controller.dart';

part 'mobile_controller.g.dart';

@Injectable()
class MobileController = _MobileControllerBase with _$MobileController;

abstract class _MobileControllerBase with Store {

  static HomeController homeController = Modular.get<HomeController>();
  static String _username = USERNAME;
  static String _avatarUrl = AVATAR_URL;

  OmnisaudeChatbot omnisaudeChatbot = OmnisaudeChatbot();
  MobileConnection mobileConnection;

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
      mobileConnection = MobileConnection(
        "wss://dev.saudemobi.com/ws/chat/${homeController.chatSelected.id}/",
        _username,
        _avatarUrl,
      );
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
