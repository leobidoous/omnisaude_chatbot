import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DatetimePickerService extends Disposable {
  Future<void> onShowDateTimePicker(BuildContext context) async {

    await DatePicker.showDatePicker(context, );

  }

  @override
  void dispose() {}
}
