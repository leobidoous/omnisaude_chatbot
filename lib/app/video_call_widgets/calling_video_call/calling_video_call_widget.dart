import 'dart:ui';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/video_call_widgets/calling_video_call/calling_video_call_controller.dart';

class CallingVideoCallWidget extends StatefulWidget {
  final RtcEngine rtcEngineClient;

  const CallingVideoCallWidget({Key key, this.rtcEngineClient})
      : super(key: key);

  @override
  _CallingVideoCallWidgetState createState() => _CallingVideoCallWidgetState();
}

class _CallingVideoCallWidgetState extends State<CallingVideoCallWidget> {
  final CallingVideoCallController _controller = CallingVideoCallController();

  @override
  void initState() {
    _controller.rtcEngineClient = widget.rtcEngineClient;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _renderLocalPreview();
  }

  Widget _renderLocalPreview() {
    return Stack(
      children: [
        RtcLocalView.SurfaceView(),
        Center(  // <-- clips to the 200x200 [Container] below
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text('Hello World'),
            ),
          ),
        ),
      ],
    );
  }
}
