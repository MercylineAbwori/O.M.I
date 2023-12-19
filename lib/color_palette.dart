import 'package:flutter/material.dart'; 

class Palette { 
  static MaterialColor kToDark = const MaterialColor( 
    0xFF7C4DFF, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch. 
    { 
      50: const Color(0xFF7C4DFF),//10% 
      100: const Color(0xFF7C4DFF),//20% 
      200: const Color(0xFF651FFF),//30% 
      300: const Color(0xFF6200EA),//40% 
      400: const Color(0xff733024),//50% 
      500: const Color(0xff5c261d),//60% 
      600: const Color(0xff451c16),//70% 
      700: const Color(0xff2e130e),//80% 
      800: const Color(0xff170907),//90% 
      900: const Color(0xff000000),//100% 
    }, 
  ); 
} 