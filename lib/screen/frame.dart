import 'dart:convert';
import 'dart:developer';
import 'package:cloth/camera/camera.dart';
import 'package:cloth/style/stylelist.dart';
import 'package:cloth/style/stylemake.dart';
import 'package:cloth/clotharray/cloths.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var weatherData;
  final _openweatherkey = '2db2f66ff4c3c59a8ede85ea41cecfb6';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosition();
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
      log('$dataJson');
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
  /*int _selectedIndex = 1;

  List<Widget> _bodyScreen = [
    MenuPage(),
    HomePage(),
    ClosetPage(),
    ProfilePage()
  ];
*/
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
            child: SizedBox(
              height: 200,
              width: 200,
              child: Image.asset('assets/images/main_cloth.png'),
            ),
          ),
        ],
      ),
      /*_bodyScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 12,
        currentIndex: _selectedIndex, //현재 선택된 Index
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: '메뉴',
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: '홈',
            icon: Icon(Icons.music_note),
          ),
          BottomNavigationBarItem(
            label: '옷장',
            icon: Icon(Icons.location_on),
          ),
          BottomNavigationBarItem(
            label: '내정보',
            icon: Icon(Icons.library_books),
          ),
        ],
      ),
      */
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
}
