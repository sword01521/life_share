import 'package:blooddonate/src/ui/profile.dart';
import 'package:blooddonate/src/ui/search_blood.dart';
import 'package:flutter/material.dart';

import 'newsfeed.dart';
import 'notifications.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _pages = [
    NewsFeed(),
    SearchBlood(),
    Notifications(),
    Profile()
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        elevation: 6,
        onTap: (index){
          setState(() {
            selectedIndex = index;
          });
        },
        currentIndex: selectedIndex,
        unselectedIconTheme: IconThemeData(
          color: Colors.black87,
        ),
        selectedItemColor: Colors.red,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            title: Text('Newsfeed'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            title: Text('Notifications'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          )
        ],
      ),
      body: _pages[selectedIndex],
    );
  }
}
