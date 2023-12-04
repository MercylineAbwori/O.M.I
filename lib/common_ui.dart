
import 'package:flutter/material.dart';
import 'package:one_million_app/components/claims/claims_home_page_screen.dart';
import 'package:one_million_app/components/coverage/coverage_screen_page.dart';
import 'package:one_million_app/components/profile/profile.dart';
import 'package:one_million_app/home.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class CommonUIPage extends StatefulWidget {
  @override
  _CommonUIPageState createState() => _CommonUIPageState();
}

class _CommonUIPageState extends State<CommonUIPage> {
  int _selectedIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new HomePage();
      case 1:
        return new CoveragePage();
      case 2:
        return new ClaimHomePage();
      case 3:
        return new ProfileScreen();

      default:
        return new HomePage();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:_getDrawerItemWidget(_selectedIndex),
      ),
      bottomNavigationBar: TitledBottomNavigationBar(// Use this to update the Bar giving a position
      
        currentIndex: _selectedIndex,
        // selectedItemColor: kPrimaryWhiteColor,
        onTap: _onItemTapped,
        items: [
            TitledNavigationBarItem(title: Text('Home'), icon: Icon(Icons.home)),
            TitledNavigationBarItem(title: Text('Coverage'), icon: Icon(Icons.business)),
            TitledNavigationBarItem(title: Text('Claim'), icon: Icon(Icons.payment)),
            TitledNavigationBarItem(title: Text('Profile'), icon: Icon(Icons.person))
        ]
      )
    );
  }
}
