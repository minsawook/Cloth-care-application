import 'dart:typed_data';
import 'package:cloth/clotharray/cloths_select.dart';
import 'package:cloth/style/data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:screenshot/screenshot.dart';
import 'package:toast/toast.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  List<Widget> movableItems = [];
  List<Data> dataList = [];
  Data data;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var listText = [
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
    Text('spring'),
    Text('summer'),
    Text('autumn'),
    Text('winter'),
  ];

  var seasonListValue = [
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
        title: Text(
          '코디만들기',
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Cloth_select(
                            movableItems: movableItems, data: data)));
                setState(() {});
                dataList.add(data);
              }),
          IconButton(
              icon: Icon(Icons.save_outlined),
              onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                        title: Text('코디 저장'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('코디를 저장하시겠습니까?'),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("계절 : "),
                                      CupertinoButton(
                                        onPressed: seasonShowPicker,
                                        child: Text(
                                            '${seasonListValue[seasonSelectedValue]}'),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("스타일 : "),
                                      CupertinoButton(
                                        onPressed: showPicker,
                                        child:
                                            Text('${listValue[selectedValue]}'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      screenshotController
                                          .capture(
                                              delay: Duration(milliseconds: 10))
                                          .then((capturedImage) async {
                                        firestore.collection('cody').doc().set({
                                          "계절": seasonListValue[
                                              seasonSelectedValue],
                                          "스타일": listValue[selectedValue],
                                          "룩": '${DateTime.now()}.png',
                                        });
                                        showCapturedWidget(
                                            context, capturedImage);

                                        Toast.show("저장되었습니다.", context,
                                            duration: Toast.LENGTH_SHORT,
                                            gravity: Toast.BOTTOM);
                                      }).catchError((onError) {
                                        print(onError);
                                      });
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text('저장')),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('취소'))
                              ],
                            ),
                          ),
                        ],
                      ))),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete_forever)),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Stack(
          children: movableItems,
        ),
      ),
    );
  }

  Future<dynamic> showCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return FirebaseStorage.instance
        .ref('cody' +
            '/${DateTime.now()}' + // /붙여야 폴더
            '.png')
        .putData(capturedImage);
  }
}
