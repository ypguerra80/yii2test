import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tasksapp/classes/task_dto.dart';
import 'package:tasksapp/services/api_service.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key, required this.task});

  final TaskDTO task;

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String _selectedStatus = 'Pending';

  @override
  void initState() {

    switch(widget.task.statusId){
      case 2:{
        _selectedStatus = 'Completed';
        break;
      }
      case 3:{
        _selectedStatus = 'Canceled';
        break;
      }
      default:{
        _selectedStatus = 'Pending';
      }
    }

    if(widget.task.id > 0){
      titleController.text        = widget.task.title;
      descriptionController.text  = widget.task.description;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( widget.task.id > 0 ? 'Edit Task' : 'New Task' ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Visibility(
              visible: widget.task.id > 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: DropdownButton<String>(
                  value: _selectedStatus,
                  items: <String>['Pending', 'Completed', 'Canceled'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      if(value != null && value.isNotEmpty){
                        _selectedStatus = value;
                      }else{
                        _selectedStatus = 'Pending';
                      }
                    });
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Required field';
                  }

                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: descriptionController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Required field';
                  }

                  return null;
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          switch(_selectedStatus){
            case 'Completed':{
              widget.task.statusId = 2;
              break;
            }
            case 'Canceled':{
              widget.task.statusId = 3;
              break;
            }
            default:{
              widget.task.statusId = 1;
            }
          }

          widget.task.title = titleController.value.text;
          widget.task.description = descriptionController.value.text;

          ApiService.instance.saveTask(widget.task).then((success){
            if(success){
              Navigator.pop(context);
            }
            else{
              //TODO: handle error
            }
          });
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.save),
      ),
    );
  }


}