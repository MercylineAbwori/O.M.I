import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/core/services/models/policy_details_model.dart';

class PolicyDetailsListNotifier extends StateNotifier<policyDetailsModel> {
  PolicyDetailsListNotifier() : super(policyDetailsModel.initial());

  Future<void> _processResponse(http.Response response) async {
    print("***************************** Response Policy Details called");
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

    final List<policyDetailsItem> loadedItems = [];

    var obj = jsonDecode(response.body);

    var _data;

    obj.forEach((key, value) {
      _data = obj["result"]["data"];
    });

    log("Data : ${_data}");

    var createdAt = _data.map((result) => result["createdAt"]).toList();
    var dependants = _data.map((result) => result["dependants"]).toList();
    var id = _data.map((result) => result["id"]).toList();
    var paymentAmount = _data.map((result) => result["paymentAmount"]).toList();
    var paymentPeriod = _data.map((result) => result["paymentPeriod"]).toList();
    var policyNumber = _data.map((result) => result["policyNumber"]).toList();
    var sumInsured = _data.map((result) => result["sumInsured"]).toList();
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
      loadedItems.add(policyDetailsItem(
          createdAt: createdAt[i],
          dependants: dependants[i],
          id: id[i],
          paymentAmount: paymentAmount[i],
          paymentPeriod: paymentPeriod[i],
          policyNumber: policyNumber[i],
          sumInsured: sumInsured[i],
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

    addPolicyDetailsItems(loadedItems);
  }

  Future<void> fetchPolicyDetails() async {
    bool initialRequest = false;

    state.isLoading = true;
    state.error = '';

    // num userId = await LocalStorage().getUserRegNo();
    num userId = 1;

    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.policyDetailsEndpoint);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      // "userId": userId,
      "userId": userId
    });

    http.post(url, headers: headers, body: body).then((response) {
      _processResponse(response);
    });
  }

  void addPolicyDetailsItems(List<policyDetailsItem> items) {
    var sListModel = policyDetailsModel.initial();

    sListModel.policy_details_data = items;
    sListModel.isLoading = state.isLoading;
    sListModel.error = state.error;

    state = sListModel;
  }
}

final policyDetailsListProvider =
    StateNotifierProvider<PolicyDetailsListNotifier, policyDetailsModel>((ref) {
  return PolicyDetailsListNotifier();
});
