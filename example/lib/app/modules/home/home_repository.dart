import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:omnisaude_chatbot_example/app/core/constants/constants.dart';
import 'package:omnisaude_chatbot_example/app/core/custom_dio/dio_interceptor.dart';
import 'package:omnisaude_chatbot_example/app/core/models/bots_model.dart';

@Injectable()
class HomeRepository extends Disposable {
  Dio _dio;

  HomeRepository() {
    _dio = Dio();
    _dio.options.baseUrl = BASE_URL + DEFAULT_API;
    _dio.options.connectTimeout = CONNECT_TIMEOUT;
    _dio.interceptors.add(DioInterceptors());
  }

  Future<Result> getChatBots() async {
    try {
      Response _response = await _dio.get("/organization/187db031-3c2e-4bdc-9774-d54636a47f1c/bot/");
      return Result.fromJson(_response.data);
    } on DioError catch (e) {
      print("Repository: Erro ao buscar bots. $e");
      throw e;
    }
  }

  //dispose will be called automatically
  @override
  void dispose() {
  }
}
