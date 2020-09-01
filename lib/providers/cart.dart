import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.title,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get numberOfElements {
    return _items.length;
  }

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                price: existingItem.price,
                title: existingItem.title,
                quantity: existingItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: productId,
                price: price,
                title: title,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItem(
            id: existingItem.id,
            price: existingItem.price,
            title: existingItem.title,
            quantity:  existingItem.quantity - 1),
      );
    }else{
      this.removeItem(productId);
    }

  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
