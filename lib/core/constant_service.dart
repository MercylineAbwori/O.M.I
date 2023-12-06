import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/beneficiary_model.dart';
import 'package:one_million_app/core/model/calculator_model.dart';
import 'package:one_million_app/core/model/coverage_selection_model.dart';
import 'package:one_million_app/core/model/login_model.dart';
import 'package:one_million_app/core/model/notification_model.dart';
import 'package:one_million_app/core/model/regisration_otp_model.dart';
import 'package:one_million_app/core/model/registration_model.dart';
import 'package:one_million_app/core/model/registration_otp_verify.dart';

class ApiService {
  Future<List<UserRegistrationModal>?> addUsers(
      nameController,
      emailController,
      phoneNo,
      dateOfBirthController,
      dropdownValue,
      passwordConfirmController,
      passwordontroller) async {
    try {
    var url =
        Uri.parse(ApiConstants.baseUrl + ApiConstants.registrationEndpoint);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "msisdn": phoneNo,
      "name": nameController,
      "pin": passwordontroller,
      "confirmPin": passwordConfirmController,
      "email": emailController,
      "gender": dropdownValue,
      "dateOfBirth": dateOfBirthController
    });



    final response = await http.post(url, headers: headers, body: body);

    // print('Responce Status Code : ${response.statusCode}');
    // print('Responce Body : ${response.body}');

      

      // if (response.statusCode == 200) {
      // print("Response Body: ${response.body}");


      // } else {
      //   throw Exception('Unexpected error occured!');
      // }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }

  Future<List<UserRegistrationOTPModal>?> sendOTP() async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.sendOTPEndpoint);
      var response = await http.post(url);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => UserRegistrationOTPModal.fromJson(data))
            .toList();
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<UserRegistrationOTPVerifyModal>?> sendOTPVerify() async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.sendOTPVerify);
      var response = await http.post(url);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => UserRegistrationOTPVerifyModal.fromJson(data))
            .toList();
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<UserLoginModal>?> Login() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);
      var response = await http.post(url);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => UserLoginModal.fromJson(data))
            .toList();
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<CalculatorModal>?> calculatePremium() async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.calculatorEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => CalculatorModal.fromJson(data))
            .toList();
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<coverageSelectionModal>?> postCoverageSelection() async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.coverageSelectionEndpoint);
      var response = await http.post(url);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => coverageSelectionModal.fromJson(data))
            .toList();
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<NotificationModal>?> getNotification() async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.notificationEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => NotificationModal.fromJson(data))
            .toList();
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<BeneficiaryModal>?> addBeneficiary() async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.beneficiaryEndpoint);
      var response = await http.post(url);
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => BeneficiaryModal.fromJson(data))
            .toList();
      } else {
        throw Exception('Unexpected error occured!');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
