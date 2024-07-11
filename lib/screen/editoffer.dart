// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myproject/class/adopts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditOffer extends StatefulWidget {
  Adopts? adopt;
  EditOffer({super.key, required this.adopt});

  @override
  State<EditOffer> createState() => EditOfferState();
}

class EditOfferState extends State<EditOffer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleCont = TextEditingController();
  final TextEditingController _typeCont = TextEditingController();
  final TextEditingController _descCont = TextEditingController();
  final TextEditingController _imageCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.adopt != null) {
      print('adopt is not null');
      _titleCont.text = widget.adopt!.names;
      _typeCont.text = widget.adopt!.types;
      _descCont.text = widget.adopt!.descriptions;
      _imageCont.text = widget.adopt!.images;

      if (_titleCont.text.isNotEmpty &&
          _typeCont.text.isNotEmpty &&
          _descCont.text.isNotEmpty &&
          _imageCont.text.isNotEmpty) {
        print('Text fields updated');
      } else {
        print('Text fields not updated');
      }
    } else {
      print('adopt is null');
    }
  }

  void submit() async {
    final response = await http.post(
      Uri.parse(
          "https://ubaya.me/flutter/160421074/adopsian/editofferadopt.php"),
      body: {
        'id': widget.adopt!.id.toString(),
        'name': widget.adopt!.names,
        'type': widget.adopt!.types,
        'description': widget.adopt!.descriptions,
        'image': widget.adopt!.images,
      },
    );
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      print(json);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Sukses Edit Data')));
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
          title: const Text("Edit Offer"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _titleCont,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    onChanged: (value) {
                      widget.adopt!.names = value;
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
                    controller: _typeCont,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                    ),
                    onChanged: (value) {
                      widget.adopt!.images = value;
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
                    controller: _descCont,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                    ),
                    onChanged: (value) {
                      widget.adopt!.descriptions = value;
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
                    controller: _imageCont,
                    decoration: const InputDecoration(
                      labelText: 'Gambar',
                    ),
                    onChanged: (value) {
                      widget.adopt!.images = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Gambar harus diisi';
                      }
                      return null;
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        !_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Harap Isian diperbaiki')));
                    } else {
                      submit();
                    }
                  },
                  child: const Text('Edit'),
                ),
              ),
            ],
          ),
        ));
  }
}
