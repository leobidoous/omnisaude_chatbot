import 'package:flutter_modular/flutter_modular.dart';

import 'web_controller.dart';
import 'web_page.dart';

class WebModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => WebController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => WebPage()),
      ];

  static Inject get to => Inject<WebModule>.of();
}
