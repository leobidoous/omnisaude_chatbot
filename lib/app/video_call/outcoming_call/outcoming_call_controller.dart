import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'outcoming_call_controller.g.dart';

@Injectable()
class OutcomingCallController = _OutcomingCallControllerBase
    with _$OutcomingCallController;

abstract class _OutcomingCallControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
