import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/src/omnisaude_video_call.dart';

part 'video_call_controller.g.dart';

@Injectable()
class VideoCallController = _VideoCallControllerBase with _$VideoCallController;

abstract class _VideoCallControllerBase with Store {
  final OmnisaudeVideoCall omnisaudeVideoCall = OmnisaudeVideoCall(0.0, 0.0);

  Future<void> onInitChat(BuildContext context) async {
    await omnisaudeVideoCall.onShowAgoraVideoCall(context);
  }
}
