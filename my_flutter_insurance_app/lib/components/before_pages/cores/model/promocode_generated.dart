import 'package:flutter/foundation.dart';

class promoCodeGeneratedModal extends ChangeNotifier {

  num? userId;

  
  promoCodeGeneratedModal({
    required this.userId,
    
  });


 factory promoCodeGeneratedModal.fromJson(Map<String, dynamic> json) {
    return promoCodeGeneratedModal(
      userId: json['userId']
    );
  }
}