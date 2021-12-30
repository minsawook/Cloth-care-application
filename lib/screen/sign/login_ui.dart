import 'package:cloth/data/join_or_login.dart';
import 'package:cloth/screen/sign/login_back_ground.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class Login_Ui extends StatelessWidget {
  const Login_Ui({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: size,
            painter: LoginBackGround(
                isJoin: Provider.of<JoinOrLogin>(context).isJoin),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _logoImage(),
              Stack(
                children: <Widget>[
                  _inputForm(size),
                  _authButton(size),
                ],
              ),
              SizedBox(
                height: size.height * 0.10,
              ),
              Consumer<JoinOrLogin>(
                  builder: (BuildContext context, JoinOrLogin joinOrLogin,
                          Widget child) =>
                      GestureDetector(
                        onTap: () {
                          joinOrLogin.toggle();
                        },
                        child: Text(
                          joinOrLogin.isJoin ? "로그인하기" : "아이디 만들기",
                          style: TextStyle(
                              color: joinOrLogin.isJoin
                                  ? Colors.red
                                  : Colors.blue),
                        ),
                      )),
              SizedBox(
                height: size.height * 0.05,
              )
            ],
          )
        ],
      ),
    );
  }

  void _register(BuildContext context) async {
    final UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
    final User user = result.user;
    if (user == null) {
      final snackBar = SnackBar(content: Text("다시 시도해 주세요"));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _login(BuildContext context) async {
    final UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
    final User user = result.user;
    if (user == null) {
      final snackBar = SnackBar(content: Text("다시 시도해 주세요"));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  Widget _inputForm(Size size) => Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 12.0, right: 16, top: 12, bottom: 32),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.account_circle),
                            labelText: 'email'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return "아이디가 비어있습니다";
                          }
                          return null;
                        }),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          icon: Icon(Icons.vpn_key), labelText: 'password'),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "패스워드가 비어있습니다";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Consumer<JoinOrLogin>(
                        builder: (context, value, child) => Opacity(
                              opacity: value.isJoin ? 0 : 1,
                              child: Text("비밀번호 찾기"),
                            )),
                  ],
                )),
          ),
        ),
      );

  Widget _authButton(Size size) => Positioned(
      left: size.width * 0.1,
      right: size.width * 0.1,
      bottom: 0,
      child: SizedBox(
          height: 50,
          child: Consumer<JoinOrLogin>(
            builder: (context, value, child) => RaisedButton(
                color: value.isJoin ? Colors.red : Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    value.isJoin ? _register(context) : _login(context);
                  }
                },
                child: Text(
                  value.isJoin ? "Join" : "Login",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
          )));
  Widget _logoImage() => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/main_image.png'),
              backgroundColor: Colors.white,
            ),
          ),
        ),
      );
}
