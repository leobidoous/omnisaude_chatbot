import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:omnisaude_chatbot/app/video_call/outcoming_call/outcoming_call_widget.dart';

class OmnisaudeVideoCall extends Disposable {
  OverlayEntry _overlayEntry;
  OverlayState _overlayState;

  OmnisaudeVideoCall();

  void initVideoCall(BuildContext context) {
    _overlayState = Overlay.of(context);
    _overlayEntry = new OverlayEntry(builder: (_) => OutcomingCallWidget());
    _overlayState.insert(_overlayEntry);
  }

  void closePipMode() {
    _overlayEntry.remove();
  }

  @override
  void dispose() {
    _overlayState.dispose();
  }
}
