import 'package:dio/dio.dart';
import 'package:pizza_delivery/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery/app/models/user_model.dart';
import 'package:pizza_delivery/app/view_models/register_input_model.dart';

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

  Future<void> saveUser(RegisterInputModel registerInputModel) async {
    try {
      await Dio().post('http://localhost:8888/user', data: {
        'name': registerInputModel.name,
        'email': registerInputModel.email,
        'password': registerInputModel.password
      });
    } on DioError catch (e) {
      throw RestException('Erro ao registrar usuário');
    }
  }
}
