import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      phoneController,
      dateOfBirthController,
      dropdownValue,
      passwordConfirmController,
      passwordontroller) async {
    // try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.registrationEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        // "msisdn": phoneController,
        // "name": nameController,
        // "pin": passwordontroller,
        // "confirmPin": passwordConfirmController,
        // "email": emailController,
        // "gender": dropdownValue,
        // "dateOfBirth": dateOfBirthController
        "msisdn": "+254717295570",
        "name": "Lexi Wewa",
        "pin": "1234",
        "confirmPin": "1234",
        "email": "jimmywewa@gmail.com",
        "gender": "female",
        // "dateOfBirth": "1996-11-16 18:54:27"
      });
       
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print("Request URL: $url");
        print("Request Headers: $headers");
        print("Request Body: $body");
      } else {
        throw Exception('Unexpected error occured!');
      }
    // } catch (e) {
    //   log(e.toString());
    // }
  }

  Future<List<UserRegistrationOTPModal>?> sendOTP() async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.registrationEndpointOTP);
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
          ApiConstants.baseUrl + ApiConstants.registrationEndpointOTPVerify);
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
