import 'package:cloth/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File _image;
  final picker = ImagePicker();
  var uuid = Uuid();

  get pickedFile => null;
  Future getImage(ImageSource source) async {
    final pickedFile =
        await picker.getImage(source: source /* ImageSource.gallery*/);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  var listText = [
    Text('상의'),
    Text('하의'),
    Text('아우터'),
    Text('원피스'),
    Text('신발'),
    Text('악세서리'),
  ];
  var listValue = [
    '상의',
    '하의',
    '아우터',
    '원피스',
    '신발',
    '악세서리',
  ];

  int selectedValue = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("의류 등록"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => showDialog(
                barrierColor: Colors.black26,
                context: context,
                builder: (context) {
                  return Dialog(
                    elevation: 0,
                    backgroundColor: Color(0xffffffff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 15),
                        Text(
                          "의류 등록",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Divider(
                          height: 1,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: InkWell(
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              getImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text(
                                "앨범에서 가져오기",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: InkWell(
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              getImage(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text(
                                "카메라로 찍기",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: InkWell(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0),
                            ),
                            highlightColor: Colors.grey[200],
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              child: SizedBox(
                width: 300,
                height: 300,
                child: _image == null
                    ? Image.asset('assets/images/123.png')
                    : Image.file(_image),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("분류"),
                  CupertinoButton(
                    onPressed: showPicker,
                    child: Text('${listValue[selectedValue]}'),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  try {
                    if (_image != null) {
                      FirebaseStorage.instance
                          .ref(FirebaseAuth.instance.currentUser.email
                                  .toString() +
                              '/${listValue[selectedValue]}' +
                              '/${uuid.v4()}' + // /붙여야 폴더
                              //rnd.toString() +
                              '.png')
                          .putFile(_image);
                      Toast.show("저장되었습니다.", context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    } else {
                      Toast.show("사진이없습니다.", context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    }
                  } on FirebaseException catch (e) {
                    // e.g, e.code == 'canceled'
                    print('error: $e');
                  }
                },
                child: Text("저장"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
