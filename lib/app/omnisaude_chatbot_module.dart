import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'omnisaude_chatbot_widget.dart';

class OmnisaudeChatbotModule extends MainModule {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [];

  @override
  Widget get bootstrap => OmnisaudeChatbotWidget();
}
