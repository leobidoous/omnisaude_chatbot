import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/shared/loading/loading_widget.dart';
import 'package:omnisaude_chatbot_example/app/core/constants/constants.dart';
import 'package:omnisaude_chatbot_example/app/modules/historic_conversation/historic_conversation_controller.dart';
import 'package:omnisaude_chatbot_example/app/shared/widgets/content_error/content_error_widget.dart';
import 'package:omnisaude_chatbot_example/app/shared/widgets/empty/empty_widget.dart';
import 'package:rx_notifier/rx_notifier.dart';

class HistoricConversationPage extends StatefulWidget {
  final String sessionId;

  const HistoricConversationPage({Key key, this.sessionId = ""})
      : super(key: key);

  @override
  _HistoricConversationPageState createState() =>
      _HistoricConversationPageState();
}

class _HistoricConversationPageState extends State<HistoricConversationPage> {
  bool _configLoaded = false;
  final HistoricConversationController store =
      new HistoricConversationController();

  String _token = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_configLoaded) {
      final settingsUri = Uri.parse(ModalRoute.of(context).settings.name);
      _token = settingsUri.queryParameters["token"] ?? TOKEN;
      store.getHistoricConversation(sessionId: widget.sessionId, token: _token);
    }
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
        title: Text("Histórico de conversa"),
        automaticallyImplyLeading: false,
      ),
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
    return RxBuilder(
      builder: (_) {
        Widget _popup = Container();
        if (store.connectionStatus.value == ConnectionStatus.WAITING) {
          _popup = LoadingWidget(
            background: Theme.of(context).primaryColor,
            message: "Carregando histórico...",
            margin: 20.0,
            padding: 50.0,
            radius: 20.0,
            opacity: 0.5,
          );
        } else if (store.connectionStatus.value == ConnectionStatus.ERROR) {
          _popup = ContentErrorWidget(
            messageLabel: "Ocorreu um erro ao buscar histórico",
            background: Theme.of(context).backgroundColor,
            function: () => store.getHistoricConversation(
              sessionId: widget.sessionId,
              token: _token,
            ),
            buttonLabel: "Tentar novamente",
            margin: 20.0,
            padding: 20.0,
            radius: 20.0,
            opacity: 0.5,
          );
        } else if (store.connectionStatus.value == ConnectionStatus.ACTIVE) {
          if (store.messages.isNotEmpty) {
            _popup = GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: ListView.builder(
                reverse: true,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                itemCount: store.messages.length,
                padding: const EdgeInsets.all(5.0),
                itemBuilder: (BuildContext context, int index) {
                  return store.omnisaudeChatbot.chooseWidgetToRender(
                    message: store.messages[index],
                    lastMessage: store.messages.last,
                    messageViewMode: MessageViewMode.ANOTHER,
                  );
                },
              ),
            );
          } else {
            _popup = EmptyWidget(
              message: "Nenhuma mensagem disponível",
              function: () => store.getHistoricConversation(
                sessionId: widget.sessionId,
                token: _token,
              ),
              buttonLabel: "Tentar novamente",
              padding: 10.0,
              margin: 20.0,
              radius: 20.0,
            );
          }
        }

        return Stack(fit: StackFit.expand, children: [_popup]);
      },
    );
  }
}
