import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tasksapp/services/api_service.dart';
import 'package:tasksapp/services/storage_service.dart';
import 'package:tasksapp/views/register.dart';
import 'package:tasksapp/views/tasks.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Task Manager',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter your username';
                    }

                    return null;
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter your password';
                    }

                    return null;
                  },
                ),
              ),
              Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Login'),
                    onPressed: () {
                      _tryToLogin(nameController.value.text, passwordController.value.text);
                    },
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Don\'t you have an account?'),
                  TextButton(
                    child: const Text(
                      'Join Us',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Register()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _tryToLogin(String username, String password) async{
    if(_formKey.currentState!.validate()){
      //TODO: show loading
      ApiService.instance.doLogin(username, password).then((user){
        if(user.token.isNotEmpty){
          StorageService.instance.saveUser(user);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Tasks()),
          );

        }else{
          //TODO: show login fail
        }

        //TODO: hide loading
      }).onError((error, stackTrace){
        log('log: $error');
        //TODO: hide loading
      });
    }
  }
}