import 'dart:developer';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:tasksapp/classes/user.dart';

class ApiService{

  static const String API_URL = "http://192.168.1.2:8080/index.php?r=";

  //Singleton
  static final ApiService instance = ApiService._internal();

  factory ApiService() {
    return instance;
  }

  ApiService._internal();

  Future<User> doLogin(String username, String password) async {
    return _manageUser(username, password, 'authenticate');
  }

  Future<User> doRegister(String username, String password) async {
    return _manageUser(username, password, 'register');
  }

  Future<bool> isNameAvailable(String username) async {
    try {

      var response = await Dio().get('${API_URL}api/auth/available&name=$username');

      log('log: $response');

      if (response.statusCode == 200 && response.data['success']) {
        return response.data['available'];
      }
    } catch (e) {
      log('log: $e');
    }

    return false;
  }

  Future<User> _manageUser(String username, String password, String action) async {
    var token = '';

    try {

      var formData = FormData.fromMap({
        'username': username,
        'password': password,
      });

      var response = await Dio().post('${API_URL}api/auth/$action', data: formData);

      log('log: $response');

      if (response.statusCode == 200 && response.data['success']) {
        token = response.data['token'];
      }
    } catch (e) {
      log('log: $e');
    }

    return User(username, token);
  }

}