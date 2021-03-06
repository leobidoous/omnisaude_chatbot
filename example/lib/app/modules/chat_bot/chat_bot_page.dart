import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/shared/stylesheet/app_colors.dart';
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
    return Container(
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
        color: AppColors.background,
      ),
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _buildListWidget(),
        ),
      ),
    );
  }

  Widget _buildListWidget() {
    return RxBuilder(
      builder: (_) {
        Widget _popup = Container();
        Widget _reconnect = Container();
        if (controller.connectionStatus.value == ConnectionStatus.WAITING) {
          _popup = LoadingWidget(
            background: AppColors.primary,
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
            background: AppColors.background,
            function: () => controller.onInitAndListenStream(widget.chatBotId),
            buttonLabel: "Tentar novamente",
            margin: 20.0,
            padding: 20.0,
            radius: 20.0,
            opacity: 0.5,
          );
        } else if (controller.connectionStatus.value == ConnectionStatus.DONE) {
          _reconnect = SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: FlatButton(
                onPressed: () => controller.onInitAndListenStream(
                  widget.chatBotId,
                ),
                color: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "Reconectar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          );
        }
        if (controller.messages.isNotEmpty) {
          _popup = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                  child: SafeArea(
                    bottom: !controller.connection.showingPanel,
                    child: ListView.builder(
                      reverse: true,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      itemCount: controller.messages.length,
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 15.0,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return controller.omnisaudeChatbot.chooseWidgetToRender(
                          message: controller.messages[index],
                          lastMessage: controller.messages.first,
                        );
                      },
                    ),
                  ),
                ),
              ),
              controller.omnisaudeChatbot.panelSendMessage(
                lastMessage: controller.messages.first,
              ),
              _reconnect,
            ],
          );
        }
        return Stack(fit: StackFit.expand, children: [_popup]);
      },
    );
  }
}
