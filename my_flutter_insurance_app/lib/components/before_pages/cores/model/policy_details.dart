import 'package:flutter/material.dart';

class PolicyDetailsModal extends ChangeNotifier {

  String? userId;

  
  PolicyDetailsModal({
    required this.userId,
    
  });


 factory PolicyDetailsModal.fromJson(Map<String, dynamic> json) {
    return PolicyDetailsModal(
      userId: json['userId'],
    );
  }
}