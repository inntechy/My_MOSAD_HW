import 'package:flutter/material.dart';
import 'pages/main_screen.dart';
import 'pages/vol_list_page.dart';
import 'pages/favorite_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'One',
        theme: ThemeData(primaryColor: Colors.white),
        home: MyAppFragment());
  }
}

class MyAppFragment extends StatefulWidget {
  @override
  createState() => MyAppFragmentState();
}

class MyAppFragmentState extends State<MyAppFragment> {
  int _selectedIndex = 0;
  final _pageController = PageController();
  final _mainScreen = MainScreen();

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  void _selectOneVol(int vol) {
    // 跳回主页
    _onItemTapped(0);
    _mainScreen.switchToVol(vol);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 3,
        onPageChanged: (index){
          _selectedIndex=index;
          setState(() {});
        },
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return _mainScreen;
            case 1:
              return VolListPage(_selectOneVol);
            case 2:
              return FavoritePage();
            default:
              return _mainScreen;
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("ONE")),
          BottomNavigationBarItem(icon: Icon(Icons.menu), title: Text("ALL")),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),title: Text("ME")),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}