import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot_example/app/modules/attendant/attendant_module.dart';
import 'package:omnisaude_chatbot_example/app/modules/chat_bot/chat_bot_module.dart';
import 'shared/widgets/image/image_controller.dart';
import 'app_widget.dart';
import 'modules/home/home_module.dart';

import 'app_controller.dart';
import 'shared/page_not_found/page_not_found_controller.dart';
import 'shared/page_not_found/page_not_found_page.dart';
import 'shared/shared_module.dart';

class AppModule extends MainModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => PageNotFoundController()),
    Bind.lazySingleton((i) => AppController()),
    Bind.lazySingleton((i) => ImageController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
    ModuleRoute("/shared", module: SharedModule()),
    ModuleRoute("/chat_bot", module: ChatBotModule()),
    ModuleRoute("/attendant", module: AttendantModule()),
    WildcardRoute(child: (BuildContext context, ModularArguments args) {
      return PageNotFoundPage();
    }),
  ];

  @override
  final Widget bootstrap = AppWidget();
}
