import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tasksapp/classes/task_dto.dart';
import 'package:tasksapp/services/api_service.dart';

class TaskDetails extends StatefulWidget {
  const TaskDetails({super.key, required this.task});

  final TaskDTO task;

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( widget.task.id > 0 ? 'Edit Task' : 'New Task' ),
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(widget.task.getStatus()),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(widget.task.title),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(widget.task.description),
          ),
        ],
      ),
    );
  }


}