import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:shop_app/models/htttp_exception.dart';
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite; //not final becouse it will change

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    this.isFavorite = false,
    @required this.price,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final url =
        'https://flutter-learning-udemy-7c504.firebaseio.com/userProducts/$userId/${this.id}.json?auth=$token';

    this.isFavorite = !this.isFavorite;
    notifyListeners();

    var response = await http.put(url,
        body: json.encode(
         this.isFavorite,
        ));

    if (response.statusCode >= 400) {
      notifyListeners();
      this.isFavorite = !this.isFavorite;
      throw HttpException("Loading favorite could not be completed.");
    }
  }
}
