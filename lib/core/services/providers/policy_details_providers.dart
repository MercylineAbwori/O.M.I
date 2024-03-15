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
    var _code;

    obj.forEach((key, value) {
      _data = obj["result"]["data"];
      _code = obj["result"]["code"];
    });

    log("Data : ${_data}");

    await LocalStorage().storePolicyDetailsCode(_code);

    var createdAt = _data["createdAt"];
    var dependants = _data["dependants"];
    var id = _data["id"];
    var paymentAmount = _data["paymentAmount"];
    var paymentPeriod = _data["paymentPeriod"];
    var policyNumber = _data["policyNumber"];
    var sumInsured = _data["sumInsured"];
    var updatedAt = _data["updatedAt"];

    // userDetails:

    var userDetailscreatedAt = _data["userDetails"]["createdAt"];
    var userDetailsemail = _data["userDetails"]["email"];
    var userDetailsgender = _data["userDetails"]["gender"];
    var userDetailsmsisdn = _data["userDetails"]["msisdn"];
    var userDetailsname = _data["userDetails"]["name"];
    var userDetailspin = _data["userDetails"]["pin"];
    var userDetailsupdatedAt = _data["userDetails"]["updatedAt"];
    var userDetailsuserId = _data["userDetails"]["userId"];

    loadedItems.add(policyDetailsItem(
        createdAt: createdAt,
        dependants: dependants,
        id: id,
        paymentAmount: paymentAmount,
        paymentPeriod: paymentPeriod,
        policyNumber: policyNumber,
        sumInsured: sumInsured,
        updatedAt: updatedAt,

        //userDetails:

        userDetailscreatedAt: userDetailscreatedAt,
        userDetailsemail: userDetailsemail,
        userDetailsgender: userDetailsgender,
        userDetailsmsisdn: userDetailsmsisdn,
        userDetailsname: userDetailsname,
        userDetailspin: userDetailspin,
        userDetailsupdatedAt: userDetailsupdatedAt,
        userDetailsuserId: userDetailsuserId));

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
