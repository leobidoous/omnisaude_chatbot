import 'dart:ui';

import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:omnisaude_chatbot/app/video_call_widgets/agora_video_call/agora_video_call_controller.dart';
import 'package:omnisaude_chatbot/app/video_call_widgets/calling_video_call/calling_video_call_widget.dart';

class AgoraVideoCallWidget extends StatefulWidget {
  @override
  _AgoraVideoCallWidgetState createState() => _AgoraVideoCallWidgetState();
}

class _AgoraVideoCallWidgetState extends State<AgoraVideoCallWidget>
    with WidgetsBindingObserver {
  final AgoraVideoCallController _controller = AgoraVideoCallController();

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
            FlatButton(onPressed: () async {
              final stream = await html.window.navigator.getUserMedia(video: true, audio: true);
            }, child: Text("Permitir câmera")),
            FlatButton(onPressed: () {}, child: Text("Permitir microfone")),
            FlatButton(onPressed: () {}, child: Text("Permitir armazenamento")),
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  Widget _videoCallRender() {
    return Observer(
      builder: (context) {
        // if (!_controller.canInitCall) return _givePermissionsWidget();
        _controller.initVideoCall();
        return Scaffold(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          body: _videoStackRender(),
        );
      },
    );
  }

  Widget _videoStackRender() {
    return Stack(
      children: [
        Center(child: _chooseMainVideoRender()),
        Observer(
          builder: (context) {
            return AnimatedPadding(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: _controller.fullScreen ? 60.0 : 40.0,
              ),
              child: Align(
                alignment: _controller.insideVideoAlignment,
                child: Draggable(
                  child: _chooseSecondaryVideoRender(),
                  feedback: _chooseSecondaryVideoRender(),
                  childWhenDragging: Container(),
                  onDragEnd: (DraggableDetails details) {
                    _controller.calculateAlignment(context, details);
                  },
                ),
              ),
            );
          },
        ),
        Align(alignment: Alignment.bottomCenter, child: _toolbarCallOptions()),
      ],
    );
  }

  Widget _chooseMainVideoRender() {
    return Observer(
      builder: (context) {
        if (_controller.usersOnline.length == 1)
          return CallingVideoCallWidget();
        if (_controller.switchVideos) return _renderLocalPreview();
        return GestureDetector(
          onTap: () => _controller.changeFullScreenMode(),
          child: _renderRemoteVideo(),
        );
      },
    );
  }

  Widget _chooseSecondaryVideoRender() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GestureDetector(
        onTap: () => _controller.switchVideos = !_controller.switchVideos,
        child: IgnorePointer(
          ignoring: false,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Observer(
              builder: (context) {
                if (_controller.usersOnline.length <= 1) return Container();
                if (_controller.switchVideos) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.2,
                    color: Theme.of(context).backgroundColor,
                    child: _renderRemoteVideo(),
                  );
                }
                return Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: Theme.of(context).backgroundColor,
                  child: _renderLocalPreview(),
                );
              },
            ),
          ),
        ),
      ),
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

  Widget _toolbarCallOptions() {
    return Observer(
      builder: (context) {
        if (_controller.usersOnline.length <= 1) return Container();
        return AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: _controller.fullScreen ? null : 0.0,
          constraints: BoxConstraints(maxHeight: 500.0),
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          curve: Curves.decelerate,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      padding: EdgeInsets.all(5.0),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        iconSize: 40.0,
                        icon: Icon(Icons.call_end),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.0),
                Observer(
                  builder: (context) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade900.withOpacity(0.2),
                          ),
                          padding: EdgeInsets.all(5.0),
                          child: IconButton(
                            onPressed: () async =>
                                await _controller.onToggleAudio(),
                            iconSize: 30.0,
                            icon: Icon(
                              _controller.audioEnabled
                                  ? Icons.mic_rounded
                                  : Icons.mic_off_rounded,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade900.withOpacity(0.2),
                          ),
                          padding: EdgeInsets.all(5.0),
                          child: IconButton(
                            onPressed: () async =>
                                await _controller.onToggleVideo(),
                            iconSize: 30.0,
                            icon: Icon(
                              _controller.videoEnabled
                                  ? Icons.videocam_rounded
                                  : Icons.videocam_off_rounded,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade900.withOpacity(0.2),
                          ),
                          padding: EdgeInsets.all(5.0),
                          child: IconButton(
                            onPressed: () async =>
                                await _controller.onChangeCameraType(),
                            iconSize: 30.0,
                            icon: Icon(
                              _controller.cameraType == CameraType.FRONT
                                  ? Icons.camera_front_rounded
                                  : Icons.camera_rear_rounded,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 40.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
