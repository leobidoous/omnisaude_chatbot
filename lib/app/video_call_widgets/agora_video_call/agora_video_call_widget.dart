import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
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
    // _controller.onCheckWebPermissionsToInitCall();
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
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      body: Observer(
        builder: (context) {
          if (!_controller.canInitCall) return _givePermissionsWidget();
          _controller.initVideoCall();
          return _videoStackRender();
        },
      ),
    );
  }

  Widget _givePermissionsWidget() {
    final String _labelVideo = "Permitir vídeo";
    final String _labelAudio = "Permitir áudio";
    final String _labelStorage = "Permitir armazenamento";

    return Observer(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _btnGivePermission(_labelStorage, _controller.hasStorePermission),
            _btnGivePermission(_labelVideo, _controller.hasVideoPermission),
            _btnGivePermission(_labelAudio, _controller.hasAudioPermission),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: FlatButton(
                    onPressed: () => Navigator.pop(context),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text("Cancelar"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _btnGivePermission(String label, bool hasPermission) {
    if (hasPermission) return Container();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          FlatButton(
            onPressed: () async =>
                await _controller.onCheckWebPermissionsToInitCall(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }

  Widget _videoStackRender() {
    return Stack(
      children: [
        Center(child: _primaryVideoScreen()),
        AnimatedPadding(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: _controller.fullScreen ? 60.0 : 40.0,
          ),
          child: Align(
            alignment: _controller.insideVideoAlignment,
            child: new Draggable(
              maxSimultaneousDrags: 1,
              child: _secondaryVideoScreen(),
              feedback: _secondaryVideoScreen(),
              childWhenDragging: Container(),
              onDragEnd: (DraggableDetails details) {
                _controller.calculateAlignment(context, details);
              },
            ),
          ),
        ),
        Align(alignment: Alignment.bottomCenter, child: _toolbarCallOptions()),
      ],
    );
  }

  Widget _primaryVideoScreen() {
    return GestureDetector(
      onTap: () => _controller.changeFullScreenMode(),
      child: Observer(
        builder: (context) {
          final bool _calling = _controller.usersOnline.length == 1;
          if (_calling) return CallingVideoCallWidget();
          if (_controller.switchVideos) return _renderLocalPreview();
          return _renderRemoteVideo();
        },
      ),
    );
  }

  Widget _secondaryVideoScreen() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _controller.switchVideos = !_controller.switchVideos,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.2,
                maxWidth: MediaQuery.of(context).size.width * 0.2,
              ),
              child: Observer(
                builder: (context) {
                  final bool _calling = _controller.usersOnline.length == 1;
                  if (_calling) return Container();
                  if (_controller.switchVideos) {
                    return Container(
                      color: Theme.of(context).backgroundColor,
                      child: _renderRemoteVideo(),
                    );
                  }
                  return Container(
                    color: Theme.of(context).backgroundColor,
                    child: _renderLocalPreview(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderLocalPreview() {
    return Observer(
      builder: (context) {
        if (_controller.usersOnline.isEmpty) return Container();
        return Stack(
          fit: StackFit.expand,
          children: [
            new RtcLocalView.SurfaceView(),
            _statusVideoCall(),
          ],
        );
      },
    );
  }

  Widget _statusVideoCall() {
    return Observer(
      builder: (context) {
        Widget _videoOff = Container();
        Widget _videoLabelOff = Container();
        Widget _audioOff = Container();
        Widget _audioLabelOff = Container();
        if (!_controller.videoEnabled) {
          if (_controller.switchVideos) {
            _videoLabelOff = Text(
              "Vídeo está desativado",
              textAlign: TextAlign.center,
            );
          }
          _videoOff = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.videocam_off_rounded), _videoLabelOff],
          );
        }
        if (!_controller.audioEnabled) {
          if (_controller.switchVideos) {
            _audioLabelOff = Text(
              "Áudio está desativado",
              textAlign: TextAlign.center,
            );
          }
          _audioOff = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.mic_off_rounded), _audioLabelOff],
          );
        }
        return Container(
          color: !_controller.videoEnabled || !_controller.audioEnabled
              ? Colors.black.withOpacity(0.85)
              : Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_videoOff, _audioOff],
          ),
        );
      },
    );
  }

  Widget _renderRemoteVideo() {
    return Observer(
      builder: (context) {
        if (_controller.usersOnline.isEmpty) return Container();
        if (_controller.usersOnline.length < 2) return Container();
        return new RtcRemoteView.SurfaceView(uid: 123123123);
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
