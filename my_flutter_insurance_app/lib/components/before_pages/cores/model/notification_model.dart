

import 'package:flutter/foundation.dart';

class NotificationModal extends ChangeNotifier {

  num? userId;


  NotificationModal({
    required this.userId,
    
  });


 factory NotificationModal.fromJson(Map<String, dynamic> json) {
    return NotificationModal(
      userId: json['userId'],
    );
  }
}