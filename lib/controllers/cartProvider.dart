import 'package:flutter/material.dart';
import 'package:toko_online/models/cart.dart';
import 'package:toko_online/services/DBHelper.dart';

class CartProvider extends ChangeNotifier {
  int counter = 0;
  final dBHelper = DBHelper();
  List<Cart> cart = [];

  Future<List<Cart>> getData() async {
    cart = await dBHelper.getCartList();
    counter = cart.length;
    notifyListeners();
    return cart;
  }

  void addQuantity(int id) async {
    final index = cart.indexWhere((element) => element.id == id);
    if (index != -1) {
      cart[index].quantity = (cart[index].quantity ?? 0) + 1;
      await dBHelper.updateQuantity(id, cart[index].quantity!);
      notifyListeners();
    }
  }

  void deleteQuantity(int id) async {
    final index = cart.indexWhere((element) => element.id == id);
    if (index != -1 && (cart[index].quantity ?? 0) > 1) {
      cart[index].quantity = cart[index].quantity! - 1;
      await dBHelper.updateQuantity(id, cart[index].quantity!);
      notifyListeners();
    }
  }

  void removeItem(int id) async {
    await dBHelper.deleteCartItem(id);
    cart.removeWhere((element) => element.id == id);
    counter = cart.length;
    notifyListeners();
  }

  void removeCounter() {}
}