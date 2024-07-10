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
    String user_id = prefs.getString("user_id") ?? '';
    return user_id;
  }

  
  
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      active_user = result;
      runApp(MyApp());
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
  			'adopt': (context) => Adopt(),
        'browse':(context) => Browse(),
        'offer':(context) => Offer(),
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
                currentAccountPicture: CircleAvatar(
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150"))),
            ListTile(
              title: Text("Adopt"),
              leading: Icon(Icons.pets),
              onTap: () {
                Navigator.popAndPushNamed(context, "about");
            }),
            ListTile(
              title: Text("Offer"),
              leading: Icon(Icons.front_hand),
              onTap: () {
                Navigator.popAndPushNamed(context, "studentlist");
            }),
            ListTile(
              title: Text("Browse"),
              leading: Icon(Icons.search),
              onTap: () {
                goBrowse();
                Navigator.popAndPushNamed(context, "week3");
            }),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
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
      body: Center(
        child: Column(

        ),
      ),
    );
  }
}
