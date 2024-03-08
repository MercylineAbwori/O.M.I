

import 'package:flutter/foundation.dart';

class notificationTotalModal extends ChangeNotifier {

  num? userId;

  notificationTotalModal({
    required this.userId,
    
  });


 factory notificationTotalModal.fromJson(Map<String, dynamic> json) {
    return notificationTotalModal(
      userId: json['userId'],
    );
  }
}