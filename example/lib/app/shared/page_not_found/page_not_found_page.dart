import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'page_not_found_controller.dart';

class PageNotFoundPage extends StatefulWidget {
  final String title;

  const PageNotFoundPage({Key key, this.title = "PageNotFound"})
      : super(key: key);

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
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              "404 page not found",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
