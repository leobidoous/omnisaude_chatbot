import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_controller.dart';
import 'app_widget.dart';
import 'modules/attendant/attendant_controller.dart';
import 'modules/attendant/attendant_page.dart';
import 'modules/chat_bot/chat_bot_controller.dart';
import 'modules/chat_bot/chat_bot_page.dart';
import 'modules/historic_conversation/historic_conversation_page.dart';
import 'modules/home/home_module.dart';
import 'shared/page_not_found/page_not_found_controller.dart';
import 'shared/page_not_found/page_not_found_page.dart';
import 'shared/widgets/image/image_controller.dart';

class AppModule extends MainModule {
  @override
  final List<Bind> binds = [
    Bind((i) => AppController()),
    Bind.lazySingleton((i) => PageNotFoundController()),
    Bind.lazySingleton((i) => ImageController()),
    Bind.lazySingleton((i) => AttendantController()),
    Bind.lazySingleton((i) => ChatBotController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
    ChildRoute(
      "/attendant/:token",
      child: (_, args) => AttendantPage(token: args.params["token"]),
    ),
    ChildRoute(
      "/chat_bot/:chatBotId",
      child: (_, args) => ChatBotPage(chatBotId: args.params["chatBotId"]),
    ),
    ChildRoute(
      "/historic_conversation/:sessionId",
      child: (_, args) => HistoricConversationPage(
        sessionId: args.params["sessionId"],
      ),
    ),
    WildcardRoute(child: (BuildContext context, ModularArguments args) {
      return PageNotFoundPage();
    }),
  ];

  @override
  final Widget bootstrap = AppWidget();
}
