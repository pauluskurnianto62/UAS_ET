import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myproject/class/adopts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Browse extends StatefulWidget {
  const Browse({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BrowseState();
  }
}

class _BrowseState extends State<Browse> {
  String temp = 'waiting API respond…';
  List<Adopts> ADs = [];

  Future<String> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421074/adopsian/listunadopt.php"),
      body: {
        'id': prefs.getInt("user_id").toString(),
      },
    );
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
            return Card(
                margin: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(adopts[index].names +
                          " (" +
                          adopts[index].types +
                          ")"),
                      subtitle: Text(adopts[index].descriptions),
                    ),
                    Image.network(adopts[index].images),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[100],
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            String description = '';

                            return AlertDialog(
                              title: const Text('Enter Description'),
                              content: TextField(
                                maxLines:
                                    null, // This allows the textarea to expand as needed
                                onChanged: (value) {
                                  description = value;
                                },
                                decoration: const InputDecoration(
                                    hintText:
                                        'Masukkan kata-kata untuk meyakinkan pemilik'),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final response = await http.post(
                                      Uri.parse(
                                          "https://ubaya.me/flutter/160421074/adopsian/proposeadopt.php"),
                                      body: {
                                        'id': adopts[index].id.toString(),
                                        'userID':
                                            prefs.getInt("user_id").toString(),
                                        'description': description,
                                      },
                                    );
                                    if (response.statusCode == 200) {
                                      Map json = jsonDecode(response.body);
                                      print(json);
                                      if (json['result'] == 'success') {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Sukses Propose Hewan')));
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('Error')));
                                      throw Exception('Failed to read API');
                                    }
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Submit'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Propose Hewan Ini'),
                    )
                  ],
                ));
          });
    } else {
      return const CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Browse')),
        body: ListView(children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: DaftarAdopsi(ADs),
          )
        ]));
  }
}
