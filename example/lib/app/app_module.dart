import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_controller.dart';
import 'app_widget.dart';
import 'modules/chat_bot/chat_bot_controller.dart';
import 'modules/chat_bot/chat_bot_page.dart';
import 'modules/home/home_module.dart';
import 'shared/page_not_found/page_not_found_controller.dart';
import 'shared/widgets/image/image_controller.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
    Bind((i) => AppController()),
    Bind((i) => PageNotFoundController()),
    Bind((i) => ImageController()),
    Bind((i) => ChatBotController()),
  ];

  @override
  List<ModularRouter> get routers => [
    ModularRouter(Modular.initialRoute, module: HomeModule()),
    ModularRouter(
      "/chat_bot/:chatBotId",
      child: (_, args) => ChatBotPage(chatBotId: args.params["chatBotId"]),
    ),
  ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
