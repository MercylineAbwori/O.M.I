import 'dart:io';

import 'package:flutter/foundation.dart';

class UserRegistrationOTPModal extends ChangeNotifier {

  String? msisdn;

  UserRegistrationOTPModal({
    required this.msisdn,
    
  });


 factory UserRegistrationOTPModal.fromJson(Map<String, dynamic> json) {
    return UserRegistrationOTPModal(
      msisdn: json['msisdn'],
    );
  }
}