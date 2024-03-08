

import 'package:flutter/foundation.dart';

class ResetPasswordModal extends ChangeNotifier {

  String? msisdn;
  String? pin;

  ResetPasswordModal({
    required this.msisdn,
    required this.pin,
    
  });


 factory ResetPasswordModal.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModal(
      msisdn: json['msisdn'],
      pin: json['pin'],
    );
  }
}