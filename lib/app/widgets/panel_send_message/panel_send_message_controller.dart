import 'package:mobx/mobx.dart';

part 'panel_send_message_controller.g.dart';

class PanelSendMessageController = _PanelSendMessageControllerBase
    with _$PanelSendMessageController;

abstract class _PanelSendMessageControllerBase with Store {
  @observable
  bool inputEnabled = true;
}
