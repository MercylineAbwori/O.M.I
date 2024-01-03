import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/beneficiary_model.dart';
import 'package:one_million_app/core/model/calculator_model.dart';
import 'package:one_million_app/core/model/claim_list_model.dart';
import 'package:one_million_app/core/model/coverage_selection_model.dart';
import 'package:one_million_app/core/model/login_model.dart';
import 'package:one_million_app/core/model/mpesa_model.dart';
import 'package:one_million_app/core/model/notification_markall_model.dart';
import 'package:one_million_app/core/model/notification_markasread_model.dart';
import 'package:one_million_app/core/model/notification_model.dart';
import 'package:one_million_app/core/model/promocode_pass_model.dart';
import 'package:one_million_app/core/model/regisration_otp_model.dart';
import 'package:one_million_app/core/model/registration_model.dart';
import 'package:one_million_app/core/model/registration_otp_verify.dart';
import 'package:one_million_app/core/model/uptodate_payment_status.dart';

class ApiService {
  late String _statusMessage;
  num? _statusCode;

  //User Details

  late num _userId;

  late num _pin;

  late num _otp;

  late String _msisdn;

//OTP
  Future<List<UserRegistrationModal>?> sendOTP(_msisdn) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.sendOTPEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "msisdn": _msisdn,
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
        _otp = obj["result"]["data"]["otpId"];
      });

      if (response.statusCode == 5000) {
        await sendOTPVerify(_userId, _otp);
      } else {
        throw Exception(
            'Unexpected OTP error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  Future<List<UserRegistrationOTPVerifyModal>?> sendOTPVerify(
      _userId, _otp) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.sendOTPVerify);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": _userId,
        "otp": _otp,
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeOTP;

      obj.forEach((key, value) {
        _statusCodeOTP = obj["result"]["code"];
      });

      if (response.statusCode == 5000) {
        if (_statusCodeOTP == 5000) {
          throw Exception('OTP verified successfully');
        } else {
          // log('failed the code is otp verify ${_statusCodeOTP}');
        }
      } else {
        throw Exception(
            'Unexpected verify OTP error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }


// //POST SELECTION
//   Future<List<coverageSelectionModal>?> postCoverageSelection(
//     userId,
//     sumInsured,
//     paymentPeriod,
//     paymentAmount,
//   ) async {
//     try {
//       var url = Uri.parse(
//           ApiConstants.baseUrl + ApiConstants.coverageSelectionEndpoint);
//       final headers = {'Content-Type': 'application/json'};
//       final body = jsonEncode({
//         "userId": userId,
//         "sumInsured": sumInsured,
//         "paymentPeriod": paymentPeriod,
//         "paymentAmount": paymentAmount,
//       });

//       final response = await http.post(url, headers: headers, body: body);

//       // print('Responce Status Code : ${response.statusCode}');
//       // print('Responce Body : ${response.body}');

//       var obj = jsonDecode(response.body);

//       var _statusCodeSubscription;

//       obj.forEach((key, value) {
//         _statusCodeSubscription = obj["result"]["code"];
//         _statusMessage = obj["statusMessage"];
//       });

//       if (response.statusCode == 5000) {
//         if (_statusCodeSubscription == 5000) {
//           throw Exception('Subscribed successfully');
//         } else {
//           // log('failed the code is ${_statusCodeSubscription}');
//         }
//       } else {
//         throw Exception(
//             'Unexpected Subscribed error occured! Status code ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Error: $e");
//       if (e is http.ClientException) {
//         print("Response Body: ${e.message}");
//       }
//       // log(e.toString());
//     }
//   }

// //MPESA Payment
//   Future<List<MpesaPaymentModal>?> mpesaPayment(
//     userId,
//     amount,
//     phoneNumber,
//   ) async {
//     try {
//       var url =
//           Uri.parse(ApiConstants.baseUrl + ApiConstants.mpesaPaymentEndpoint);
//       final headers = {'Content-Type': 'application/json'};
//       final body = jsonEncode(
//           {"amount": amount, "userId": userId, "phoneNumber": phoneNumber});

//       final response = await http.post(url, headers: headers, body: body);

//       var obj = jsonDecode(response.body);

//       var _statusCodeMpesaPayment;

//       obj.forEach((key, value) {
//         _statusCodeMpesaPayment = obj["result"]["code"];
//         _statusMessage = obj["statusMessage"];
//       });

//       if (response.statusCode == 5000) {
//         if (_statusCodeMpesaPayment == 5000) {
//           throw Exception('Beneficiary added successfully');
//         } else {
//           // log('failed the code is ${_statusCodeMpesaPayment}');
//         }
//       } else {
//         throw Exception(
//             'Unexpected Beneficiary added error occured! Status code ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Error: $e");
//       if (e is http.ClientException) {
//         print("Response Body: ${e.message}");
//       }
//       // log(e.toString());
//     }
//   }

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

      var _statusCodeUpToDatePayment;

      obj.forEach((key, value) {
        _statusCodeUpToDatePayment = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
      });

      if (response.statusCode == 5000) {
        if (_statusCodeUpToDatePayment == 5000) {
          throw Exception('UptoDataAdded added successfully');
        } else {
          // log('failed the code is ${_statusCodeUpToDatePayment}');
        }
      } else {
        throw Exception(
            'Unexpected UptoDataAdded error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //default Claim
  Future<List<UptodatePaymentStatusModal>?> defaultClaim(
      userId, promotionCode) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.defaultPolicyPayEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body =
          jsonEncode({"userId": userId, "promotionCode": promotionCode});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeDefaultClaim;

      obj.forEach((key, value) {
        _statusCodeDefaultClaim = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
      });

      if (response.statusCode == 5000) {
        if (_statusCodeDefaultClaim == 5000) {
          throw Exception('Default Claim IS  successfully');
        } else {
          // log('failed the code is ${_statusCodeDefaultClaim}');
        }
      } else {
        throw Exception(
            'Unexpected Default Claim error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //claim default Claim
  Future<List<UptodatePaymentStatusModal>?> claimDefault(
      userId, promotionCode) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.claimDefaultEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body =
          jsonEncode({"userId": userId, "promotionCode": promotionCode});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeDefaultClaim;

      obj.forEach((key, value) {
        _statusCodeDefaultClaim = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
      });

      if (response.statusCode == 5000) {
        if (_statusCodeDefaultClaim == 5000) {
          throw Exception('Default Claim IS  successfully');
        } else {
          // log('failed the code is ${_statusCodeDefaultClaim}');
        }
      } else {
        throw Exception(
            'Unexpected Default Claim error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //mark as read
  Future<List<markAsReadModal>?> sendMarkAsRead(userId, notificationId) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.notificationMarkAsReadEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body =
          jsonEncode({"userId": userId, "notificationId": notificationId});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeDefaultClaim;

      obj.forEach((key, value) {
        _statusCodeDefaultClaim = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
      });

      if (_statusCodeDefaultClaim == 5000) {
        throw Exception('marked successfully IS  successfully');
      } else {
        throw Exception(
            'Unexpected marked error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //markAll
  Future<List<markAllModal>?> sendMarkAsAll(userId) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.notificationMarkAllEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"userId": userId});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeDefaultClaim;

      obj.forEach((key, value) {
        _statusCodeDefaultClaim = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
      });

      if (_statusCodeDefaultClaim == 5000) {
        throw Exception('marked all IS  successfully');
      } else {
        throw Exception(
            'Unexpected marked all error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //notification total
  Future<List<markAllModal>?> notificationTotal(userId) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.notificationCountEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"userId": userId});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeDefaultClaim;

      obj.forEach((key, value) {
        _statusCodeDefaultClaim = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
      });

      if (_statusCodeDefaultClaim == 5000) {
        throw Exception('notification count  successfully');
      } else {
        throw Exception(
            'Unexpected notification count error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //generate promocode
  Future<List<markAllModal>?> generatePromo(userId) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.generatePromoEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"userId": userId});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeDefaultClaim;

      obj.forEach((key, value) {
        _statusCodeDefaultClaim = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
      });

      if (_statusCodeDefaultClaim == 5000) {
        throw Exception('notification count  successfully');
      } else {
        throw Exception(
            'Unexpected notification count error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
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
