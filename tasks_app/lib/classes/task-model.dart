import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:tasksapp/classes/task_dto.dart';
import 'package:tasksapp/services/api_service.dart';

class TaskModel extends ChangeNotifier{

  final List<TaskDTO> _tasks = [];

  UnmodifiableListView<TaskDTO> get tasks => UnmodifiableListView(_tasks);

  //Singleton
  static final TaskModel instance = TaskModel._internal();

  factory TaskModel() {
    return instance;
  }

  TaskModel._internal();

  load(){
    _tasks.clear();

    ApiService.instance.getTasks().then((tasksMapList){
      for(var map in tasksMapList){
        _tasks.add(TaskDTO.fromMap(map));
      }

      notifyListeners();
    });
  }

  void add(TaskDTO item) {
    _tasks.add(item);

    notifyListeners();
  }

  void update(TaskDTO item) {

    int index = _tasks.indexWhere((element) => element.id == item.id);

    _tasks[index] = item;

    notifyListeners();
  }

  void deleteAt(int index) {
    _tasks.removeAt(index);

    notifyListeners();
  }

}