import 'package:flutter/material.dart';

class MpesaPaymentModal extends ChangeNotifier {

  String? amount;
  String? userId;
  String? phoneNumber;

  
  MpesaPaymentModal({
    required this.amount,
    required this.userId,
    required this.phoneNumber,
    
  });


 factory MpesaPaymentModal.fromJson(Map<String, dynamic> json) {
    return MpesaPaymentModal(
      amount: json['amount'],
      userId: json['userId'],
      phoneNumber: json['phoneNumber'],
    );
  }
}