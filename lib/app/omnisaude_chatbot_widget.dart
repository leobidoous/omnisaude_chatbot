import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class OmnisaudeChatbotWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Modular.navigatorKey,
      title: 'Omnisaude - Chatbot Package',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [const Locale('pt', 'BR')],
      themeMode:ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFFfd6347),
        primaryColorDark: Color(0xFF7e3123),
        primaryColorLight: Color(0xFFfd826b),
        fontFamily: "Helvetica Neue",
        accentColor: Colors.white,
        backgroundColor: Colors.white,
        cardColor: Colors.grey.shade200,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontFamily: "Helvetica Neue",
            color: Colors.black,
            fontSize: 14.0,
          ),
          headline1: TextStyle(
            fontFamily: "Helvetica Neue",
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFfd6347),
        primaryColorDark: Color(0xFF7e3123),
        primaryColorLight: Color(0xFFfd826b),
        fontFamily: "Helvetica Neue",
        accentColor: Colors.black45,
        backgroundColor: Colors.black,
        cardColor: Colors.grey.shade900,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontFamily: "Helvetica Neue",
            color: Colors.white,
            fontSize: 14.0,
          ),
          headline1: TextStyle(
            fontFamily: "Helvetica Neue",
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20.0,
          ),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: Modular.generateRoute,
    );
  }
}
