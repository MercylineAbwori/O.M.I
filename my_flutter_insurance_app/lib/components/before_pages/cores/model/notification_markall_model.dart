import 'package:flutter/foundation.dart';

class markAllModal extends ChangeNotifier {

  num? userId;

  
   markAllModal({
    required this.userId,
    
  });


 factory  markAllModal.fromJson(Map<String, dynamic> json) {
    return  markAllModal(
      userId: json['userId'],
    );
  }
}