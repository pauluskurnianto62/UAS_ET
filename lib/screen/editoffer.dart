// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/class/adopts.dart';

class EditOffer extends StatefulWidget {
  int adoptID;
  EditOffer({super.key, required this.adoptID});

  @override
  State<EditOffer> createState() => EditOfferState();
}

class EditOfferState extends State<EditOffer> {
  final _formKey = GlobalKey<FormState>();
  Adopts ad =new Adopts(ids: 1, names: "", types: "", descriptions: "", images: "");
  TextEditingController _titleCont = TextEditingController();
  TextEditingController _typeCont = TextEditingController();
  TextEditingController _descCont = TextEditingController();
  TextEditingController _imageCont = TextEditingController();

  Future<String> fetchData() async {
    final response = await http.post(
      Uri.parse("https://ubaya.me/flutter/160421074/listofferadopt.php"),
      body: {'id': widget.adoptID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

   bacaData() {
  fetchData().then((value) {
   Map json = jsonDecode(value);
   ad = Adopts.fromJson(json['data']);
   setState(() {
    		_titleCont.text = ad.names;
        _typeCont.text = ad.types;
        _descCont.text = ad.descriptions;
        _imageCont.text = ad.images;
   	});
  });
 }
 @override
 void initState() {
  super.initState();
  bacaData();
 }

  void submit() async {
    final response = await http
        .post(Uri.parse("https://ubaya.me/flutter/160421074/editofferadopt.php"), body: {
      'name': ad.names,
      'type': ad.types,
      'description': ad.descriptions,
      'image': ad.images,
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
          title: Text("Edit Offer"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (value) {
                  ad.names = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                  },
                )
              )
            ,
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Type',
              ),
              onChanged: (value) {
                ad.images = value;
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
                ad.descriptions = value;
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
                labelText: 'Gambar',
              ),
              onChanged: (value) {
                ad.images = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Gambar harus diisi';
                }
                return null;
                },
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
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