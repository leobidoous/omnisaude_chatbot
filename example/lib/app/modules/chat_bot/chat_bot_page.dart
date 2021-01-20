import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:rx_notifier/rx_notifier.dart';

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
  @override
  void initState() {
    controller.onInitAndListenStream(widget.chatBotId);
    super.initState();
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
            RxBuilder(
              builder: (_) {
                if (controller.botTyping.value) {
                  return Text(
                    "${controller.botUsername.value} está digitando...",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w300,
                      fontSize: 12.0,
                    ),
                  );
                }
                return Text(
                  "${controller.botUsername.value}",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.0),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam_rounded),
            onPressed: () {
              controller.omnisaudeVideoCall.initVideoCall(context);
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
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
    );
  }

  Widget _buildListWidget() {
    return RxBuilder(
      builder: (_) {
        Widget _popup = Container();
        if (controller.connectionStatus.value == ConnectionStatus.WAITING) {
          _popup = LoadingWidget(
            background: Theme.of(context).primaryColor,
            message: "Iniciando conversa...",
            margin: 20.0,
            padding: 50.0,
            radius: 20.0,
            opacity: 0.5,
          );
        } else if (controller.connectionStatus.value ==
            ConnectionStatus.ERROR) {
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
        } else if (controller.connectionStatus.value == ConnectionStatus.DONE) {
          _popup = ContentErrorWidget(
            messageLabel: "Sua conexào foi finalizada",
            background: Theme.of(context).backgroundColor,
            function: () => controller.onInitAndListenStream(widget.chatBotId),
            buttonLabel: "Tentar novamente",
            margin: 20.0,
            padding: 20.0,
            radius: 20.0,
            opacity: 0.5,
          );
        } else if (controller.connectionStatus.value ==
            ConnectionStatus.ACTIVE) {
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
                      padding: const EdgeInsets.all(5.0),
                      itemBuilder: (BuildContext context, int index) {
                        return controller.omnisaudeChatbot.chooseWidgetToRender(
                          message: controller.messages[index],
                          lastMessage: controller.messages.first,
                        );
                      },
                    ),
                  ),
                ),
                controller.omnisaudeChatbot.panelSendMessage(
                  lastMessage: controller.messages.first,
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
