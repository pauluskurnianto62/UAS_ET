import 'package:flutter/material.dart';
import 'package:myproject/screen/adopt.dart';
import 'package:myproject/screen/browse.dart';
import 'package:myproject/screen/login.dart';
import 'package:myproject/screen/offer.dart';
import 'package:shared_preferences/shared_preferences.dart';

String active_user = "";
String _user_name = "Paulus Kurnianto";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString("user_id") ?? '';
  _user_name = prefs.getString("user_name") ?? '';
  return userId;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '') {
      runApp(const MyLogin());
    } else {
      active_user = result;
      runApp(const MyApp());
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 183, 58, 58)),
        useMaterial3: true,
      ),
      routes: {
        'adopt': (context) => Adopt(),
        'browse': (context) => Browse(),
        'offer': (context) => Offer(),
      },
      home: const MyHomePage(title: 'Adopsian'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _user_id = "";

  @override
  void initState() {
    super.initState();
    checkUser().then((value) => setState(
          () {
            _user_id = value;
          },
        ));
  }

  void goBrowse() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_id", _user_id);
    main();
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  Widget funDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text(_user_name),
              accountEmail: Text(_user_id),
              currentAccountPicture: const CircleAvatar(
                  backgroundImage: NetworkImage("https://i.pravatar.cc/800"))),
          // ListTile(
          //     title: const Text("Adopt"),
          //     leading: const Icon(Icons.pets),
          //     onTap: () {
          //       Navigator.popAndPushNamed(context, "adopt");
          //     }),
          // ListTile(
          //     title: const Text("Offer"),
          //     leading: const Icon(Icons.handshake),
          //     onTap: () {
          //       Navigator.popAndPushNamed(context, "offer");
          //     }),
          // ListTile(
          //     title: const Text("Browse"),
          //     leading: const Icon(Icons.search),
          //     onTap: () {
          //       goBrowse();
          //       Navigator.popAndPushNamed(context, "browse");
          //     }),
          ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () {
                doLogout();
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: funDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              color: Colors.green[100],
              child: InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, "adopt");
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Adopt",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 12,
                      height: 72,
                    ),
                    Icon(Icons.pets)
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.red[100],
              child: InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, "offer");
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Offer",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 12,
                      height: 72,
                    ),
                    Icon(Icons.handshake)
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.blue[100],
              child: InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, "browse");
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Browse",
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 12,
                      height: 72,
                    ),
                    Icon(Icons.search)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
