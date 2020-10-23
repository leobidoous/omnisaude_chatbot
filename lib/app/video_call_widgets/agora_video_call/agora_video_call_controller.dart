import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:omnisaude_chatbot/app/core/constants/constants.dart';
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
  bool hasCameraPermission = false;
  @observable
  bool hasMicrophonePermission = false;
  @observable
  bool hasStorePermission = false;

  Future<void> onCheckPermissionsToInitCall() async {
    try {
      hasCameraPermission = false;
      hasMicrophonePermission = false;
      hasStorePermission = false;

      final List<Permission> _permissions = List<Permission>();

      _permissions.add(Permission.camera);
      _permissions.add(Permission.microphone);
      _permissions.add(Permission.storage);

      PermissionStatus _cameraStatus = await Permission.camera.status;
      if (_cameraStatus == PermissionStatus.granted) {
        hasCameraPermission = true;
      }
      PermissionStatus _microphoneStatus = await Permission.microphone.status;
      if (_microphoneStatus == PermissionStatus.granted) {
        hasMicrophonePermission = true;
      }
      PermissionStatus _storageStatus = await Permission.storage.status;
      if (_storageStatus == PermissionStatus.granted) {
        hasStorePermission = true;
      }

      if (hasCameraPermission &&
          hasMicrophonePermission &&
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
  }

  void userJoined(int uid, int elapsed) {
    print('userJoined $uid');
    usersOnline.add(uid);
  }

  void userOffline(int uid, UserOfflineReason reason) {
    print('userOffline $uid');
    usersOnline.remove(uid);
  }

  Future<void> dispose() async {
    usersOnline.clear();
    await rtcEngineClient.leaveChannel();
  }
}
