import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'incoming_call_controller.g.dart';

@Injectable()
class IncomingCallController = _IncomingCallControllerBase
    with _$IncomingCallController;

abstract class _IncomingCallControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
