import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../chatbot_widgets/choose_widget_to_render/choose_widget_to_render_widget.dart';
import '../chatbot_widgets/panel_send_message/panel_send_message_widget.dart';
import '../connection/connection.dart';
import '../core/models/ws_message_model.dart';

class OmnisaudeChatbot extends Disposable {
  final Connection connection;

  OmnisaudeChatbot({@required this.connection}) : assert(connection != null);

  Widget chooseWidgetToRender(WsMessage message) {
    return ChooseWidgetToRenderWidget(message: message, connection: connection);
  }

  Widget panelSendMessage(WsMessage message) {
    if (message == null) message = WsMessage();
    return PanelSendMessageWidget(message: message, connection: connection);
  }

  @override
  void dispose() {
    connection.dispose();
  }
}
