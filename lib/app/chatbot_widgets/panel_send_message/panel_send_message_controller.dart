import 'package:mobx/mobx.dart';

part 'panel_send_message_controller.g.dart';

class PanelSendMessageController = _PanelSendMessageControllerBase
    with _$PanelSendMessageController;

abstract class _PanelSendMessageControllerBase with Store {
  @observable
  bool panelInputEnabled;
  @observable
  bool panelSwitchEnabled;
  @observable
  bool attachEnabled = false;
  @observable
  bool dateEnabled = false;
  @observable
  bool textEnabled = false;
  @observable
  bool nluEnabled = false;
  @observable
  bool humanAttendant = false;
}
