import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import '../../core/models/bots_model.dart';
import 'home_repository.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {

  @observable
  ChatBot chatSelected;
  @observable
  Result chatBots = Result()..results = List<ChatBot>.empty();

  @action
  Future<void> getChatBots() async {
    try {
      chatSelected = null;
      final HomeRepository _repository = HomeRepository();
      chatBots = await _repository.getChatBots();
    } on DioError catch(e) {
      print(e);
    }
  }
}
