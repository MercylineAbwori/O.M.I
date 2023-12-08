import 'package:flutter/material.dart';
import 'package:one_million_app/components/claims/claims_home_page_screen.dart';
import 'package:one_million_app/components/coverage/coverage_screen_page.dart';
import 'package:one_million_app/components/profile/profile.dart';
import 'package:one_million_app/home.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class CommonUIPage extends StatefulWidget {
  final num userId;
  final String name;
  final String msisdn;
  final String email;

  CommonUIPage({
    Key? key,
    required this.userId,
    required this.name,
    required this.msisdn,
    required this.email,
  }) : super(key: key);
  @override
  _CommonUIPageState createState() => _CommonUIPageState();
}

class _CommonUIPageState extends State<CommonUIPage> {
  int _selectedIndex = 0;


  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomePage(userName: widget.name, 
          userId: widget.userId,
          phone: widget.msisdn, 
          email: widget.email,);
      case 1:
        return CoveragePage(
          userName: widget.name, 
          userId: widget.userId,
          phone: widget.msisdn, 
          email: widget.email,
        );
      case 2:
        return ClaimHomePage(
          userName: widget.name, 
          userId: widget.userId,
          phone: widget.msisdn, 
          email: widget.email,
        );
      case 3:
        return ProfileScreen(
          userName: widget.name, 
          userId: widget.userId,
          phone: widget.msisdn, 
          email: widget.email,
        );

      default:
        return new HomePage(
          userName: widget.name, 
          userId: widget.userId,
          phone: widget.msisdn, 
          email: widget.email,);
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
          child: _getDrawerItemWidget(_selectedIndex),
        ),
        bottomNavigationBar: TitledBottomNavigationBar(
            // Use this to update the Bar giving a position

            currentIndex: _selectedIndex,
            // selectedItemColor: kPrimaryWhiteColor,
            onTap: _onItemTapped,
            items: [
              TitledNavigationBarItem(
                  title: Text('Home'), icon: Icon(Icons.home)),
              TitledNavigationBarItem(
                  title: Text('Coverage'), icon: Icon(Icons.business)),
              TitledNavigationBarItem(
                  title: Text('Claim'), icon: Icon(Icons.payment)),
              TitledNavigationBarItem(
                  title: Text('Profile'), icon: Icon(Icons.person))
            ]));
  }
}
