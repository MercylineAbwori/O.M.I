import 'package:flutter/foundation.dart';

class markAsReadModal extends ChangeNotifier {
  num? userId;
  num? notificationId;

  markAsReadModal({
    required this.userId,
    required this.notificationId,
  });

  factory markAsReadModal.fromJson(Map<String, dynamic> json) {
    return markAsReadModal(
      userId: json['userId'],
      notificationId: json['notificationId'],
    );
  }
}
