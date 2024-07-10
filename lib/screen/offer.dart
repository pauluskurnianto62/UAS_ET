import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myproject/class/adopts.dart';
import 'package:http/http.dart' as http;

class Offer extends StatefulWidget {
  const Offer({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdoptState();
  }
}

class _AdoptState extends State<Offer> {
  String temp = 'waiting API respond…';
  List<Adopts> ADs = [];

  Future<String> fetchData() async {
    final response = await http.get(Uri.parse(
        "https://ubaya.me/flutter/160421074/adopsian/listofferadopt.php"));
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
      setState(() {});
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
            return Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.pets, size: 30),
                  title: Text(PopMovs[index].name),
                ),
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
      appBar: AppBar(title: const Text('List Offer')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "new_offer");
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Create New Offer'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Builder(builder: (context) {
              List<Widget> listCard = [];
              for (var i = 0; i < ADs.length; i++) {
                listCard.add(InkWell(
                  onTap: () {},
                  child: Card(
                    margin: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.pets, size: 30),
                          title: Text(ADs[i].names),
                        ),
                        const Divider(),
                        Image.network(ADs[i].images),
                        const Divider(),
                        ListTile(
                          title: Text(ADs[i].types),
                        ),
                        ListTile(
                          title: Text(ADs[i].descriptions),
                        ),
                      ],
                    ),
                  ),
                ));
              }
              return Column(
                children: listCard,
              );
            }),
            // Expanded(
            //   child: ListView(
            //     children: <Widget>[
            //       SizedBox(
            //         height: MediaQuery.of(context).size.height - 200,
            //         child: DaftarAdopsi(ADs),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
