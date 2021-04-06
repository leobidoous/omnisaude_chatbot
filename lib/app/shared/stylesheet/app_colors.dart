import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppColors {
  static BuildContext _context = Modular.navigatorKey.currentContext;

  static Color get background {
    return Theme.of(_context).backgroundColor;
  }

  static Color get primary {
    return Theme.of(_context).primaryColor;
  }

  static Color get textColor {
    return Theme.of(_context).textTheme.bodyText1.color;
  }

  static Color get textColorInverted {
    return Theme.of(_context).textTheme.bodyText2.color;
  }

  static Color get card {
    return Theme.of(_context).cardColor;
  }

  static Color get header {
    return Theme.of(_context).secondaryHeaderColor;
  }
}
