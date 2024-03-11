class notificationCountItem {
  const notificationCountItem({

  required this.count,

  });

  final num count;
}

class notificationCountModel {
  num notification_count = 0;
  bool isLoading = false;
  String error = '';

 notificationCountModel.initial();
}
