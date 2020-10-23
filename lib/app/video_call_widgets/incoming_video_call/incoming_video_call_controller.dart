import 'package:camera/camera.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'incoming_video_call_controller.g.dart';

@Injectable()
class IncomingVideoCallController = _IncomingVideoCallControllerBase
    with _$IncomingVideoCallController;

abstract class _IncomingVideoCallControllerBase with Store {

  List<CameraDescription> listAvailableCameras = List();
  @observable
  CameraController cameraController;

  Future<void> onGetAvailableCameras() async {
    try {
      listAvailableCameras = await availableCameras();
      if (listAvailableCameras.isNotEmpty) {
        onNewCameraSelected(listAvailableCameras.last);
      }
    } on CameraException catch (e) {
      print("Erro ao obter cameras disponiveis: $e");
    }
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (cameraController != null) {
      await cameraController.dispose();
    }
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.ultraHigh,
      enableAudio: true,
    );

    cameraController.addListener(() {
      // if (mounted) setState(() {});
      // if (controller.value.hasError) {
      //   showInSnackBar('Camera error ${controller.value.errorDescription}');
      // }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print("Erro ao inicializar camera selecionada: $e");
    }
  }
}
