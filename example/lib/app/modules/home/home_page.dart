import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/shared/stylesheet/app_colors.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  TextEditingController _textController = new TextEditingController(
    text: "b3ffda1c-b321-44b2-aceb-9ebab38a6f2c",
  );
  final ScrollController _scrollController = new ScrollController();
  FocusNode _textFocus = new FocusNode();

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _textFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Início"),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoTextField(
                focusNode: _textFocus,
                controller: _textController,
                placeholder: "Código do chat",
                suffixMode: OverlayVisibilityMode.editing,
                padding: EdgeInsets.all(15.0),
                suffix: IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _textController.clear(),
                  icon: Icon(Icons.close_rounded),
                ),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .color
                      .withOpacity(0.5),
                ),
              ),
              FlatButton(
                onPressed: () {
                  if (_textController.text.trim().isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      '/chat_bot/${_textController.text.trim()}',
                    );
                  }
                },
                color: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                textColor: Colors.white,
                child: Text("Iniciar conversa"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
