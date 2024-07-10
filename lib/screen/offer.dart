import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myproject/class/adopts.dart';
import 'package:http/http.dart' as http;

class Offer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdoptState();
  }
}

class _AdoptState extends State<Offer> {
  String temp = 'waiting API respond…';
  List<Adopts> ADs = [];

  Future<String> fetchData() async {
    final response = await http
      .get(Uri.parse("https://ubaya.me/flutter/160421074/listofferadopt.php"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var mov in json['data']) {
        Adopts ad = Adopts.fromJson(mov);
        ADs.add(ad);
      }
      setState(() {

      });
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget DaftarAdopsi(PopMovs) {
    if (PopMovs != null) {
      return ListView.builder(
        itemCount: PopMovs.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return new Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person, size: 30),
                  title: Text(PopMovs[index].name),
                ),
              ],
            ));

        });
    } else {
      return CircularProgressIndicator();
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('List of Adopt') ),
        body: ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height-200,
            child: DaftarAdopsi(ADs),
          )
      ]));
  }
}