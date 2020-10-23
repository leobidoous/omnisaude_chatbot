import 'package:mobx/mobx.dart';

part 'avatar_controller.g.dart';

class AvatarController = _AvatarControllerBase with _$AvatarController;

abstract class _AvatarControllerBase with Store {
  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  }
}
