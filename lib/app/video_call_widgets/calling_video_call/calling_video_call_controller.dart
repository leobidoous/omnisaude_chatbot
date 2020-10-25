import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'calling_video_call_controller.g.dart';

@Injectable()
class CallingVideoCallController = _CallingVideoCallControllerBase
    with _$CallingVideoCallController;

abstract class _CallingVideoCallControllerBase with Store {
  RtcEngine rtcEngineClient;

}
