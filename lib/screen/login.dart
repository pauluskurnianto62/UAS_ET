import 'package:flutter/material.dart';
import 'package:myproject/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  String _user_id = '';
  String _user_password='';

  String error_login='';

  void doLogin() async {
    final response = await http.post(
        Uri.parse("https://ubaya.me/flutter/160421074/login.php"),
        body: {'user_id': _user_id, 'user_password': _user_password});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("user_id", _user_id);
        prefs.setString("user_name", json['user_name']);
        main();
      } else {
        setState(() {
          error_login = "Incorrect user or password";
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        height: 300,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(width: 1),
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 20)]),
          child: Column(children: [	Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onChanged: (v) {
                  _user_id = v;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter valid username id'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (v) {
                       _user_password = v;
                       },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {doLogin();},
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {doLogin();},
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ),
                )]
		        ),
          )
        ])
      )
    );
  }
}
