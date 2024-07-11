import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myproject/class/adopts.dart';
import 'package:http/http.dart' as http;

class Adopt extends StatefulWidget {
  const Adopt({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdoptState();
  }
}

class _AdoptState extends State<Adopt> {
  String temp = 'waiting API respond…';
  List<Adopts> ADs = [];

  Future<String> fetchData() async {
    final response = await http.get(
        Uri.parse("https://ubaya.me/flutter/160421074/adopsian/listadopt.php"));
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
      return const CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Adopt')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Builder(builder: (context) {
              List<Widget> listCard = [];
              for (var i = 0; i < ADs.length; i++) {
                listCard.add(Card(
                  margin: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.pets, size: 30),
                        title: Row(
                          children: [
                            Text(
                              ADs[i].names,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Text('Pemilik: ${ADs[i].ownerName}'),
                        trailing: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue[100],
                          ),
                          child: Text(
                            ADs[i].status.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Divider(),
                      Image.network(ADs[i].images),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green[100],
                            ),
                            child: Text(
                              ADs[i].types,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red[100],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.trending_up_outlined),
                                const SizedBox(width: 8),
                                Text(
                                  ADs[i].userCount.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (ADs[i].selectedUserName != "")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Diadopsi oleh '),
                            Text(ADs[i].selectedUserName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ListTile(
                        title: Text(ADs[i].descriptions),
                      ),
                    ],
                  ),
                ));
              }
              return Column(
                children: listCard,
              );
            }),
          ],
        ),
      ),
    );
  }
}
