import 'package:mobx/mobx.dart';

part 'panel_send_message_controller.g.dart';

class PanelSendMessageController = _PanelSendMessageControllerBase
    with _$PanelSendMessageController;

abstract class _PanelSendMessageControllerBase with Store {
  @observable
  bool inputEnabled = true;

  @observable
  bool attachEnabled = false;
  @observable
  bool dateEnabled = false;
  @observable
  bool textEnabled = false;
}
