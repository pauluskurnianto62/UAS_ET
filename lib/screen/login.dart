import 'package:flutter/material.dart';
import 'package:myproject/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class MyLogin extends StatelessWidget {
  const MyLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  String _user_id = '';
  String _user_password = '';
  void doLogin() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421074/adopsian/login.php"),
        body: {'user_name': _user_id, 'user_password': _user_password});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      print(json);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt("user_id", json['user_id']);
        prefs.setString("user_name", json['user_name']);
        main();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect user or password')),
        );
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  void doRegister() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Container(
            height: 300,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                border: Border.all(width: 1),
                color: Colors.white,
                boxShadow: const [BoxShadow(blurRadius: 20)]),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (v) {
                    _user_id = v;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter valid username id'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  onChanged: (v) {
                    _user_password = v;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                            onPressed: () {
                              doLogin();
                            },
                            child: const Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: ElevatedButton(
                            onPressed: () {
                              doRegister();
                            },
                            child: const Text(
                              'Register',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 25),
                            ),
                          ),
                        ),
                      )
                    ]),
              )
            ])));
  }
}
