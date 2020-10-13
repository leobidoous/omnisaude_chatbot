import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
    controller.onInitAndListenStream();
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title),
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
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Observer(
        builder: (context) {
          if (controller.messages.isEmpty) {
            return Container(
              child: LinearProgressIndicator(
                backgroundColor: Theme.of(context).cardColor,
                minHeight: 5.0,
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: controller.messages.length,
                  controller: controller.scrollController,
                  padding: EdgeInsets.all(5.0),
                  itemBuilder: (BuildContext context, int index) {
                    return controller.omnisaudeChatbot.chooseWidgetToRender(
                      controller.messages[index],
                      controller.mobileConnection.getUserPeer(),
                      controller.messages.last == controller.messages[index],
                    );
                  },
                ),
              ),
              controller.omnisaudeChatbot.panelSendMessage(
                controller.messages.last,
                controller.mobileConnection.onSendMessage,
              ),
            ],
          );
        },
      ),
    );
  }
}
