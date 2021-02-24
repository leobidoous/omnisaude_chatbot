import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/shared/stylesheet/app_colors.dart';

import 'page_not_found_controller.dart';

class PageNotFoundPage extends StatefulWidget {
  const PageNotFoundPage({Key key}) : super(key: key);

  @override
  _PageNotFoundPageState createState() => _PageNotFoundPageState();
}

class _PageNotFoundPageState
    extends ModularState<PageNotFoundPage, PageNotFoundController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Página não encontrada"),
      ),
      backgroundColor: AppColors.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                "404 page not found",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
