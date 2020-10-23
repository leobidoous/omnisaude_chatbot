import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:omnisaude_chatbot/app/video_call_widgets/agora_video_call/agora_video_call_controller.dart';

class AgoraVideoCallWidget extends StatefulWidget {
  @override
  _AgoraVideoCallWidgetState createState() => _AgoraVideoCallWidgetState();
}

class _AgoraVideoCallWidgetState extends State<AgoraVideoCallWidget>
    with WidgetsBindingObserver {
  final AgoraVideoCallController _controller = AgoraVideoCallController();

  bool _joined = false;
  int _remoteUid = null;
  bool _switch = false;

  @override
  void initState() {
    _controller.onCheckPermissionsToInitCall();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).secondaryHeaderColor,
      padding: EdgeInsets.all(0.0),
      child: _videoCallRender(),
    );
  }

  Widget _givePermissionsWidget() {
    return Observer(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(onPressed: () {}, child: Text("Permitir câmera")),
            FlatButton(onPressed: () {}, child: Text("Permitir microfone")),
            FlatButton(onPressed: () {}, child: Text("Permitir armazenamento")),
            FlatButton(onPressed: () {}, child: Text("Cancelar")),
          ],
        );
      },
    );
  }

  Widget _videoCallRender() {
    return Observer(
      builder: (context) {
        if (!_controller.canInitCall) return _givePermissionsWidget();
        _controller.initVideoCall();
        return Scaffold(
          body: Container(
            color: Theme.of(context).secondaryHeaderColor,
            child: Stack(
              children: [
                Center(
                  child: _switch ? _renderRemoteVideo() : _renderLocalPreview(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _switch = !_switch;
                        });
                      },
                      child: Center(
                        child: _switch
                            ? _renderLocalPreview()
                            : _renderRemoteVideo(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _renderLocalPreview() {
    return Observer(
      builder: (context) {
        if (_controller.usersOnline.isEmpty) return Container();
        return RtcLocalView.SurfaceView();
      },
    );
  }

  Widget _renderRemoteVideo() {
    return Observer(
      builder: (context) {
        if (_controller.usersOnline.isEmpty) return Container();
        if (_controller.usersOnline.length < 2) return Container();
        return RtcRemoteView.SurfaceView(uid: 123123123);
      },
    );
  }
}
