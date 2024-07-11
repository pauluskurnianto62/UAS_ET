import 'package:flutter/material.dart';
import 'package:myproject/class/adopts.dart';

class Decision extends StatefulWidget {
  Adopts? adopt;
  Decision({super.key, required this.adopt});

  @override
  State<Decision> createState() => _DecisionState();
}

class _DecisionState extends State<Decision> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decision'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(widget.adopt!.names,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green[100],
                ),
                child: Text(
                  widget.adopt!.types,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Text(widget.adopt!.descriptions),
              const Divider(),
              Image.network(widget.adopt!.images),
              const Divider(),
              const Text('Akan diadopsi oleh'),
              Builder(builder: (context) {
                List<Widget> listWidget = [];
                for (var i = 0; i < widget.adopt!.userlist.length; i++) {
                  UserList user = widget.adopt!.userlist[i];
                  listWidget.add(ListTile(
                    leading:
                        Text("#${i + 1}", style: const TextStyle(fontSize: 20)),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(user.name),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Adopsi"),
                        ),
                      ],
                    ),
                    subtitle: Text(user.description),
                  ));
                }
                return Column(
                  children: listWidget,
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
