import 'dart:io';

import 'package:flutter/foundation.dart';

class UserRegistrationModal extends ChangeNotifier {

  String? msisdn;
  String? pin;
  String? confirmPin;
  String? email;
  String? gender;
  String? dateOfBirth;

  int activeIndex = 0;
  int totalIndex = 4;

  changeStep(int index) {
    activeIndex = index;
    notifyListeners();
  }

  UserRegistrationModal({
    required this.msisdn,
    required this.pin,
    required this.confirmPin,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    
  });


 factory UserRegistrationModal.fromJson(Map<String, dynamic> json) {
    return UserRegistrationModal(
      msisdn: json['msisdn'],
      pin: json['pin'],
      confirmPin: json['confirmPin'],
      email: json['email'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
    );
  }
}