import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tasksapp/classes/user.dart';
import 'package:tasksapp/services/storage_service.dart';
import 'package:tasksapp/views/login.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  String username = '';

  @override
  void initState() {

    StorageService.instance.getUser().then((user){
      setState(() {
        username = user.name;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager ($username)'),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  log('log: Log out');

                  StorageService.instance.saveUser(User('', ''));

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
                child: const Icon(
                  Icons.exit_to_app,
                  size: 26.0,
                ),
              )
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'TASK LIST',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

}