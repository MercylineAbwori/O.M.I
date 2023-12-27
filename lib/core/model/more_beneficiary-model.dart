

import 'package:flutter/foundation.dart';

class AddMoreBeneficiaryModal extends ChangeNotifier {

  String? userId;

  
  AddMoreBeneficiaryModal({
    required this.userId,
    
  });


 factory AddMoreBeneficiaryModal.fromJson(Map<String, dynamic> json) {
    return AddMoreBeneficiaryModal(
      userId: json['userId'],
    );
  }
}