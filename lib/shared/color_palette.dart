import 'package:flutter/material.dart'; 

class Palette { 
  static MaterialColor kToDark = const MaterialColor( 
    0xFF7C4DFF, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch. 
    { 
      50: Color(0xFF9575CD),//10% 
      100: Color(0xFF7E57C2),//20% 
      200: Color(0xFFB388FF),//30% 
      300: Color(0xFF7C4DFF),//40% 
      400: Color(0xFF651FFF),//50% 
      500: Color(0xFF6200EA),//60% 
      600: Color(0xFF5E35B1),//70% 
      700: Color(0xFF512DA8),//80% 
      800: Color(0xFF4527A0),//90% 
      900: Color(0xFF311B92),//100% 
    }, 
  ); 

  //deepPurple
  static Color get deepPurple => Color(0xFF673AB7);
  static Color get deepPurpleLighten5 => Color(0xFFEDE7F6);
  static Color get deepPurpleLighten4 => Color(0xFFD1C4E9);
  static Color get deepPurpleLighten3 => Color(0xFFB39DDB);
  static Color get deepPurpleLighten2 => Color(0xFF9575CD);
  static Color get deepPurpleLighten1 => Color(0xFF7E57C2);
  static Color get deepPurpleDarken1 => Color(0xFF5E35B1);
  static Color get deepPurpleDarken2 => Color(0xFF512DA8);
  static Color get deepPurpleDarken3 => Color(0xFF4527A0);
  static Color get deepPurpleDarken4 => Color(0xFF311B92);
  static Color get deepPurpleAccent1 => Color(0xFFB388FF);
  static Color get deepPurpleAccent2 => Color(0xFF7C4DFF);
  static Color get deepPurpleAccent3 => Color(0xFF651FFF);
  static Color get deepPurpleAccent4 => Color(0xFF6200EA);
} 