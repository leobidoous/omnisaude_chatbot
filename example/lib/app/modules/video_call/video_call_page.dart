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
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 200.0,
      color: Colors.red,
    );
  }
}
