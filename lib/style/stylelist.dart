import 'package:cloth/fb/fb_api.dart';
import 'package:cloth/fb/fb_file.dart';
import 'package:cloth/style/data.dart';
import 'package:cloth/style/stylemake.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClosetPage extends StatefulWidget {
  ClosetPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ClosetPageState createState() => _ClosetPageState();
}

class _ClosetPageState extends State<ClosetPage> {
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<List<FirebaseFile>> futureFiles;

  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll('cody/');
  }

  var listText = [
    Text('all'),
    Text('lovely'),
    Text('vintage'),
    Text('hip'),
    Text('casual'),
    Text('mordern'),
    Text('amekaji'),
    Text('minimalist'),
    Text('kitsch'),
  ];

  var listValue = [
    'all',
    'lovely',
    'vintage',
    'hip',
    'casual',
    'mordern',
    'amekaji',
    'minimalist',
    'kitsch',
  ];

  var seasonListText = [
    Text('all'),
    Text('spring'),
    Text('summer'),
    Text('autumn'),
    Text('winter'),
  ];

  var seasonListValue = [
    'all',
    'spring',
    'summer',
    'autumn',
    'winter',
  ];

  seasonShowPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoPicker(
            backgroundColor: Colors.white,
            onSelectedItemChanged: (value) {
              setState(() {
                seasonSelectedValue = value;
              });
            },
            itemExtent: 32.0,
            children: seasonListText,
          );
        });
  }

  showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoPicker(
            backgroundColor: Colors.white,
            onSelectedItemChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
            itemExtent: 32.0,
            children: listText,
          );
        });
  }

  int selectedValue = 0;
  int seasonSelectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("스타일목록"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeView()));
              },
              icon: Icon(Icons.add_box_sharp)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  CupertinoButton(
                    onPressed: seasonShowPicker,
                    child: Text('${seasonListValue[seasonSelectedValue]}'),
                  ),
                  CupertinoButton(
                    onPressed: showPicker,
                    child: Text('${listValue[selectedValue]}'),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height) * 0.8,
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

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* buildHeader(files.length), //위에 파일 갯수 표시
                      const SizedBox(height: 12),*/

                            Expanded(
                              child: GridView.builder(
                                itemCount: files.length,
                                padding: EdgeInsets.all(10),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 20.0,
                                        mainAxisSpacing: 10.0),
                                itemBuilder: (context, index) {
                                  final file = files[index];
                                  return buildFile(context, file);
                                },
                              ),
                            ),
                          ],
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFile(
    BuildContext context,
    FirebaseFile file,
  ) =>
      InkWell(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: Image.network(
              file.url,
            ),
          ),
          onTap: () {});
}
