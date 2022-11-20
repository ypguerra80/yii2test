import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tasksapp/classes/task_dto.dart';
import 'package:tasksapp/classes/user_dto.dart';
import 'package:tasksapp/services/api_service.dart';
import 'package:tasksapp/services/storage_service.dart';
import 'package:tasksapp/views/login.dart';
import 'package:tasksapp/views/task_details.dart';
import 'package:tasksapp/views/task_form.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  String username = '';

  List<dynamic> _tasks = List.empty();

  @override
  void initState() {

    StorageService.instance.getUser().then((user){
      setState(() {
        username = user.name;
      });
    });

    _loadTasks();

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

                  StorageService.instance.saveUser(UserDTO(0, '', ''));

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
      body: ListView(
        children: <Widget>[
          ..._getTaskWidgets(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskForm(task: TaskDTO())),
          );
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Widget> _getTaskWidgets(){
    return _tasks.map((task) => Container(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Expanded(child: Text(task['title'])),
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetails(task: TaskDTO.fromMap(task))));
            },
            icon: const Icon(Icons.remove_red_eye),
          ),
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => TaskForm(task: TaskDTO.fromMap(task))));
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: (){
              ApiService.instance.deleteTask(task['id']).then((success){
                if(success){
                  //TODO: delete from list
                }else{
                  //TODO: handle error
                }
              });
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    )).toList();
  }

  _loadTasks(){
    ApiService.instance.getTasks().then((tasks){
      setState(() {
        _tasks = tasks;
      });
    });
  }
}