import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class MyRegist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Regist(),
    );
  }
}

class Regist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistState();
  }
}

class _RegistState extends State<Regist> {
  String user_id = "";
  String user_name = "";
  String user_password = "";

  void submit() async {
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421074/adopsian/adopsian/regist.php"),
        body: {
          'user_id': user_id,
          'user_name': user_name,
          'user_password': user_password,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sukses Menambah Data')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Regist'),
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
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  onChanged: (v) {
                    user_id = v;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User ID',
                      hintText: 'Enter valid user id'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  onChanged: (v) {
                    user_name = v;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter valid username'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  onChanged: (v) {
                    user_password = v;
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
                    children: [
                      Container(
                        height: 50,
                        width: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        child: ElevatedButton(
                          onPressed: () {
                            submit();
                          },
                          child: Text(
                            'Submit',
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
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Back',
                            style: TextStyle(color: Colors.black, fontSize: 25),
                          ),
                        ),
                      )
                    ]),
              )
            ])));
  }
}
