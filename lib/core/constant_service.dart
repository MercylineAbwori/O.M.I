import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/beneficiary_model.dart';
import 'package:one_million_app/core/model/calculator_model.dart';
import 'package:one_million_app/core/model/coverage_selection_model.dart';
import 'package:one_million_app/core/model/login_model.dart';
import 'package:one_million_app/core/model/mpesa_model.dart';
import 'package:one_million_app/core/model/notification_model.dart';
import 'package:one_million_app/core/model/regisration_otp_model.dart';
import 'package:one_million_app/core/model/registration_model.dart';
import 'package:one_million_app/core/model/registration_otp_verify.dart';
import 'package:one_million_app/core/model/uptodate_payment_status.dart';

class ApiService {

  late String _statusMessage;
  num? _statusCode;

  
  

  Future<List<coverageSelectionModal>?> postCoverageSelection(
    userId,
    sumInsured,
    paymentPeriod,
    paymentAmount,
  ) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.coverageSelectionEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": userId,
        "sumInsured": sumInsured,
        "paymentPeriod": paymentPeriod,
        "paymentAmount": paymentAmount,
      });

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Status Code : ${response.statusCode}');
      // print('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      obj.forEach((key, value) {
        _statusCode = obj["statusCode"];
        _statusMessage = obj["statusMessage"];
      });

      if (response.statusCode == 200) {
        print("Subscribed successfully");
      } else {
        throw Exception('Unexpected Login error occured!');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }














//MPESA Payment
  Future<List<MpesaPaymentModal>?> mpesaPayment(
    userId,
    amount,
    phoneNumber,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.mpesaPaymentEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "amount": amount,
        "userId": userId,
        "phoneNumber": phoneNumber
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);
        
        obj.forEach((key, value){
          _statusCode = obj["statusCode"];
          _statusMessage = obj["statusMessage"];
        });

      if (response.statusCode == 200) {
          throw Exception('Beneficiary added successfully');
          
      } else {
        throw Exception('Unexpected error occured!');
      }

    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }

  //Up to date payment status Payment
  Future<List<UptodatePaymentStatusModal>?> uptodatePayment(
    userId,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.mpesaPaymentEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": userId,
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);
        
        obj.forEach((key, value){
          _statusCode = obj["statusCode"];
          _statusMessage = obj["statusMessage"];
        });

      if (response.statusCode == 200) {
          throw Exception('Beneficiary added successfully');
          
      } else {
        throw Exception('Unexpected error occured!');
      }

    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }

  //default Claim
  Future<List<UptodatePaymentStatusModal>?> defaultClaim(
    userId,
    promotionCode
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.defaultPolicyPayEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": userId,
        "promotionCode": promotionCode
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);
        
        obj.forEach((key, value){
          _statusCode = obj["statusCode"];
          _statusMessage = obj["statusMessage"];
        });

      if (response.statusCode == 200) {
          throw Exception('Promotion Code successfully');
          
      } else {
        throw Exception('Unexpected error occured!');
      }

    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }

  //claim default Claim
  Future<List<UptodatePaymentStatusModal>?> claimDefault(
    userId,
    promotionCode
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.claimDefaultEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": userId,
        "promotionCode": promotionCode
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);
        
        obj.forEach((key, value){
          _statusCode = obj["statusCode"];
          _statusMessage = obj["statusMessage"];
        });

      if (response.statusCode == 200) {
          throw Exception('Promotion Code successfully');
          
      } else {
        throw Exception('Unexpected error occured!');
      }

    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }
  ///Share app with promocode
  Future<void> shareApp() async {
    // Set the app link and the message to be shared
    final String appLink =
        'https://21zerixpm.medium.com/setup-before-deploy-your-flutter-app-to-the-google-play-store-474eae452910';
    final String message = 'Check out my new app: $appLink';

    // Share the app link and message using the share dialog
    await FlutterShare.share(
        title: 'Share App', text: message, linkUrl: appLink);
  }


}
