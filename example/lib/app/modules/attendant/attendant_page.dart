import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/core/models/event_content_model.dart';
import 'package:omnisaude_chatbot/app/core/models/queue_model.dart';
import 'package:omnisaude_chatbot/app/core/models/ws_message_model.dart';

import '../../shared/widgets/content_error/content_error_widget.dart';
import '../../shared/widgets/empty/empty_widget.dart';
import '../../shared/widgets/image/image_widget.dart';
import '../../shared/widgets/loading/loading_widget.dart';
import 'attendant_controller.dart';

class AttendantPage extends StatefulWidget {
  final String token;

  const AttendantPage({Key key, this.token = ""}) : super(key: key);

  @override
  _AttendantPageState createState() => _AttendantPageState();
}

class _AttendantPageState
    extends ModularState<AttendantPage, AttendantController> {
  bool _configLoaded = false;

  @override
  void initState() {
    store.onInitAndListenStream(widget.token);
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
        actions: [
          IconButton(
            onPressed: () {
              store.chooseUser = !store.chooseUser;
            },
            icon: Icon(Icons.swap_vertical_circle_rounded),
          ),
          IconButton(
            onPressed: () {
              final WsMessage _message = WsMessage(
                eventContent: EventContent(
                  eventType: EventType.FINISH_ATTENDANCE,
                ),
              );
              store.connection.onSendMessage(_message);
            },
            icon: Icon(Icons.exit_to_app_rounded),
          ),
        ],
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
            function: () => store.onInitAndListenStream(""),
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

        return Stack(
          fit: StackFit.expand,
          children: [_popup, _chooseAttendanceWidget()],
        );
      },
    );
  }

  Widget _chooseAttendanceWidget() {
    return Observer(
      builder: (context) {
        Widget _popup = Column(mainAxisSize: MainAxisSize.min);
        if (store.messages.isEmpty) return Container();
        if (store.messages.first.eventContent?.queue == null) {
          return Container();
        }
        if (store.messages.first.eventContent.queue.isEmpty) {
          _popup = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmptyWidget(
                message: "Nenhum usuário aguardando atendimento",
                padding: 15.0,
              ),
            ],
          );
        } else if (store.messages.first.eventContent.queue.isNotEmpty) {
          _popup = ListView.builder(
            itemCount: store.messages.first.eventContent.queue.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemBuilder: (context, index) {
              return _attendanceItemWidget(
                store.messages.first.eventContent.queue[index],
              );
            },
          );
        }
        return AnimatedCrossFade(
          crossFadeState: store.chooseUser
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 250),
          reverseDuration: Duration(milliseconds: 250),
          firstChild: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
            child: IgnorePointer(
              ignoring: false,
              child: Container(
                constraints: BoxConstraints(maxHeight: 150.0),
                color: Theme.of(context).primaryColor.withOpacity(0.25),
                child: _popup,
              ),
            ),
          ),
          secondChild: Column(mainAxisSize: MainAxisSize.min),
        );
      },
    );
  }

  Widget _attendanceItemWidget(Queue queue) {
    return Container(
      constraints: BoxConstraints(maxWidth: 200.0),
      margin: const EdgeInsets.all(10.0),
      child: FlatButton(
        onPressed: () async {
          final WsMessage _message = WsMessage(
            eventContent: EventContent(
              eventType: EventType.INIT_ATTENDANCE,
              message: queue.user.session,
            ),
          );
          await store.connection.onSendMessage(_message);
          store.chooseUser = false;
        },
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ImageWidget(
                fit: BoxFit.cover,
                asset: "assets/avatar/user.png",
                url: queue.user.avatar,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "${queue.user.name ?? queue.user.session}",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
