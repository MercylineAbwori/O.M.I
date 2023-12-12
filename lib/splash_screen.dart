import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_million_app/components/onbording_screens/welcome_screen.dart';

class MyHomePage extends StatefulWidget { 
  @override 
  _MyHomePageState createState() => _MyHomePageState(); 
} 
class _MyHomePageState extends State<MyHomePage> { 
  @override 
  void initState() { 
    super.initState(); 
    Timer(Duration(seconds: 3), 
    ()=>Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: 
        (context) =>  
         const WelcomeScreen()
        ) 
      ) 
    ); 
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
                    "One Million Insurance",
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
              ],
              
            ),
          ),

      )
      
    ); 
  } 
} 
