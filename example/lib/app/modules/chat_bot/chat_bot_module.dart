import 'package:flutter_modular/flutter_modular.dart';

import 'chat_bot_controller.dart';
import 'chat_bot_page.dart';

class ChatBotModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => ChatBotController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          "/:chatBotId",
          child: (_, args) => ChatBotPage(
            chatBotId: args?.params["chatBotId"] ?? "",
          ),
        ),
      ];
}
