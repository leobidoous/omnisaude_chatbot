import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot_example/app/app_controller.dart';

// class AppWidget extends StatefulWidget {
//   @override
//   _AppWidgetState createState() => _AppWidgetState();
// }
//
// class _AppWidgetState extends ModularState<AppWidget, AppController> {
//
//   @override
//   Widget build(BuildContext context) {
// return Observer(
//     builder: (context) {
//           return MaterialApp(
//             initialRoute: Modular.initialRoute,
//             debugShowCheckedModeBanner: false,
//             title: 'Omnisaude - Chatbot Example',
//             supportedLocales: [const Locale('pt', 'BR')],
//             localizationsDelegates: [
//               GlobalCupertinoLocalizations.delegate,
//               GlobalMaterialLocalizations.delegate,
//               GlobalWidgetsLocalizations.delegate,
//             ],
//             themeMode: store.themeMode,
//             theme: ThemeData(
//               primaryColor: store.primaryColor,
//               backgroundColor: Colors.white,
//               cardColor: Colors.grey,
//               secondaryHeaderColor: Colors.grey.shade300,
//               splashColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//               hoverColor: Colors.transparent,
//               accentColor: store.primaryColor,
//               fontFamily: "Helvetica Neue",
//               textTheme: TextTheme(
//                 headline4: TextStyle(color: Colors.grey.shade300),
//                 headline5: TextStyle(color: Colors.grey.shade100),
//                 headline6: TextStyle(color: Colors.black),
//               ),
//             ),
//             darkTheme: ThemeData(
//               primaryColor: store.primaryColor,
//               brightness: Brightness.dark,
//               backgroundColor: Colors.black,
//               cardColor: Colors.grey.shade800,
//               secondaryHeaderColor: Colors.grey.shade900,
//               highlightColor: Colors.transparent,
//               accentColor: store.primaryColor,
//               splashColor: Colors.transparent,
//               hoverColor: Colors.transparent,
//               fontFamily: "Helvetica Neue",
//               textTheme: TextTheme(
//                 headline4: TextStyle(color: Colors.grey.shade900),
//                 headline5: TextStyle(color: Colors.grey.shade800),
//                 headline6: TextStyle(color: Colors.grey.shade300),
//               ),
//             ),
//           ).modular();
// }
// );
//   }
// }

class AppWidget extends StatelessWidget {
  final AppController store = AppController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Modular.initialRoute,
      debugShowCheckedModeBanner: false,
      title: 'Omnisaude - Chatbot Example',
      supportedLocales: [const Locale('pt', 'BR')],
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      themeMode: store.themeMode,
      theme: ThemeData(
        primaryColor: store.primaryColor,
        backgroundColor: Colors.white,
        cardColor: Colors.grey,
        secondaryHeaderColor: Colors.grey.shade300,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        accentColor: store.primaryColor,
        fontFamily: "Helvetica Neue",
        textTheme: TextTheme(
          headline4: TextStyle(color: Colors.grey.shade300),
          headline5: TextStyle(color: Colors.grey.shade100),
          headline6: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        primaryColor: store.primaryColor,
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        cardColor: Colors.grey.shade800,
        secondaryHeaderColor: Colors.grey.shade900,
        highlightColor: Colors.transparent,
        accentColor: store.primaryColor,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: "Helvetica Neue",
        textTheme: TextTheme(
          headline4: TextStyle(color: Colors.grey.shade900),
          headline5: TextStyle(color: Colors.grey.shade800),
          headline6: TextStyle(color: Colors.grey.shade300),
        ),
      ),
    ).modular();
  }
}
