

import 'package:flutter/foundation.dart';

class defaultPolicyPayModal extends ChangeNotifier {

  num? userId;
  String? promotionCode;

  
  defaultPolicyPayModal({
    required this.userId,
    required this.promotionCode,
    
  });


 factory defaultPolicyPayModal.fromJson(Map<String, dynamic> json) {
    return defaultPolicyPayModal(
      userId: json['userId'],
      promotionCode: json['promotionCode'],
    );
  }
}