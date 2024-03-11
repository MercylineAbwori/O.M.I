

import 'package:flutter/material.dart';

class DefaultPage extends StatefulWidget {
  
  DefaultPage({super.key, 
  
  });


  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {
  
  @override
  Widget build(BuildContext context) {

    
    return const Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(child: Text("Default"))
          ],
        ),
      ),

    );
  }
 
}
