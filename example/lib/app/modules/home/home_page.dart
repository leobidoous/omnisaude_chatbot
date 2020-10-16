import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot_example/app/core/models/bots_model.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title = "Home"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  @override
  void initState() {
    controller.onGetChatBots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(child: _gridChatsContent()),
          _buttonsContent(),
        ],
      ),
    );
  }

  Widget _gridChatsContent() {
    return RefreshIndicator(
      onRefresh: () async => await controller.onGetChatBots(),
      color: Theme.of(context).primaryColor,
      child: Observer(
        builder: (context) {
          if (controller.chatBots.results.isEmpty) return Container();
          return GridView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: ScrollController(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 7.5,
              crossAxisSpacing: 7.5,
            ),
            padding: EdgeInsets.all(7.5),
            itemCount: controller.chatBots.results.length,
            itemBuilder: (BuildContext context, int index) {
              return _gridChatItem(controller.chatBots.results[index]);
            },
          );
        },
      ),
    );
  }

  Widget _gridChatItem(ChatBot chatBot) {
    return Observer(builder: (context) {
      final bool _selected = controller.chatSelected == chatBot;
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color:_selected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
        ),
        child: IconButton(
          onPressed: () {
            controller.chatSelected = chatBot;
          },
          icon: Text(chatBot.name),
        ),
      );
    });
  }

  Widget _buttonsContent() {
    return Observer(
      builder: (context) {
        final _enabled = controller.chatSelected != null;
        print(controller.chatSelected?.toJson());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _flatButton(
              _enabled ? () => Navigator.pushNamed(context, "/mobile") : null,
              "Mobile",
            ),
            _flatButton(
              _enabled ? () => Navigator.pushNamed(context, "/web") : null,
              "Web",
            ),
          ],
        );
      },
    );
  }

  Widget _flatButton(Function onPressed, String label) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7.5, vertical: 5.0),
      child: FlatButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        disabledColor: Theme.of(context).cardColor.withOpacity(0.6),
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 25.0),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.headline1.color,
          ),
        ),
      ),
    );
  }
}
