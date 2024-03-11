import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/core/services/models/fetch_profile_model.dart';
import 'package:one_million_app/core/services/models/notifications_counts_model.dart';

class ProfilePicNotifier
    extends StateNotifier<profilePicModel> {
  ProfilePicNotifier() : super(profilePicModel.initial());

  Future<void> _processResponse(http.Response response) async {
    print("***************************** Response Notification Count called");
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

    final num loadedItems = 0;

    var obj = jsonDecode(response.body);

    var _data;

     obj.forEach((key, value) {
        _data = obj["result"]["data"]["url"];
      });
    log("Data : ${_data}");


    addprofilePicItems(_data);
  }

  Future<void> fetchprofilePic() async {
    state.isLoading = true;
    state.error = '';

    // num userId = await LocalStorage().getUserRegNo();
    num userId = 1;
    var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.fetchProfileEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        // "userId": userId,
        "userId": userId,
        "documentName": "profile"
      });


    http.post(url, headers: headers, body: body).then((response) {
      _processResponse(response);
    });
  }

  void addprofilePicItems(String items) {
    var sListModel = profilePicModel.initial();

    sListModel.profile_url = items;
    sListModel.isLoading = state.isLoading;
    sListModel.error = state.error;

    state = sListModel;
  }
}

final profilePicProvider = StateNotifierProvider<
    ProfilePicNotifier, profilePicModel>((ref) {
  return ProfilePicNotifier();
});
