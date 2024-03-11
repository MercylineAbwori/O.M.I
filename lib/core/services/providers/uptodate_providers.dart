import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/core/services/models/uptodate_model.dart';

class UpToDateListNotifier extends StateNotifier<upToDateListModel> {
  UpToDateListNotifier() : super(upToDateListModel.initial());

  Future<void> _processResponse(http.Response response) async {
    print("***************************** Response UpToDate called");
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

    final List<upToDateListItem> loadedItems = [];

    var obj = jsonDecode(response.body);

    var _data;

    obj.forEach((key, value) {
      _data = obj["result"]["data"];
    });

    log("Data UpToDate : $_data");

    var claimApplicationActive =
        _data.map((result) => result["claimApplicationActive"]);
    var paymentAmount = _data.map((result) => result["paymentAmount"]);
    var qualifiesForCompensation =
        _data.map((result) => result["qualifiesForCompensation"]);
    var uptoDatePayment = _data.map((result) => result["uptoDatePayment"]);

    loadedItems.add(upToDateListItem(
        claimApplicationActive: claimApplicationActive,
        paymentAmount: paymentAmount,
        qualifiesForCompensation: qualifiesForCompensation,
        uptoDatePayment: uptoDatePayment));

    addUpToDateItems(loadedItems);
  }

  Future<void> fetchUpToDate() async {
    bool initialRequest = false;

    state.isLoading = true;
    state.error = '';

    // num userId = await LocalStorage().getUserRegNo();
    num userId = 1;
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.uptoDatePaymentEndpoint);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      // "userId": userId,
      "userId": userId,
    });

    http.post(url, headers: headers, body: body).then((response) {
      _processResponse(response);
    });
  }

  void addUpToDateItems(List<upToDateListItem> items) {
    var sListModel = upToDateListModel.initial();

    sListModel.uptodate_data = items;
    sListModel.isLoading = state.isLoading;
    sListModel.error = state.error;

    state = sListModel;
  }
}

final upToDateListProvider =
    StateNotifierProvider<UpToDateListNotifier, upToDateListModel>((ref) {
  return UpToDateListNotifier();
});
