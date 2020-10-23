import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:omnisaude_chatbot/app/video_call_widgets/incoming_video_call/incoming_video_call_controller.dart';

class IncomingVideoCallWidget extends StatefulWidget {
  @override
  _IncomingVideoCallWidgetState createState() =>
      _IncomingVideoCallWidgetState();
}

class _IncomingVideoCallWidgetState extends State<IncomingVideoCallWidget>
    with WidgetsBindingObserver {
  final IncomingVideoCallController _controller = IncomingVideoCallController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _controller.onGetAvailableCameras();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _cameraPreviewWidget(),
    );
  }

  Widget _cameraPreviewWidget() {
    return Observer(
      builder: (context) {
        if (_controller.cameraController == null ||
            !_controller.cameraController.value.isInitialized) {
          return Container();
        }
        final size = MediaQuery.of(context).size;
        final deviceRatio = size.width / size.height;
        return Transform.scale(
          scale:1.0,
          child: Center(
            child: AspectRatio(
              aspectRatio: _controller.cameraController.value.aspectRatio,
              child: CameraPreview(_controller.cameraController),
            ),
          ),
        );
      },
    );
  }
}
