import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/core/services/models/claim_lists_model.dart';

class ClaimsListNotifier extends StateNotifier<claimListModel> {
  ClaimsListNotifier() : super(claimListModel.initial());

  Future<void> _processResponse(http.Response response) async {
    print("***************************** Response Claims called");
    print("Response status: ${response.statusCode}");

    if (response.statusCode >= 400) {
      state.error = 'Error loading';
      state.isLoading = false;
      return;
    }

    if (response.body == 'null') {
      state.isLoading = false;
      return;
    }

    final Map<String, dynamic> listData = json.decode(response.body);

    final List<claimListItem> loadedItems = [];

    var obj = jsonDecode(response.body);

    var _data;

    obj.forEach((key, value) {
      _data = obj["result"]["data"];
    });

    log("Data : ${_data}");

    var claimType = _data.map((result) => result["claimType"]).toList();
    var processingStatus = _data.map((result) => result["processingStatus"]).toList();
    var updatedAt = _data.map((result) => result["updatedAt"]).toList();

    for (var i = 0; i < _data.length; i++) {
      loadedItems.add(claimListItem(
        claimType: (claimType[i] == null) ? '' : claimType[i],
        processingStatus: (processingStatus[i] == null) ? '' : processingStatus[i],
        updatedAt: (updatedAt[i] == null) ? '' : updatedAt[i],
      ));
    }

    addClaimsItems(loadedItems);
  }

  Future<void> fetchClaims() async {
    bool initialRequest = false;

    state.isLoading = true;
    state.error = '';

    // num userId = await LocalStorage().getUserRegNo();
    num userId = 1;

    var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.claimListEndpoint);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "userId": userId,
    });

    http.post(url, headers: headers, body: body).then((response) {
      _processResponse(response);
    });
  }

  void addClaimsItems(List<claimListItem> items) {
    var sListModel = claimListModel.initial();

    sListModel.claim_data = items;
    sListModel.isLoading = state.isLoading;
    sListModel.error = state.error;

    state = sListModel;
  }
}

final claimListProvider =
    StateNotifierProvider<ClaimsListNotifier, claimListModel>((ref) {
  return ClaimsListNotifier();
});
