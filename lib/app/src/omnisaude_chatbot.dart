import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';

import '../chatbot/choose_widget_to_render/choose_widget_to_render_widget.dart';
import '../chatbot/panel_send_message/panel_send_message_widget.dart';
import '../connection/chat_connection.dart';
import '../core/models/ws_message_model.dart';

class OmnisaudeChatbot extends Disposable {
  final ChatConnection connection;

  OmnisaudeChatbot({@required this.connection}) : assert(connection != null);

  Widget chooseWidgetToRender({
    WsMessage message,
    WsMessage lastMessage,
    MessageViewMode messageViewMode: MessageViewMode.ME,
  }) {
    return ChooseWidgetToRenderWidget(
      message: message,
      lastMessage: lastMessage,
      messageViewMode: messageViewMode,
      connection: connection,
    );
  }

  Widget panelSendMessage({WsMessage message}) {
    return PanelSendMessageWidget(
      message: message,
      connection: connection,
    );
  }

  @override
  void dispose() {
  }
}
