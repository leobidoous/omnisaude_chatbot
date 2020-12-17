import 'package:flutter_modular/flutter_modular.dart';

import 'attendant_controller.dart';
import 'attendant_page.dart';

class AttendantModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton((i) => AttendantController()),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          Modular.initialRoute,
          child: (_, args) => AttendantPage(),
        ),
      ];
}
