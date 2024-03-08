import 'package:flutter/foundation.dart';

class UserModal extends ChangeNotifier {
  String? name;
  String? email;
  String? phone;
  String? password;
  String? pin;
  String? drivinglicence;
  String? logbook;
  String? cardNo;
  String? username;
  String? expiryNo;
  String? cvv;

  int activeIndex = 0;
  int totalIndex = 4;

  changeStep(int index) {
    activeIndex = index;
    notifyListeners();
  }
}
