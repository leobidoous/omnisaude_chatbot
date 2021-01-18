import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:flutter/material.dart';
import 'package:omnisaude_chatbot/app/core/constants/constants.dart';
import 'package:picture_in_picture/picture_in_picture.dart';

class OutcomingCallWidget extends StatefulWidget {
  @override
  _OutcomingCallWidgetState createState() => _OutcomingCallWidgetState();
}

class _OutcomingCallWidgetState extends State<OutcomingCallWidget> {
  RtcEngine rtcEngineClient;
  int uidUser;

  List usersOnline = List();

  Future<void> initVideoCall(String channel, int userUid) async {
    if (rtcEngineClient != null) return;
    try {
      rtcEngineClient = await RtcEngine.create(APP_ID);
      rtcEngineClient.setEventHandler(
        RtcEngineEventHandler(
          joinChannelSuccess: joinChannelSuccess,
          userJoined: userJoined,
          userOffline: userOffline,
        ),
      );
      await rtcEngineClient.enableVideo();
      await rtcEngineClient.joinChannel(null, channel, null, userUid);
    } catch (e) {
      print("Erro ao iniciar video chamada: $e");
    }
  }

  void joinChannelSuccess(String channel, int uid, int elapsed) {
    print('joinChannelSuccess $channel $uid');
    uidUser = uid;
    if (!usersOnline.contains(uidUser)) usersOnline.add(uidUser);
  }

  void userJoined(int uid, int elapsed) {
    print('userJoined $uid');
    usersOnline.add(uid);
  }

  void userOffline(int uid, UserOfflineReason reason) {
    print('userOffline $uid');
    usersOnline.remove(uid);
    if (usersOnline.length == 1) {
      if (usersOnline.first == uidUser) {
        Navigator.pop(context);
      }
    }
  }

  @override
  void initState() {
    initVideoCall("flutter", 123);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PictureInPicture(
      builder: (BuildContext context, bool isFloating) {
        return Scaffold(
          body: SafeArea(
            top: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: new RtcLocalView.SurfaceView(),
                ),
                FlatButton(
                  onPressed: () {
                    PictureInPicture.of(context).startFloating();
                  },
                  child: Text("PIP Mode"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
