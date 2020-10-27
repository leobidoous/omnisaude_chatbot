import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      navigatorKey: Modular.navigatorKey,
      title: 'Omnisaude - Chatbot Example',
      onGenerateRoute: Modular.generateRoute,
      supportedLocales: [const Locale('pt', 'BR')],
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      // themeMode: ThemeMode.light,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        backgroundColor: Colors.white,
        cardColor: Colors.grey,
        secondaryHeaderColor: Colors.grey.shade300,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        accentColor: Colors.deepOrange,
        fontFamily: "Helvetica Neue",
        textTheme: TextTheme(
          headline4: TextStyle(color: Colors.grey.shade300),
          headline5: TextStyle(color: Colors.grey.shade100),
          headline6: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        primaryColor: Colors.deepOrange,
        cardColor: Colors.grey.shade800,
        secondaryHeaderColor: Colors.grey.shade900,
        highlightColor: Colors.transparent,
        accentColor: Colors.deepOrange,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: "Helvetica Neue",
        textTheme: TextTheme(
          headline4: TextStyle(color: Colors.grey.shade900),
          headline5: TextStyle(color: Colors.grey.shade800),
          headline6: TextStyle(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
