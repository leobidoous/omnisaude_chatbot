import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_controller.dart';
import 'app_widget.dart';
import 'modules/attendant/attendant_controller.dart';
import 'modules/attendant/attendant_page.dart';
import 'modules/chat_bot/chat_bot_controller.dart';
import 'modules/chat_bot/chat_bot_page.dart';
import 'modules/home/home_module.dart';
import 'modules/video_call/video_call_controller.dart';
import 'modules/video_call/video_call_page.dart';
import 'shared/page_not_found/page_not_found_controller.dart';
import 'shared/page_not_found/page_not_found_page.dart';
import 'shared/shared_module.dart';
import 'shared/widgets/image/image_controller.dart';

class AppModule extends MainModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => PageNotFoundController()),
    Bind.lazySingleton((i) => AppController()),
    Bind.lazySingleton((i) => ImageController()),
    Bind.lazySingleton((i) => AttendantController()),
    Bind.lazySingleton((i) => ChatBotController()),
    Bind.lazySingleton((i) => VideoCallController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
    ChildRoute("/video_call", child: (_, args) => VideoCallPage()),
    ChildRoute("/attendant", child: (_, args) => AttendantPage()),
    ChildRoute(
      "/chat_bot/:chatBotId",
      child: (_, args) => ChatBotPage(
        chatBotId: args.params["chatBotId"],
      ),
    ),
    ModuleRoute("/shared", module: SharedModule()),
    WildcardRoute(child: (BuildContext context, ModularArguments args) {
      return PageNotFoundPage();
    }),
  ];

  @override
  final Widget bootstrap = AppWidget();
}
