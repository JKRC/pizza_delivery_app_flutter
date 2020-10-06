import 'package:flutter/material.dart';
import 'package:pizza_delivery/app/models/menu_model.dart';
import 'package:pizza_delivery/app/repositories/menu_repository.dart';

class MenuController extends ChangeNotifier {
  MenuRepository _repository = MenuRepository();
  List<MenuModel> menu = [];
  bool loading = false;
  String error;

  Future<void> findMenu() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      menu = await _repository.findAll();
    } catch (e) {
      error = 'Erro ao buscar o cardápio';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
