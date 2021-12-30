import 'package:cloth/main.dart';
import 'package:cloth/style/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloth/data/saved_notifier.dart';

class MoveableStackItem extends StatefulWidget {
  const MoveableStackItem({Key key, this.url, this.data}) : super(key: key);
  final String url;
  final Data data;
  @override
  State<StatefulWidget> createState() {
    return _MoveableStackItemState();
  }
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition = 0;
  double yPosition = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
          onPanUpdate: (tapInfo) {
            setState(() {
              xPosition += tapInfo.delta.dx;
              yPosition += tapInfo.delta.dy;
            });
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: (MediaQuery.of(context).size.height) * 0.3,
            child: Image.network(widget.url),
          )),
    );
  }
}
