import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot/app/video_call_widgets/agora_video_call/agora_video_call_widget.dart';

class OmnisaudeVideoCall extends Disposable {
  final double _radius;
  final double _padding;

  OmnisaudeVideoCall(this._radius, this._padding);

  Future<void> onShowAgoraVideoCall(BuildContext context) async {
    try {
      await showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(_padding),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_radius),
              child: Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                body: AgoraVideoCallWidget(),
              ),
            ),
          );
        },
      );
    } catch (e) {
      print("Erro ao mostrar conteudo da video chamada: $e");
    }
  }

  @override
  void dispose() {}
}
