import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: Modular.initialRoute,
      navigatorKey: Modular.navigatorKey,
      onGenerateRoute: Modular.generateRoute,
      debugShowCheckedModeBanner: false,
      title: 'Omnisaude - Chatbot Example',
      supportedLocales: [const Locale('pt', 'BR')],
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      themeMode: ThemeMode.dark,
      // themeMode: ThemeMode.light,
      theme: ThemeData(
        backgroundColor: Colors.white,
        cardColor: Colors.grey.shade300,
        splashColor: Colors.transparent,
        secondaryHeaderColor: Colors.grey,
        highlightColor: Colors.transparent,
        accentColor: Color(0xFF139ECC),
        primaryColor: Color(0xFF139ECC),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.white),
          headline4: TextStyle(color: Colors.grey.shade300),
          headline5: TextStyle(color: Colors.grey.shade100),
          headline6: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        backgroundColor: Colors.black,
        cardColor: Colors.grey.shade800,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        secondaryHeaderColor: Colors.grey.shade800,
        accentColor: Color(0xFF139ECC),
        primaryColor: Color(0xFF139ECC),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.black),
          headline4: TextStyle(color: Colors.grey.shade900),
          headline5: TextStyle(color: Colors.grey.shade800),
          headline6: TextStyle(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
