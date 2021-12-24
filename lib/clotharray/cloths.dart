import 'package:category_picker/category_picker_item.dart';
import 'package:flutter/material.dart';
import 'package:category_picker/category_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloth/fb/fb_api.dart';
import 'package:cloth/fb/fb_file.dart';

class Cloth extends StatefulWidget {
  @override
  _ClothState createState() => _ClothState();
}

class _ClothState extends State<Cloth> {
  String n = '상의';
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<List<FirebaseFile>> futureFiles;
  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll('${n.toString()}/');
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
                futureFiles = FirebaseApi.listAll('${n.toString()}/');
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

  Widget buildFile(BuildContext context, FirebaseFile file) => InkWell(
      child: Image.network(
        file.url,
      ),
      onTap: () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                title: Text('등록된 의류 삭제'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('등록된 의류을 정말 삭제하시겠습니까?'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await FirebaseStorage.instance
                              .ref()
                              .child('/${n.toString()}/' + '${file.name}')
                              .delete();
                          Navigator.of(context).pop();
                          setState(() {
                            futureFiles =
                                FirebaseApi.listAll('${n.toString()}/');
                          });
                        } catch (e) {
                          debugPrint('Error : $e');
                        }
                      },
                      child: Text('삭제')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('취소'))
                ],
              ))
      /* onTap: () => Navigator.of(context).push(MaterialPageRoute( //누르면 전체화면으로 보기
          builder: (context) => ImagePage(file: file),
        ),),*/
      );
}
