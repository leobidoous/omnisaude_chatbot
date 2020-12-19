import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot_example/app/shared/widgets/content_error/content_error_widget.dart';
import 'package:omnisaude_chatbot_example/app/shared/widgets/loading/loading_widget.dart';

import 'chat_bot_controller.dart';

class ChatBotPage extends StatefulWidget {
  final String chatBotId;

  const ChatBotPage({Key key, this.chatBotId = ""}) : super(key: key);

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends ModularState<ChatBotPage, ChatBotController> {
  @override
  void initState() {
    controller.onInitAndListenStream(widget.chatBotId);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                if (controller.botTyping) {
                  return Text(
                    "${controller.botUsername} está digitando...",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0,
                    ),
                  );
                }
                return Text(
                  "${controller.botUsername}",
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

        if (controller.connectionStatus == ConnectionStatus.WAITING) {
          _popup = LoadingWidget(
            background: Theme.of(context).primaryColor,
            message: "Iniciando conversa...",
            margin: 20.0,
            padding: 50.0,
            radius: 20.0,
            opacity: 0.5,
          );
        } else if (controller.connectionStatus == ConnectionStatus.ERROR) {
          _popup = ContentErrorWidget(
            messageLabel: "Ocorreu um erro ao iniciar a conversa",
            background: Theme.of(context).backgroundColor,
            function: () => controller.onInitAndListenStream(widget.chatBotId),
            buttonLabel: "Tentar novamente",
            margin: 20.0,
            padding: 20.0,
            radius: 20.0,
            opacity: 0.5,
          );
        } else if (controller.connectionStatus == ConnectionStatus.ACTIVE) {
          if (controller.messages.isNotEmpty) {
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
                      itemCount: controller.messages.length,
                      controller: controller.scrollController,
                      padding: const EdgeInsets.all(5.0),
                      itemBuilder: (BuildContext context, int index) {
                        return controller.omnisaudeChatbot.chooseWidgetToRender(
                          controller.messages[index],
                        );
                      },
                    ),
                  ),
                ),
                Observer(
                  builder: (context) {
                    return controller.omnisaudeChatbot.panelSendMessage(
                      controller.messages.first,
                    );
                  },
                ),
              ],
            );
          }
        }

        return Stack(
          fit: StackFit.expand,
          children: [_popup],
        );
      },
    );
  }
}
