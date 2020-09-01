import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/htttp_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _logoutTimer;

  bool get isAuth {
    return _token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) return _token;
    return null;
  }

  Future<void> _sendAuthRequest(
      String email, String password, String urlSection) async {
    var url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSection?key=AIzaSyBjhzgBZTL3J3GrtvOMv9sh5JZxT5mh9ss';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      var recivedData = json.decode(response.body);

      if (recivedData['error'] != null) {
        throw HttpException(recivedData['error']['message']);
      }

      _token = recivedData['idToken'];
      _userId = recivedData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(recivedData['expiresIn']),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs =
          await SharedPreferences.getInstance(); // tunnel to device storage
      final userData = json.encode(
        {
          'token': token,
          'userId': userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _sendAuthRequest(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _sendAuthRequest(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {

    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData = json.decode(prefs.get('userData')) as Map<String, dynamic>;
    var expiryDate = DateTime.parse(userData['expiryDate']);
 
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
     
    _token = userData['token'];
    _expiryDate = expiryDate;
    _userId = userData['userId'];
   
    notifyListeners();
   
    _autoLogout();
      
    return true;
  }

  void _autoLogout() {
    if (_logoutTimer != null) _logoutTimer.cancel();

    var _timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: _timeToExpiry), this.logout);
    //print(_timeToExpiry.toString());
  }
}
