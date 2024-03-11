class notificationListItem {
  const notificationListItem({

  required this.createdAt,
  required this.date,
  required this.id,
  required this.message,
  required this.readStatus,
  required this.status,
  required this.type,
  required this.updatedAt,

  //userDetails:

  required this.userDetailscreatedAt,
  required this.userDetailsemail,
  required this.userDetailsgender,
  required this.userDetailsmsisdn,
  required this.userDetailsname,
  required this.userDetailspin,
  required this.userDetailsupdatedAt,
  required this.userDetailsuserId,

  });

  final String createdAt;
  final String date;
  final num id;
  final String message;
  final String readStatus;
  final String status;
  final String type;
  final String updatedAt;

  //userDetails:

  final String userDetailscreatedAt;
  final String userDetailsemail;
  final String userDetailsgender;
  final String userDetailsmsisdn;
  final String userDetailsname;
  final String userDetailspin;
  final String userDetailsupdatedAt;
  final num userDetailsuserId;
}

class notificationListModel {
  List<notificationListItem> notification_list = [];
  bool isLoading = false;
  String error = '';

 notificationListModel.initial();
}
