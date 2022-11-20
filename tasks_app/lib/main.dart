import 'package:flutter/material.dart';
import 'package:tasksapp/classes/user.dart';
import 'package:tasksapp/views/error-screen.dart';
import 'package:tasksapp/views/login.dart';
import 'package:tasksapp/views/splash.dart';
import 'package:tasksapp/views/tasks.dart';
//TODO: Check for flutter_secure_storage configurations on different platforms.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyApp createState() => _MyApp();

}

class _MyApp extends State<MyApp> with TickerProviderStateMixin {

  late Future<User> user;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {

    user = _getSavedUser();

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.requireData.token.isNotEmpty){
            if(snapshot.requireData.name == ''){
              return const Login();
            } else {
              return const Tasks();
            }
          }

          return snapshot.hasError ? const ErrorScreen() : const Splash();
        },
      ),
    );
  }

  Future<User> _getSavedUser() async {
    String? userToken = await storage.read(key: 'user_token_key');
    String token = userToken ?? '';

    return User(token, 'name');
  }

}
