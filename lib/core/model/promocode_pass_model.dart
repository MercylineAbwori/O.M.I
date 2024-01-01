import 'package:flutter/foundation.dart';

class promoCodePassModal extends ChangeNotifier {

  num? userId;
  String? promotionCode;

  
  promoCodePassModal({
    required this.userId,
    required this.promotionCode,
    
  });


 factory promoCodePassModal.fromJson(Map<String, dynamic> json) {
    return promoCodePassModal(
      userId: json['userId'],
      promotionCode: json['promotionCode'],
    );
  }
}