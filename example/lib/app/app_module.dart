import 'package:omnisaude_chatbot_example/app/modules/chat/chat_module.dart';
import 'package:omnisaude_chatbot_example/app/modules/video_call/video_call_module.dart';

import 'app_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot_example/app/app_widget.dart';
import 'package:omnisaude_chatbot_example/app/modules/home/home_module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => AppController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, module: HomeModule()),
        ModularRouter("/chat", module: ChatModule()),
        ModularRouter("/video_call", module: VideoCallModule()),
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
