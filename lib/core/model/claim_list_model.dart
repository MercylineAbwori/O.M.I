
import 'dart:io';

import 'package:flutter/material.dart';

class ClaimListModal extends ChangeNotifier {
  
  num? userId;


  int activeIndex = 0;
  int totalIndex = 3;

  changeStep(int index) {
    activeIndex = index;
    notifyListeners();
  }
}



