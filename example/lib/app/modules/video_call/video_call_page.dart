import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'video_call_controller.dart';

class VideoCallPage extends StatefulWidget {
  final String title;

  const VideoCallPage({Key key, this.title = "VideoCall"}) : super(key: key);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState
    extends ModularState<VideoCallPage, VideoCallController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(widget.title),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => controller.onInitChat(context),
              icon: Icon(Icons.video_call_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
