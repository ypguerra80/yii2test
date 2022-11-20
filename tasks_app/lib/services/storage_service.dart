import 'dart:developer';
//TODO: Check for flutter_secure_storage configurations on different platforms.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tasksapp/classes/user.dart';

class StorageService{

  final storage = const FlutterSecureStorage();

  //Singleton
  static final StorageService instance = StorageService._internal();

  factory StorageService() {
    return instance;
  }

  StorageService._internal();

  Future<User> getUser() async{
    String? userName = await storage.read(key: 'user_name_key');
    String name = userName ?? '';

    String? userToken = await storage.read(key: 'user_token_key');
    String token = userToken ?? '';

    return User(name, token);
  }

  saveUser(User user) async{
    await storage.write(key: 'user_name_key', value: user.name);
    await storage.write(key: 'user_token_key', value: user.token);
  }

}