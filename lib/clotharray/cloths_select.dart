import 'package:category_picker/category_picker_item.dart';
import 'package:cloth/data/data.dart';
import 'package:cloth/style/stylemake2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:category_picker/category_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloth/fb/fb_api.dart';
import 'package:cloth/fb/fb_file.dart';

class Cloth_select extends StatefulWidget {
  const Cloth_select({Key key, this.movableItems, this.data}) : super(key: key);
  final List<Widget> movableItems;
  final Data data;
  @override
  _Cloth_selectState createState() => _Cloth_selectState();
}

class _Cloth_selectState extends State<Cloth_select> {
  String n = '상의';
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<List<FirebaseFile>> futureFiles;
  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll(
        FirebaseAuth.instance.currentUser.email.toString() +
            '/${n.toString()}/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("옷장")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CategoryPicker(
              items: [
                CategoryPickerItem(
                  value: "top",
                  label: '상의',
                ),
                CategoryPickerItem(value: "bottom", label: '하의'),
                CategoryPickerItem(value: "outer", label: '아우터'),
                CategoryPickerItem(value: "onepiece", label: '원피스'),
                CategoryPickerItem(value: "shose", label: '신발'),
                CategoryPickerItem(value: "accessories", label: '악세서리'),
              ],
              onValueChanged: (value) {
                print(value.label);
                switch (value.label) {
                  case '상의':
                    n = '상의';
                    print(n);
                    break;
                  case '하의':
                    n = '하의';
                    break;
                  case '아우터':
                    n = '아우터';
                    break;
                  case '원피스':
                    n = '원피스';
                    break;
                  case '신발':
                    n = '신발';
                    break;
                  case '악세서리':
                    n = '악세서리';
                    break;
                }
                setState(() {});
                futureFiles = FirebaseApi.listAll(
                    FirebaseAuth.instance.currentUser.email.toString() +
                        '/${n.toString()}/');
              },
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
                                        crossAxisSpacing: 4.0,
                                        mainAxisSpacing: 4.0),
                                itemBuilder: (context, index) {
                                  final file = files[index];
                                  return buildFile(context, file, widget.data);
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

  Widget buildFile(BuildContext context, FirebaseFile file, Data data) =>
      InkWell(
          child: Image.network(
            file.url,
          ),
          onTap: () {
            setState(() {
              widget.movableItems
                  .add(MoveableStackItem(url: file.url, data: data));
            });
            Navigator.pop(context);
          });
}
