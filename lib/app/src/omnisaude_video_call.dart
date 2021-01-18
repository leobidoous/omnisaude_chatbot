import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../chatbot/choose_widget_to_render/choose_widget_to_render_widget.dart';
import '../connection/connection.dart';
import '../core/models/ws_message_model.dart';

class OmnisaudeVideoCall extends Disposable {
  final Connection connection;

  OmnisaudeVideoCall({@required this.connection}) : assert(connection != null);

  Widget initVideoCall(WsMessage message) {
    return ChooseWidgetToRenderWidget(message: message, connection: connection);
  }

  @override
  void dispose() {
    connection.dispose();
  }
}
