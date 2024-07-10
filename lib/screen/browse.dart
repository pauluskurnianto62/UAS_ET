import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myproject/class/adopts.dart';
import 'package:http/http.dart' as http;

class Browse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BrowseState();
  }
}

class _BrowseState extends State<Browse> {
  String temp = 'waiting API respond…';
  List<Adopts> ADs = [];

  Future<String> fetchData() async {
    final response = await http.get(Uri.parse(
        "https://ubaya.me/flutter/160421074/adopsian/listunadopt.php"));
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
      for (var adopt in json['data']) {
        Adopts ad = Adopts.fromJson(adopt);
        ADs.add(ad);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget DaftarAdopsi(adopts) {
    if (adopts != null) {
      return ListView.builder(
          itemCount: adopts.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    leading: Image.network(adopts[index].image,
                        width: 30, height: 30),
                    title: Text(
                        adopts[index].name + " (" + adopts[index].type + ")"),
                    subtitle:
                        Text("Description: " + adopts[index].description)),
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
        appBar: AppBar(title: const Text('List of Adopt')),
        body: ListView(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: DaftarAdopsi(ADs),
          )
        ]));
  }
}
