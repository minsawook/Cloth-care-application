import 'package:cloth/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloth/saved_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => SavedNotifier())],
    child: MyApp(),
  ));
}

String imageUrl;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference images = FirebaseFirestore.instance.collection('images');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '후다닥-!',
              style: TextStyle(fontSize: 50.0),
            ),
            SizedBox(
              height: 50.0,
            ),
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/main_image.png'),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              width: 200,
              child: ElevatedButton(
                child: Text(
                  'START',
                  style: TextStyle(fontSize: 30.0),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return LoginPage();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
