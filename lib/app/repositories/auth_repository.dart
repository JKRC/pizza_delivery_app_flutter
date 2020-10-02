import 'package:dio/dio.dart';
import 'package:pizza_delivery/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery/app/models/user_model.dart';

class AuthRepository {
  Future<UserModel> login(String email, String password) async {
    try {
      final response =
          await Dio().post('http://localhost:8888/user/auth', data: {
        'email': email,
        'password': password,
      });
      return UserModel.fromMap(response.data);
    } on DioError catch (e) {
      print(e);
      String message = 'Erro ao autenticar o usuário';
      if (e?.response?.statusCode == 403) {
        message = 'Usuário ou senha inválidos';
      }

      throw RestException(message);
    }
  }
}
