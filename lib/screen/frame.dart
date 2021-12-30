import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:cloth/camera/camera.dart';
import 'package:cloth/fb/fb_api.dart';
import 'package:cloth/fb/fb_file.dart';
import 'package:cloth/style/stylelist.dart';
import 'package:cloth/style/stylemake.dart';
import 'package:cloth/clotharray/cloths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:http/http.dart';
import 'package:cloth/weather/my_location.dart';

class FramePage extends StatefulWidget {
  FramePage({Key key, this.title, this.email}) : super(key: key);

  final String title;
  final String email;
  @override
  _FramePageState createState() => _FramePageState();
}

class _FramePageState extends State<FramePage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<List<FirebaseFile>> futureFiles;
  FirebaseFile file;
  int random;
  int count;
  var weatherData;
  final _openweatherkey = '2db2f66ff4c3c59a8ede85ea41cecfb6';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosition();
    futureFiles = FirebaseApi.listAll(
        FirebaseAuth.instance.currentUser.email.toString() + '/cody/');
  }

  void getPosition() async {
    MyLocation myLocation = MyLocation();
    await myLocation.getyLocation();
    getWeatherData(
      lat: myLocation.lat2.toString(),
      lon: myLocation.lon2.toString(),
    );
  }

  Future<void> getWeatherData({
    @required String lat,
    @required String lon,
  }) async {
    var str =
        'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_openweatherkey&units=metric';
    print(str);
    Response response = await get(Uri.parse(str));

    if (response.statusCode == 200) {
      var data = response.body;
      var dataJson = jsonDecode(data);
      weatherData = await dataJson;
      //var ondo = jsonDecode(data)["id"];

      // string to json
      //print('data22 = $data');
      print('온도는 ${weatherData['main']['temp']}');
      print('는 ${weatherData['sys']['country']}');
      setState(() {
        test = double.parse('${weatherData['main']['temp']}');
        weather = weatherData['weather'][0]['icon'];
      });
    } else {
      print('response status code = ${response.statusCode}');
    }
  }

  double test = 0.0;
  var weather = '01d';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("홈"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            child: Center(
              child: Text(
                '오늘의 추천 코디',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 41,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.network(
                    'http://openweathermap.org/img/wn/${weather}@2x.png'),
                SizedBox(width: 0),
                Text(
                  '${test.toInt()}°',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3))
                  ]),
              child: _imageCount()),
          SizedBox(height: 20),
          GestureDetector(
              onTap: () {
                setState(() {
                  futureFiles = FirebaseApi.listAll(
                      FirebaseAuth.instance.currentUser.email.toString() +
                          '/cody/');
                  _imageCount();
                });
              },
              child: Icon(Icons.refresh_outlined))
        ],
      ),
      floatingActionButton: FabCircularMenu(
          ringDiameter: 300.0,
          ringWidth: 50.0,
          fabSize: 64.0,
          fabElevation: 8.0,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return Camera();
                      },
                    ),
                  );
                }),
            IconButton(
                icon: Icon(Icons.all_inbox_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return Cloth();
                      },
                    ),
                  );
                })
          ]),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              child: DrawerHeader(
                child: Text(
                  '사용자',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
                title: Text('로그아웃'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                }),
            Container(
              color: Colors.lightBlue[500],
              height: 50.0,
              child: Text(
                '스타일',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
                title: Text('목록'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return ClosetPage();
                      },
                    ),
                  );
                }),
            ListTile(
                title: Text('스타일 만들기'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return HomeView();
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _imageCount() {
    return SizedBox(
        child: FutureBuilder<List<FirebaseFile>>(
      future: futureFiles,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Center(child: Text('Some error occurred!'));
            } else {
              final files = snapshot.data;
              if (files.length > 0) {
                random = Random().nextInt(files.length);
                count = files.length;
                file = files[random];
              } else if (files.length == 0) {
                random = -1;
              }
              print(file);
              print('랜덤은${files.length}');
              return random >= 0
                  ? Image.network(file.url)
                  : Image.network(
                      'https://firebasestorage.googleapis.com/v0/b/cloth-9c0a6.appspot.com/o/%EC%88%98%EC%A0%95%EB%90%A8_300px-No_image_available.svg.png?alt=media&token=7672db7f-5e53-4dbe-835b-912c0b43714c');
            }
        }
      },
    ));
  }
}
