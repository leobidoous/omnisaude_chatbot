import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:universal_html/html.dart' as html;
import 'package:omnisaude_chatbot/app/core/constants/constants.dart';
import 'package:omnisaude_chatbot/app/core/enums/enums.dart';
import 'package:permission_handler/permission_handler.dart';

part 'agora_video_call_controller.g.dart';

@Injectable()
class AgoraVideoCallController = _AgoraVideoCallControllerBase
    with _$AgoraVideoCallController;

abstract class _AgoraVideoCallControllerBase with Store {
  RtcEngine rtcEngineClient;
  int uidUser;

  ObservableList usersOnline = ObservableList();

  @observable
  bool canInitCall = false;
  @observable
  bool hasVideoPermission = false;
  @observable
  bool hasAudioPermission = false;
  @observable
  bool hasStorePermission = false;
  @observable
  bool switchVideos = false;
  @observable
  bool videoEnabled = true;
  @observable
  bool audioEnabled = true;
  @observable
  CameraType cameraType = CameraType.FRONT;
  @observable
  bool fullScreen = true;
  @observable
  Alignment insideVideoAlignment = Alignment.topLeft;

  Future<void> onCheckPermissionsToInitCall() async {
    try {
      hasVideoPermission = false;
      hasAudioPermission = false;
      hasStorePermission = false;

      final List<Permission> _permissions = List<Permission>();

      _permissions.add(Permission.camera);
      _permissions.add(Permission.microphone);
      _permissions.add(Permission.storage);


      PermissionStatus _cameraStatus = await Permission.camera.status;
      if (_cameraStatus == PermissionStatus.granted) {
        hasVideoPermission = true;
      }
      PermissionStatus _microphoneStatus = await Permission.microphone.status;
      if (_microphoneStatus == PermissionStatus.granted) {
        hasAudioPermission = true;
      }
      PermissionStatus _storageStatus = await Permission.storage.status;
      if (_storageStatus == PermissionStatus.granted) {
        hasStorePermission = true;
      }

      print(_cameraStatus);
      print(_microphoneStatus);
      print(_storageStatus);

      if (hasVideoPermission &&
          hasAudioPermission &&
          hasStorePermission) {
        canInitCall = true;
      } else {
        canInitCall = false;
      }
      await _permissions.request();
    } catch (e) {
      print("Erro ao checar permissões: $e");
    }
  }

  Future<void> onCheckWebPermissionsToInitCall() async {
    try {
      hasVideoPermission = false;
      hasAudioPermission = false;
      hasStorePermission = true;

      final _cameraStatus = await html.window.navigator.permissions.query({"name": "camera"});
      final _microphoneStatus = await html.window.navigator.permissions.query({"name": "microphone"});
      // final _storageStatus = await html.window.navigator.permissions.query({"name": "storage"});
      final stream = await html.window.navigator.getUserMedia(video: true, audio: true, );

      print(_cameraStatus.state);
      print(_microphoneStatus.state);
      // print(_storageStatus);

      if (_cameraStatus.state == "granted") {
        hasVideoPermission = true;
      }
      if (_microphoneStatus.state == "granted") {
        hasAudioPermission = true;
      }
      // if (_storageStatus.state == "granted") {
      //   hasStorePermission = true;
      // }


      if (hasVideoPermission &&
          hasAudioPermission &&
          hasStorePermission) {
        canInitCall = true;
      } else {
        canInitCall = false;
      }
      print(canInitCall);
    } catch (e) {
      print("Erro ao checar permissões web: $e");
    }
  }

  Future<void> initVideoCall() async {
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
      await rtcEngineClient.joinChannel(null, '123', null, 102030);
    } catch (e) {
      print("Erro ao iniciar video chamada: $e");
    }
  }

  void joinChannelSuccess(String channel, int uid, int elapsed) {
    print('joinChannelSuccess $channel $uid');
    uidUser = uid;
    if (!usersOnline.contains(uidUser)) usersOnline.add(uidUser);
    if (usersOnline.length > 1) changeFullScreenMode();
  }

  void userJoined(int uid, int elapsed) {
    print('userJoined $uid');
    usersOnline.add(uid);
    changeFullScreenMode();
  }

  void userOffline(int uid, UserOfflineReason reason) {
    print('userOffline $uid');
    usersOnline.remove(uid);
  }

  void calculateAlignment(BuildContext context, DraggableDetails details) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    if (details.offset.dy > _height / 2) {
      if (details.offset.dx > _width / 2) {
        insideVideoAlignment = Alignment.bottomRight;
      } else {
        insideVideoAlignment = Alignment.bottomLeft;
      }
    } else {
      if (details.offset.dx > _width / 2) {
        insideVideoAlignment = Alignment.topRight;
      } else {
        insideVideoAlignment = Alignment.topLeft;
      }
    }
  }

  void changeFullScreenMode() {
    final Function _hidden = () {
      if (usersOnline.isEmpty) return;
      fullScreen = false;
      SystemChrome.setEnabledSystemUIOverlays([]);
    };
    if (fullScreen) {
      _hidden();
    } else {
      SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.bottom, SystemUiOverlay.top],
      );
      fullScreen = true;
      Timer(Duration(milliseconds: 10000), _hidden);
    }
  }

  Future<void> onChangeCameraType() async {
    await rtcEngineClient.switchCamera();
    if (cameraType == CameraType.FRONT)
      cameraType = CameraType.BACK;
    else
      cameraType = CameraType.FRONT;
  }

  Future<void> onToggleVideo() async {
    videoEnabled = !videoEnabled;
    await rtcEngineClient.enableLocalVideo(videoEnabled);
  }

  Future<void> onToggleAudio() async {
    audioEnabled = !audioEnabled;
    await rtcEngineClient.enableLocalAudio(audioEnabled);
  }

  Future<void> dispose() async {
    SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top],
    );
    usersOnline.clear();
    try {
      await rtcEngineClient.leaveChannel();
    } catch(e) {
      print("Erro ao deixar canal: $e");
    }
  }
}
