import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:one_million_app/components/before_pages/claims/claims_home_page_screen.dart';
import 'package:one_million_app/components/before_pages/coverage/coverage_screen.dart';
import 'package:one_million_app/components/before_pages/profile/profile.dart';
import 'package:one_million_app/components/pages/default.dart';
import 'package:one_million_app/components/pages/home.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/components/before_pages/cores/model/claim_list_model.dart';
import 'package:one_million_app/components/before_pages/cores/model/policy_details.dart';
import 'package:one_million_app/home.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:http/http.dart' as http;


class CommonUIPage extends StatefulWidget {

  final num userId;
  final String name;
  final String msisdn;
  final String email;
  const CommonUIPage({super.key, required this.userId,
      required this.name,
      required this.msisdn,
      required this.email,});
  @override
  State<CommonUIPage> createState() => _CommonUIPageState();
}

class _CommonUIPageState extends State<CommonUIPage> {
  

  Widget? bodywidgets;

  int index = 0;


  @override
  void initState() {
    super.initState();

    bodywidgets = Home();
  } 


  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar( 
          
      ), 
      body: bodywidgets,
      drawer: Drawer( 
        child: ListView( 
          padding: EdgeInsets.zero, 
          children: [ 
            
            UserAccountsDrawerHeader(
              accountName: const Text('Oflutter.com',
              style: TextStyle(color: Colors.white),),
              accountEmail: const Text('example@gmail.com',
              style: TextStyle(color: Colors.white),),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset('assets/images/profile.jpeg',
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: ExactAssetImage('assets/images/profile_background.jpeg'),
                ),
              ),
            ),
            ListTile( 
              leading: const Icon(Icons.home_max), 
              title: const Text('Home '), 
              onTap: () { 
                setState(() {
                  bodywidgets = Home();
                });
              }, 
            ),
            
            // ListTile( 
            //   title: Padding(
            //     padding: const EdgeInsets.only(
            //             left: 15.0, right: 15.0, top: 15, bottom: 0),
            //     child: Hero(
            //           tag: "login_btn",
            //           child: ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //                 fixedSize: const Size(200, 40), backgroundColor: kSecondaryColor),
            //             onPressed: (){},
            //             child: const Text(
            //               'Log Out', style: TextStyle(color: Colors.white),
            //             ),
            //           ),
            //         ),
            //   ),
              
            // ), 
          ], 
        ), 
      ), 
    ); 
  }
}
