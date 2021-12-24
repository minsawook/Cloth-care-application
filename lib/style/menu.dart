/*
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';


class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Text(
            '메뉴',
          ),
        ),
        floatingActionButton: FabCircularMenu(
          children: <Widget>[
            IconButton(icon: Icon(Icons.home), onPressed: () {
              print('Home');
            }),
            IconButton(icon: Icon(Icons.favorite), onPressed: () {
              print('Favorite');
            })
          ]
        )
        );
  }
}
*/