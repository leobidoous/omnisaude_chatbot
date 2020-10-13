import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:omnisaude_chatbot/app/widgets/choose_widget_to_render/choose_widget_to_render_widget.dart';
import 'package:omnisaude_chatbot/app/widgets/panel_send_message/panel_send_message_widget.dart';

import 'core/models/ws_message_model.dart';

part 'omnisaude_chatbot_controller.g.dart';

class OmnisaudeChatbot = _OmnisaudeChatbotControllerBase
    with _$OmnisaudeChatbot;

abstract class _OmnisaudeChatbotControllerBase with Store {
  Widget chooseWidgetToRender(
    WsMessage message,
    String userPeer,
    bool isLastMessage,
  ) {
    return ChooseWidgetToRenderWidget(
      message: message,
      userPeer: userPeer,
      isLastMessage: isLastMessage,
    );
  }

  Widget panelSendMessage(
    WsMessage message,
    Future<void> Function(WsMessage) onSendMessage,
  ) {
    if (message == null) message = WsMessage();
    return PanelSendMessageWidget(
      message: message,
      onSendMessage: onSendMessage,
    );
  }
}
