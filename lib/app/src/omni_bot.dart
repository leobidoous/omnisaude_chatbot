import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:uuid/uuid.dart';

import 'package:omnisaude_chatbot/app/chatbot/choose_widget_to_render/choose_widget_to_render_widget.dart';
import 'package:omnisaude_chatbot/app/chatbot/panel_send_message/panel_send_message_widget.dart';
import 'package:omnisaude_chatbot/app/connection/chat_connection.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';

class OmniBot extends Disposable {
  final ChatConnection connection;

  OmniBot({@required this.connection}) : assert(connection != null);

  Widget chooseWidgetToRender({WsMessage message, WsMessage lastMessage}) {
    return new ChooseWidgetToRenderWidget(
      key: Key(Uuid().v4()),
      message: message,
      lastMessage: lastMessage,
      connection: connection,
    );
  }

  Widget panelSendMessage({WsMessage lastMessage, bool safeArea: true}) {
    return new PanelSendMessageWidget(
      lastMessage: lastMessage,
      safeArea: safeArea,
      connection: connection,
    );
  }

  @override
  void dispose() {}
}
