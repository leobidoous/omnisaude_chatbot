import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../chatbot/choose_widget_to_render/choose_widget_to_render_widget.dart';
import '../chatbot/panel_send_message/panel_send_message_widget.dart';
import '../connection/connection.dart';
import '../core/models/ws_message_model.dart';

class OmnisaudeChatbot extends Disposable {
  final Connection connection;

  OmnisaudeChatbot({@required this.connection}) : assert(connection != null);

  Widget chooseWidgetToRender({WsMessage message, WsMessage lastMessage}) {
    return ChooseWidgetToRenderWidget(
      message: message,
      lastMessage: lastMessage,
      connection: connection,
    );
  }

  Widget panelSendMessage({WsMessage lastMessage, bool safeArea}) {
    return PanelSendMessageWidget(
      lastMessage: lastMessage,
      connection: connection,
    );
  }

  @override
  void dispose() {
    connection.dispose();
  }
}
