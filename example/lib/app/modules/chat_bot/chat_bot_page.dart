import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import '../../shared/widgets/content_error/content_error_widget.dart';
import '../../shared/widgets/loading/loading_widget.dart';

import 'chat_bot_controller.dart';

class ChatBotPage extends StatefulWidget {
  final String chatBotId;

  const ChatBotPage({Key key, this.chatBotId = ""}) : super(key: key);

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends ModularState<ChatBotPage, ChatBotController> {
  bool _configLoaded = false;

  @override
  void initState() {
    store.onInitAndListenStream(widget.chatBotId);
    super.initState();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration()).then((value) {
      if (!_configLoaded) {
        store.appController.getQueryParams(context);
        _configLoaded = true;
      }
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Chatbot"),
            Observer(
              builder: (BuildContext context) {
                if (store.botTyping) {
                  return Text(
                    "${store.botUsername} está digitando...",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0,
                    ),
                  );
                }
                return Text(
                  "${store.botUsername}",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/shared/background_walpaper.png",
                package: "omnisaude_chatbot",
              ),
              fit: BoxFit.cover,
              scale: 0.1,
              colorFilter: ColorFilter.mode(
                Theme.of(context).textTheme.headline6.color,
                BlendMode.difference,
              ),
            ),
            color: Theme.of(context).backgroundColor,
          ),
          child: _buildListWidget(),
        ),
      ),
    );
  }

  Widget _buildListWidget() {
    return Observer(
      builder: (context) {
        Widget _popup = Container();

        if (store.connectionStatus == ConnectionStatus.WAITING) {
          _popup = LoadingWidget(
            background: Theme.of(context).primaryColor,
            message: "Iniciando conversa...",
            margin: 20.0,
            padding: 50.0,
            radius: 20.0,
            opacity: 0.5,
          );
        } else if (store.connectionStatus == ConnectionStatus.ERROR) {
          _popup = ContentErrorWidget(
            messageLabel: "Ocorreu um erro ao iniciar a conversa",
            background: Theme.of(context).backgroundColor,
            function: () => store.onInitAndListenStream(widget.chatBotId),
            buttonLabel: "Tentar novamente",
            margin: 20.0,
            padding: 20.0,
            radius: 20.0,
            opacity: 0.5,
          );
        } else if (store.connectionStatus == ConnectionStatus.ACTIVE) {
          if (store.messages.isNotEmpty) {
            _popup = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).requestFocus(
                      FocusNode(),
                    ),
                    child: ListView.builder(
                      reverse: true,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      itemCount: store.messages.length,
                      controller: store.scrollController,
                      padding: const EdgeInsets.all(5.0),
                      itemBuilder: (BuildContext context, int index) {
                        return store.omnisaudeChatbot.chooseWidgetToRender(
                          message: store.messages[index],
                          lastMessage: store.messages.first,
                        );
                      },
                    ),
                  ),
                ),
                Observer(
                  builder: (context) {
                    return store.omnisaudeChatbot.panelSendMessage(
                      message: store.messages.first,
                    );
                  },
                ),
              ],
            );
          }
        }

        return Stack(fit: StackFit.expand, children: [_popup]);
      },
    );
  }
}
