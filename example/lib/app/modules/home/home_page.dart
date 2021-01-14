import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot_example/app/core/constants/constants.dart';
import 'package:omnisaude_chatbot_example/app/core/models/bots_model.dart';
import 'package:universal_html/html.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  final ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    store.getChatBots();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Início"),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(child: _gridChatsContent()),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 7.5, vertical: 5.0),
              child: FlatButton(
                onPressed: () async {
                  Modular.to.navigate("/attendant/$TOKEN");
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                disabledColor: Theme.of(context).cardColor.withOpacity(0.6),
                color: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 25.0),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Text(
                  "Área do atendente",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridChatsContent() {
    return RefreshIndicator(
      onRefresh: () async {
        await store.getChatBots();
      },
      color: Theme.of(context).primaryColor,
      child: Observer(
        builder: (context) {
          if (store.chatBots.results.isEmpty)
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.refresh_rounded),
                  onPressed: () async => await store.getChatBots(),
                ),
                Text("Recarregar", textAlign: TextAlign.center),
              ],
            );
          return GridView.builder(
            controller: _scrollController,
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 7.5,
              crossAxisSpacing: 7.5,
            ),
            padding: EdgeInsets.all(7.5),
            itemCount: store.chatBots.results.length,
            itemBuilder: (BuildContext context, int index) {
              return _gridChatItem(store.chatBots.results[index]);
            },
          );
        },
      ),
    );
  }

  Widget _gridChatItem(ChatBot chatBot) {
    return Observer(
      builder: (context) {
        final bool _selected = store.chatSelected == chatBot;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: _selected
                ? Theme.of(context).primaryColor
                : Theme.of(context).cardColor,
          ),
          child: IconButton(
            onPressed: () {
              store.chatSelected = chatBot;
              Modular.to.navigate(
                '/chat_bot/${store.chatSelected?.id}',
              );
            },
            icon: Text(chatBot.name),
          ),
        );
      },
    );
  }
}
