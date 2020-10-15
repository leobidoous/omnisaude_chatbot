import 'package:flutter/cupertino.dart';
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _flatButton(
                  () => Navigator.pushNamed(context, "/mobile"),
                  "Mobile",
                ),
                _flatButton(
                  () => Navigator.pushNamed(context, "/web"),
                  "Web",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _() {
    return Observer(
      builder: (context) {
        final _enabled = false;//controller.chatBotSelected != null;
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
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: FlatButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Theme.of(context).cardColor,
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
