import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:omnisaude_chatbot_example/app/core/models/bots_model.dart';
import 'package:omnisaude_chatbot_example/app/modules/home/home_repository.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {

  @observable
  ChatBot chatSelected;
  @observable
  Result chatBots = Result()..results = List<ChatBot>();

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
