import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:one_million_app/common_ui_pages.dart';
import 'package:one_million_app/components/auth/onbording_screens/welcome_screen.dart';
import 'package:one_million_app/shared/constants.dart';


class MyHomePage extends StatefulWidget { 
  @override 
  _MyHomePageState createState() => _MyHomePageState(); 
} 
class _MyHomePageState extends State<MyHomePage> { 


  @override 
  void initState() { 
    super.initState(); 
    checkForUpdate();
    Timer(Duration(seconds: 3), 
    ()=>Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: 
        (context) => 
        // CommonUIPage(userId: 1, name: "Mercyline Achieng", email: "mercylineachieng99@gmail.com", phoneNo: "+254723017215")
         const WelcomeScreen()
        ) 
      ) 
    ); 
  } 

  Future<void> checkForUpdate() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          print('update available');
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/signup.png', 
                  height: 200, width: 200),
                  const SizedBox(height: 15),
                  const Text(
                    "O.M.I",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Insurance"
                    ,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Its my life! ', 
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black),
                    // style: GoogleFonts.bebasNeue(fontSize: 72),
                  ),

                  const SizedBox(height: 30),
                  
                  Column(
                    children: [
                      Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: const Text(
                            '© 2024 One Million Technologies.', 
                            style: TextStyle(
                                fontSize: 15,
                                color: kPrimaryColor),
                            // style: GoogleFonts.bebasNeue(fontSize: 72),
                          ),
                        ),
                      ),
                      Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: const Text(
                            'All rights reserved.', 
                            style: TextStyle(
                                fontSize: 15,
                                color: kPrimaryColor),
                            // style: GoogleFonts.bebasNeue(fontSize: 72),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
              
            ),
          ),

      )
      
    ); 
  } 
} 
