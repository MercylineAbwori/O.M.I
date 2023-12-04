


import 'package:flutter/foundation.dart';

class UserRegistrationOTPVerifyModal extends ChangeNotifier {

  num? userId;
  String? otp;

  int activeIndex = 0;
  int totalIndex = 4;

  changeStep(int index) {
    activeIndex = index;
    notifyListeners();
  }

  UserRegistrationOTPVerifyModal({
    required this.userId,
    required this.otp,
    
  });


 factory UserRegistrationOTPVerifyModal.fromJson(Map<String, dynamic> json) {
    return UserRegistrationOTPVerifyModal(
      userId: json['userId'],
      otp: json['otp'],
    );
  }
}