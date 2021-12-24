import 'package:cloth/screen/frame.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '후다닥-!',
                style: TextStyle(fontSize: 50.0),
              ),
              SizedBox(
                height: 30.0,
              ),
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset('assets/images/login_image.png'),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'UserName',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // 입력값이 없으면 메시지 출력
                  if (value.isEmpty) {
                    return 'Enter some text';
                  } else
                    return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  // 입력값이 없으면 메시지 출력
                  if (value.isEmpty) {
                    return 'Enter some text';
                  } else
                    return null;
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    child: OutlinedButton(
                      child: Text(
                        'SIGNUP',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 100,
                    child: ElevatedButton(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return FramePage();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
