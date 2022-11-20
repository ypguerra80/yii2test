import 'dart:developer';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:tasksapp/classes/task_dto.dart';
import 'package:tasksapp/classes/user_dto.dart';
import 'package:tasksapp/services/storage_service.dart';

class ApiService{

  static const String API_URL = "http://192.168.1.2:8080/index.php?r=";

  //Singleton
  static final ApiService instance = ApiService._internal();

  factory ApiService() {
    return instance;
  }

  ApiService._internal();

  Future<UserDTO> doLogin(String username, String password) async {
    return _manageUser(username, password, 'authenticate');
  }

  Future<UserDTO> doRegister(String username, String password) async {
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

  Future<List<dynamic>> getTasks() async {
    try {

      UserDTO user = await StorageService.instance.getUser();

      var response = await Dio().get('${API_URL}api/task/get-my-tasks&userId=${user.id}', options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization":
        "Bearer ${user.token}",
      }));

      log('log: $response');

      if (response.statusCode == 200 && response.data['success']) {
        log('log: $response');
        return response.data['data'];
      }
    } catch (e) {
      log('log: $e');
    }

    return List.empty();
  }

  Future<bool> saveTask(TaskDTO task) async {
    try {

      UserDTO user = await StorageService.instance.getUser();

      var formData = FormData.fromMap({
        'id': task.id,
        'user_id': user.id,
        'status_id': task.statusId,
        'title': task.title,
        'description': task.description,
      });

      var response = await Dio().post('${API_URL}api/task/save-task', data: formData, options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization":
        "Bearer ${user.token}",
      }));

      log('log: $response');

      if (response.statusCode == 200 && response.data['success']) {
        log('log: $response');
        return response.data['success'];
      }
    } catch (e) {
      log('log: $e');
    }

    return false;
  }

  Future<bool> deleteTask(int taskId) async {
    try {

      UserDTO user = await StorageService.instance.getUser();

      var response = await Dio().get('${API_URL}api/task/delete-task&id=$taskId', options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization":
        "Bearer ${user.token}",
      }));

      log('log: $response');

      if (response.statusCode == 200 && response.data['success']) {
        log('log: $response');
        return response.data['success'];
      }
    } catch (e) {
      log('log: $e');
    }

    return false;
  }

  Future<UserDTO> _manageUser(String username, String password, String action) async {
    int userId = 0;
    String token = '';

    try {

      var formData = FormData.fromMap({
        'username': username,
        'password': password,
      });

      var response = await Dio().post('${API_URL}api/auth/$action', data: formData);

      log('log: $response');

      if (response.statusCode == 200 && response.data['success']) {
        userId  = response.data['id'];
        token   = response.data['token'];
      }
    } catch (e) {
      log('log: $e');
    }

    return UserDTO(userId, username, token);
  }

}