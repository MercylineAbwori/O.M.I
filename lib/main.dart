import 'package:flutter/material.dart';
import 'package:one_million_app/color_palette.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:one_million_app/splash_screen.dart';
void main() => runApp(const MyApp());



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Palette.kToDark
        
      ),
      home: MyHomePage(),

      // home: AccorditionPage(),
    );
  }
}