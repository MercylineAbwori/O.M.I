

import 'package:flutter/foundation.dart';

class UserLoginModal extends ChangeNotifier {

  String? msisdn;
  String? pin;

  UserLoginModal({
    required this.msisdn,
    required this.pin,
    
  });


 factory UserLoginModal.fromJson(Map<String, dynamic> json) {
    return UserLoginModal(
      msisdn: json['msisdn'],
      pin: json['pin'],
    );
  }
}