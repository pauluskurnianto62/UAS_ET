import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    final response = await http
        .post(Uri.parse("https://ubaya.me/flutter/160421074/newofferadopt.php"), body: {
      'name': newname,
      'type': newtype,
      'description': newdesc,
      'image': newimage,
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
          title: Text("New Offer"),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
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
              )
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Type',
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
              )
            ),
            Padding(
              padding: EdgeInsets.all(10), 
              child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
              ),
              onChanged: (value) {
                newdesc = value;
              },
              validator: (value) {
                if (value!.length<30) {
                  return 'Deskripsi kurang panjang';
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 6,
              )
            ),
            Padding(
              padding: EdgeInsets.all(10),
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
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (formKey.currentState != null && !formKey.currentState!.validate()) {
            	      ScaffoldMessenger.of(context).showSnackBar(
              	      SnackBar(content: Text('Harap Isian diperbaiki')));
                  }
                  else{
                    submit();
                  }
		            },
              child: Text('Submit'),
              ),
            ),
          ],
        ),
      )
    );
  }
}
