import 'package:find_food/models/Product.dart';
import 'package:find_food/models/panier.dart';
import 'package:flutter/cupertino.dart';

class CartItem extends ChangeNotifier {
  List<Product> products = [];
  List<CartItemModel> items = [];
  addProduct(Product product) {
    products.add(product);
    //print("THE qty IS: ${quantity.toString()}");
    notifyListeners();
  }

  addToCart(CartItemModel cartItemModel) {
    items.add(cartItemModel);
    notifyListeners();
  }

  clearitems() {
    items = [];
  }

  clearproducts() {
    products = [];
  }

  removefromcart(CartItemModel cartItemModel) {
    items.remove(cartItemModel);
    notifyListeners();
  }

  removefromproducts(Product product) {
    products.remove(product);
    notifyListeners();
  }
}
