import 'package:mobx/mobx.dart';

part 'input_content_controller.g.dart';

class InputContentController = _InputContentControllerBase
    with _$InputContentController;

abstract class _InputContentControllerBase with Store {

  @observable
  DateTime dateTimeSelected;
}
