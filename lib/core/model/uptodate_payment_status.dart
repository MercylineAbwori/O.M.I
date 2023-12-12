import 'package:flutter/material.dart';

class UptodatePaymentStatusModal extends ChangeNotifier {

  String? userId;

  
  UptodatePaymentStatusModal({
    required this.userId,
    
  });


 factory UptodatePaymentStatusModal.fromJson(Map<String, dynamic> json) {
    return UptodatePaymentStatusModal(
      userId: json['userId'],
    );
  }
}