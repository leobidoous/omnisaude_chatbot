import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DatetimePickerService extends Disposable {
  Future<DateTime> onShowDateTimePicker(BuildContext context) async {
    final DateTime _now = DateTime.now();
    return await showDatePicker(
      confirmText: "Confirmar",
      cancelText: "Cancelar",
      context: context,
      initialDate: _now,
      firstDate: DateTime(1920),
      lastDate: _now.add(Duration(days: 180)),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            colorScheme: ColorScheme(
              background: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              brightness: Theme.of(context).brightness,
              surface: Theme.of(context).secondaryHeaderColor,
              onSecondary: Theme.of(context).secondaryHeaderColor,
              onSurface: Theme.of(context).textTheme.headline1.color,
              error: Theme.of(context).primaryColor,
              secondaryVariant: Theme.of(context).primaryColor,
              onBackground: Theme.of(context).secondaryHeaderColor,
              secondary: Theme.of(context).backgroundColor,
              primary: Theme.of(context).primaryColor,
              primaryVariant: Theme.of(context).primaryColor,
              onError: Theme.of(context).primaryColor,
            ),
          ),
          child: child,
        );
      },
    );
  }

  @override
  void dispose() {}
}
