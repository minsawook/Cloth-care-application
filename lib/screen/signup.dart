import 'package:flutter/material.dart';

// ignore: camel_case_types
class sign extends StatefulWidget {
  const sign({Key key}) : super(key: key);

  @override
  _signState createState() => _signState();
}

// ignore: camel_case_types
class _signState extends State<sign> {
  final TextEditingController emailController2 = TextEditingController();
  final TextEditingController passwordController2 = TextEditingController();
  final TextEditingController passwordcheckController2 =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Column(
        children: [
          Row(
            children: <Widget>[
              TextFormField(
                controller: emailController2,
                decoration: InputDecoration(labelText: 'email'),
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: passwordController2,
                decoration: InputDecoration(labelText: 'password'),
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: passwordcheckController2,
                decoration: InputDecoration(labelText: 'password check'),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          )
        ],
      ),
    );
  }
}
