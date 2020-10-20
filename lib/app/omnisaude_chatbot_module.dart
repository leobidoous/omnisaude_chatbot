import 'core/services/view_document_service.dart';
import 'core/services/view_photo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core/services/file_picker_service.dart';
import 'omnisaude_chatbot_widget.dart';
import 'widgets/panel_send_message/panel_send_message_controller.dart';

class OmnisaudeChatbotModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => ViewDocumentService()),
        Bind((i) => ViewPhotoService()),
        Bind((i) => FilePickerService()),
        Bind((i) => PanelSendMessageController()),
      ];

  @override
  List<ModularRouter> get routers => [];

  @override
  Widget get bootstrap => OmnisaudeChatbotWidget();

  static Inject get to => Inject<OmnisaudeChatbotModule>.of();
}
