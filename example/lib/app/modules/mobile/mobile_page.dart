import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'mobile_controller.dart';

class MobilePage extends StatefulWidget {
  final String title;
  const MobilePage({Key key, this.title = "Mobile"}) : super(key: key);

  @override
  _MobilePageState createState() => _MobilePageState();
}

class _MobilePageState extends ModularState<MobilePage, MobileController> {
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
      backgroundColor: Theme.of(context).backgroundColor,
      body: Observer(
        builder: (context) {
          if (controller.messages.isEmpty) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/shared/background_walpaper.jpg",
                          package: "omnisaude_chatbot",
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).textTheme.headline6.color,
                          BlendMode.difference,
                        ),
                      ),
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: Center(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 0.0,
                        color: Theme.of(context).primaryColor,
                        child: Container(
                          padding: EdgeInsets.all(50.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                width: 50.0,
                                height: 50.0,
                                alignment: Alignment.center,
                                child: Theme(
                                  data: ThemeData(brightness: Brightness.dark),
                                  child: CupertinoActivityIndicator(
                                    animating: true,
                                    radius: 15.0,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "Iniciando chat...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/shared/background_walpaper.jpg",
                        package: "omnisaude_chatbot",
                      ),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Theme.of(context).textTheme.headline6.color,
                        BlendMode.difference,
                      ),
                    ),
                    color: Theme.of(context).backgroundColor,
                  ),
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
