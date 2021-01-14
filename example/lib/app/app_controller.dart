import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

part 'app_controller.g.dart';

@Injectable()
class AppController = _AppControllerBase with _$AppController;

abstract class _AppControllerBase with Store {
  BuildContext globalContext;

  @observable
  ThemeMode themeMode = ThemeMode.dark;
  @observable
  Color primaryColor = Color(0xFF139ECC);

  @action
  void getQueryParams(BuildContext context) {
    try {
      final settingsUri = Uri.parse(ModalRoute.of(context).settings.name);
      print(settingsUri.queryParameters);
      if (settingsUri.queryParameters['themeMode'] != null) {
        themeMode = settingsUri.queryParameters['themeMode'] == "dark"
            ? ThemeMode.dark
            : ThemeMode.light;
      }
      if (settingsUri.queryParameters['primaryColor'] != null) {
        primaryColor = Color(
          int.parse("0xFF${settingsUri.queryParameters['primaryColor']}"),
        );
      }
    } catch(e) {
      print("Error: $e");
    }
  }
}
