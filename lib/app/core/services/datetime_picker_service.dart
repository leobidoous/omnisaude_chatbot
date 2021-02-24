import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/shared/stylesheet/app_colors.dart';

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
              background: AppColors.primary,
              onPrimary: Colors.white,
              brightness: Theme.of(context).brightness,
              surface: Theme.of(context).secondaryHeaderColor,
              onSecondary: Theme.of(context).secondaryHeaderColor,
              onSurface: Theme.of(context).textTheme.headline1.color,
              error: AppColors.primary,
              secondaryVariant: AppColors.primary,
              onBackground: Theme.of(context).secondaryHeaderColor,
              secondary: AppColors.background,
              primary: AppColors.primary,
              primaryVariant: AppColors.primary,
              onError: AppColors.primary,
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
