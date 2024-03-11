import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/core/services/models/notification_model.dart';

class NotificationListListNotifier
    extends StateNotifier<notificationListModel> {
  NotificationListListNotifier() : super(notificationListModel.initial());

  Future<void> _processResponse(http.Response response) async {
    print("***************************** Response Notification List called");
    print("Response status: ${response.statusCode}");

    if (response.statusCode >= 400) {
      state.error = 'Error loading groceries';
      state.isLoading = false;
      return;
    }

    if (response.body == 'null') {
      state.isLoading = false;
      return;
    }

    final Map<String, dynamic> listData = json.decode(response.body);

    final List<notificationListItem> loadedItems = [];

    var obj = jsonDecode(response.body);

    var _data;

    obj.forEach((key, value) {
      _data = obj["result"]["data"];
    });

    // log("Data : ${_data}");

    var createdAt = _data.map((result) => result["createdAt"]).toList();
    var date = _data.map((result) => result["date"]).toList();
    var id = _data.map((result) => result["id"]).toList();
    var message = _data.map((result) => result["message"]).toList();
    var readStatus = _data.map((result) => result["readStatus"]).toList();
    var status = _data.map((result) => result["status"]).toList();
    var type = _data.map((result) => result["type"]).toList();
    var updatedAt = _data.map((result) => result["updatedAt"]).toList();

    //userDetails:

    var userDetailscreatedAt =
        _data.map((result) => result["userDetails"]["createdAt"]).toList();
    var userDetailsemail =
        _data.map((result) => result["userDetails"]["email"]).toList();
    var userDetailsgender =
        _data.map((result) => result["userDetails"]["gender"]).toList();
    var userDetailsmsisdn =
        _data.map((result) => result["userDetails"]["msisdn"]).toList();
    var userDetailsname =
        _data.map((result) => result["userDetails"]["name"]).toList();
    var userDetailspin =
        _data.map((result) => result["userDetails"]["pin"]).toList();
    var userDetailsupdatedAt =
        _data.map((result) => result["userDetails"]["updatedAt"]).toList();
    var userDetailsuserId =
        _data.map((result) => result["userDetails"]["userId"]).toList();

    for (var i = 0; i < _data.length; i++) {
      loadedItems.add(notificationListItem(
          createdAt: createdAt[i],
          date: date[i],
          id: id[i],
          message: message[i],
          readStatus: readStatus[i],
          status: status[i],
          type: type[i],
          updatedAt: updatedAt[i],

          //userDetails:

          userDetailscreatedAt: userDetailscreatedAt[i],
          userDetailsemail: userDetailsemail[i],
          userDetailsgender: userDetailsgender[i],
          userDetailsmsisdn: userDetailsmsisdn[i],
          userDetailsname: userDetailsname[i],
          userDetailspin: userDetailspin[i],
          userDetailsupdatedAt: userDetailsupdatedAt[i],
          userDetailsuserId: userDetailsuserId[i]));
    }

    addNotificationListItems(loadedItems);
  }

  Future<void> fetchNotificationList() async {
    state.isLoading = true;
    state.error = '';

    // // num userId = await LocalStorage().getUserRegNo();
    num userId = 1;

    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.notificationEndpoint);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({"userId": userId});

    http.post(url, headers: headers, body: body).then((response) {
      _processResponse(response);
    });
  }

  void addNotificationListItems(List<notificationListItem> items) {
    var sListModel = notificationListModel.initial();

    sListModel.notification_list = items;
    sListModel.isLoading = state.isLoading;
    sListModel.error = state.error;

    state = sListModel;
  }
}

final notificationListListProvider =
    StateNotifierProvider<NotificationListListNotifier, notificationListModel>(
        (ref) {
  return NotificationListListNotifier();
});
