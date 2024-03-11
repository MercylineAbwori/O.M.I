import 'package:flutter/material.dart';
import 'package:one_million_app/shared/color_palette.dart';
import 'package:one_million_app/splash_screen.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {

  runApp(ProviderScope(child: MyApp()));
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    
    
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      theme: ThemeData(
        fontFamily: 'Raleway',
        primarySwatch: Palette.kToDark
        
      ),
    
      //TODO Bottom navigation to be constant. Check your bookmarks
      home: MyHomePage(),
    
      // home: AccorditionPage(),
    );
  }
}