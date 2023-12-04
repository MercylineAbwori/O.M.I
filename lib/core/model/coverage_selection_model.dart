

import 'package:flutter/foundation.dart';

class coverageSelectionModal extends ChangeNotifier {

  num? userId;
  num? sumInsured;
  String? paymentPeriod;
  num? paymentAmount;

  coverageSelectionModal({
    required this.userId,
    required this.sumInsured,
    required this.paymentPeriod,
    required this.paymentAmount,
    
  });


 factory coverageSelectionModal.fromJson(Map<String, dynamic> json) {
    return coverageSelectionModal(
      userId: json['userId'],
      sumInsured: json['sumInsured'],
      paymentPeriod: json['paymentPeriod'],
      paymentAmount: json['paymentAmount'],
    );
  }
}