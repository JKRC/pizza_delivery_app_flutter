import 'package:dio/dio.dart';
import 'package:pizza_delivery/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery/app/models/menu_model.dart';

class MenuRepository {
  Future<List<MenuModel>> findAll() async {
    try {
      final response = await Dio().get('http://localhost:8888/menu');
      return response.data.map<MenuModel>((m) => MenuModel.fromMap(m)).toList();
    } on DioError catch (e) {
      throw RestException('Erro ao buscar cardápio');
    }
  }
}
