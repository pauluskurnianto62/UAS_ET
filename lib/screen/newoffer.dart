import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NewOffer extends StatefulWidget {
  const NewOffer({super.key});

  @override
  State<NewOffer> createState() => NewOfferState();
}

class NewOfferState extends State<NewOffer> {
  final formKey = GlobalKey<FormState>();
  String newname = "";
  String newtype = "";
  String newdesc = "";
  String newimage = "";

  void submit() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
        Uri.parse(
            "https://ubaya.me/flutter/160421074/adopsian/newofferadopt.php"),
        body: {
          'adoptID': prefs.getInt("user_id").toString(),
          'name': newname,
          'type': newtype,
          'description': newdesc,
          'image': newimage,
        });
    print(response.body);
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sukses Menambah Data')));
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error')));
      throw Exception('Failed to read API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Offer"),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Nama Hewan (optional)',
                    ),
                    onChanged: (value) {
                      newname = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama harus diisi';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Tipe Hewan',
                    ),
                    onChanged: (value) {
                      newtype = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tipe harus diisi';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                    ),
                    onChanged: (value) {
                      newdesc = value;
                    },
                    validator: (value) {
                      if (value!.length < 30) {
                        return 'Deskripsi kurang panjang';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 6,
                  )),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Link Gambar',
                    ),
                    onChanged: (value) {
                      newimage = value;
                    },
                    validator: (value) {
                      if (value == null || !Uri.parse(value).isAbsolute) {
                        return 'Alamat gambar salah';
                      }
                      return null;
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState != null &&
                        !formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Harap Isian diperbaiki')));
                    } else {
                      submit();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}
