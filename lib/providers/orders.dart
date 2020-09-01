import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/models/htttp_exception.dart';

import '../providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String _userId;

  Orders(this.authToken, this._userId,this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://flutter-learning-udemy-7c504.firebaseio.com/orders/$_userId.json?auth=$authToken';

    final timeStamp = DateTime.now();

    try {
      var response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map((cartProduct) => {
                      'title': cartProduct.title,
                      'id': cartProduct.id,
                      'quantity': cartProduct.quantity.toString(),
                      'price': cartProduct.price.toString(),
                    })
                .toList(),
          }));
      // print(json.decode(response.body));
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timeStamp,
            products: cartProducts),
      );
      notifyListeners();
    } catch (error) {
      throw HttpException('Error adding orders to server.');
    }
  }

  Future<void> fetchAndStoreOrders() async {
    final url =
        'https://flutter-learning-udemy-7c504.firebaseio.com/orders/$_userId.json?auth=$authToken';

    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      var _extractedData = json.decode(response.body) as Map<String, dynamic>;

      List<OrderItem> _ordersList = [];

      if(_extractedData == null) return;
      _extractedData.forEach((orderId, order) {
        _ordersList.add(new OrderItem(
          id: orderId,
           amount: order['amount'],
          dateTime:DateTime.parse(order['dateTime']),
          products: (order['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: double.parse(item['price']),
                  title: item['title'],
                  quantity: int.parse(item['quantity'].toString()),
                ),
              )
              .toList() as List<CartItem>,
        ));
      });
      _orders = _ordersList.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }
}
