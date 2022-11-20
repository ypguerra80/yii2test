import 'package:flutter/material.dart';
import 'package:tasksapp/classes/user_dto.dart';
import 'package:tasksapp/services/api_service.dart';
import 'package:tasksapp/services/storage_service.dart';
import 'package:tasksapp/views/error_screen.dart';
import 'package:tasksapp/views/login.dart';
import 'package:tasksapp/views/splash.dart';
import 'package:tasksapp/views/tasks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyApp createState() => _MyApp();

}

class _MyApp extends State<MyApp> with TickerProviderStateMixin {

  late Future<UserDTO> user;

  @override
  void initState() {

    user = StorageService.instance.getUser();

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
      home: FutureBuilder<UserDTO>(
        future: user,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            if(snapshot.requireData.token.isEmpty){
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

}
