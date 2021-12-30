import 'package:cloth/data/join_or_login.dart';
import 'package:cloth/screen/frame.dart';
import 'package:cloth/screen/sign/login_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

FirebaseAuth auth = FirebaseAuth.instance;

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Splash();
  }
}

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return ChangeNotifierProvider<JoinOrLogin>.value(
              value: JoinOrLogin(), child: Login_Ui());
        } else
          return FramePage(email: snapshot.data.email);
      },
    );
  }
}
