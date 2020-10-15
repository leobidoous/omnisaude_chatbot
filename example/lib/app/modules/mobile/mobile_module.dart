import 'mobile_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'mobile_page.dart';

class MobileModule extends ChildModule {
  @override
  List<Bind> get binds => [
    Bind((i) => MobileController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => MobilePage()),
      ];

  static Inject get to => Inject<MobileModule>.of();
}
