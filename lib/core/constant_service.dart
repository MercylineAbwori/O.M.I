import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:one_million_app/core/model/upload_document_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/core/model/login_model.dart';
import 'package:one_million_app/core/model/mpesa_model.dart';
import 'package:one_million_app/core/model/notification_markall_model.dart';
import 'package:one_million_app/core/model/notification_markasread_model.dart';
import 'package:one_million_app/core/model/promocode_pass_model.dart';
import 'package:one_million_app/core/model/registration_model.dart';
import 'package:one_million_app/core/model/registration_otp_verify.dart';
import 'package:one_million_app/core/model/uptodate_payment_status.dart';

class ApiService {
  Future<List<UserLoginModal>?> postLogin(
    phoneNo,
    pin,
  ) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "msisdn": phoneNo,
        "pin": int.parse(pin),
      });

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Status Code : ${response.statusCode}');
      print('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      var _userId;
      var _statusMessage;
      var _statusCode;

      //User Details
      var _email;
      var _msisdn;
      var _name;

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
        _userId = obj["result"]["data"]["UserDetails"]["userId"];
        _name = obj["result"]["data"]["UserDetails"]["name"];
        _email = obj["result"]["data"]["UserDetails"]["email"];
        _msisdn = obj["result"]["data"]["UserDetails"]["msisdn"];
      });

      if (_statusCode == 5000) {
        await LocalStorage().storeLoginCode(_statusCode);

        //Store the data
        await LocalStorage().storeUserName(_name);
        await LocalStorage().storeEmail(_email);
        await LocalStorage().storeUserRegNo(_userId);
        await LocalStorage().storePhoneNo(_msisdn);
        await sendOTP(_msisdn);
        log('Login Sucesss the code is ${_statusCode}');

        // Show a simple toast message
        Fluttertoast.showToast(
          msg: _statusMessage!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Show a simple toast message
        Fluttertoast.showToast(
          msg: 'Wrong phone number or pin',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        throw Exception(
            'Unexpected Login error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }

  //OTP
  Future<List<UserRegistrationModal>?> sendOTP(_msisdn) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.sendOTPEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "msisdn": _msisdn,
      });

      final response = await http.post(url, headers: headers, body: body);

      log('THe responce : ${response.body}');

      var obj = jsonDecode(response.body);

      var _statusMessage;
      var _statusCode;
      var _otp;

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
        _otp = obj["result"]["data"]["otp"];
      });

      if (_statusCode == 5000) {
        // log("Body : ${obj}");
        await LocalStorage().storeOTP(_statusCode);

        await showNotification(_otp);
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

  showNotification(otp) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // const IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    // );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high channel',
      'Very important notification!!',
      description: 'the first notification',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      'OMI Insurence OTP',
      'This Is the OTP $otp',
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description),
      ),
    );
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

      var _statusCodeVerifyOTP;
      var _statusMessage;

      obj.forEach((key, value) {
        _statusCodeVerifyOTP = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
      });

      // Show a simple toast message
      Fluttertoast.showToast(
        msg: _statusMessage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      if (_statusCodeVerifyOTP == 5000) {
        await LocalStorage().storeVerifyCode(_statusCodeVerifyOTP);
        throw Exception('OTP verified successfully');
      } else {
        // Show a simple toast message
        Fluttertoast.showToast(
          msg: 'Error has occured, please check your OTP number',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
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

  Future<List<UserRegistrationModal>?> addUsers(
      name, email, phoneNo, dateOfBirth, dropdownValue, pinConfirm, pin) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.registrationEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "msisdn": phoneNo,
        "name": name,
        "pin": pin,
        "confirmPin": pinConfirm,
        "email": email,
        "gender": dropdownValue,
        "dateOfBirth": dateOfBirth
      });

      final response = await http.post(url, headers: headers, body: body);

      log('Sign Up banger: ${response.body}');
      var obj = jsonDecode(response.body);

      var mswes;
      var _statusCode = obj["result"]["code"];
      var _statusMessage = obj["result"]["message"];
      var _userId = obj["result"]["data"]["userId"];
      var _msisdn = obj["result"]["data"]["msisdn"];

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
        _userId = obj["result"]["data"]["userId"];
        _msisdn = obj["result"]["data"]["msisdn"];
      });

      log('msfyeuef : $_msisdn');

      if (_statusCode == 5000) {
        await sendOTP((_msisdn).toString());
        await LocalStorage().storeRegistrationCode(_statusCode);
        // Show a simple toast message
        Fluttertoast.showToast(
          msg: _statusMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Show a simple toast message
        Fluttertoast.showToast(
          msg: _statusMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        throw Exception(
            'Unexpected signup error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //promoCode to pass
  Future<List<promoCodePassModal>?> sendPromoCode(userId, promoCodeCode) async {
    try {
      var url = Uri.parse(ApiConstantsPromoCode.baseUrl +
          ApiConstantsPromoCode.promocodeEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body =
          jsonEncode({"userId": userId, "promotionCode": promoCodeCode});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodePromoCode;
      var _statusMessagePromoCode;

      obj.forEach((key, value) {
        _statusCodePromoCode = obj["result"]["code"];
        _statusMessagePromoCode = obj["result"]["message"];
      });

      if (_statusCodePromoCode == 5000) {
        await LocalStorage().storePromoStatusCode(_statusCodePromoCode);
        throw Exception('Promocode passed successfully');
      } else {
        throw Exception(
            'Unexpected Promocode passed error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //RESET PASSWORD
  Future<List<UserLoginModal>?> PostResetPassword(
    _msisdn,
    _pin,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.resetPasswordEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "msisdn": _msisdn,
        "pin": _pin,
      });

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Status Code : ${response.statusCode}');
      log('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      var _statusCode;
      var _statusMessage;

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
      });

      if (response.statusCode == 5000) {
        await LocalStorage().storeResetCode(_statusCode);
      } else {
        throw Exception(
            'Unexpected Reset Password error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  Future listClaim(_userId) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.claimListEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": _userId,
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeOTPVerify;
      var _claimlistData;

      obj.forEach((key, value) {
        _statusCodeOTPVerify = obj["result"]["code"];
        _claimlistData = obj["result"]["data"];
        // _claimlistData = obj["result"]["data"]["claimFormEntity"];
      });

      if (_statusCodeOTPVerify == 5000) {
        log("Claim List : $_claimlistData");
        throw Exception('LIst retrived successfully');
      } else {
        throw Exception(
            'Unexpected LIst retrived error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  Future getNotification(userId) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.notificationEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"userId": userId});

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Status Code : ${response.statusCode}');
      // // log('Responce Body  : ${response.body}');

      var obj = jsonDecode(response.body);

      var _statusCodeGetNotification;
      var _statusMessage;

      var message = [];
      var title = [];
      var readStatus = [];
      var notificationIdList = [];

      obj.forEach((key, value) {
        _statusCodeGetNotification = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];

        var objs = obj["result"]["data"];

        for (var item in objs) {
          message.add(item["message"]);
          title.add(item["type"]);
          readStatus.add(item["readStatus"]);
          notificationIdList.add(item["id"]);
        }
      });

      // String? _firstMessage;
      // String? _firstTitle;

      // setState(() {
      // _firstTitle = title[0];
      // _firstMessage = message[0];
      // });

      if (_statusCodeGetNotification == 5000) {
        showNotificationRecentActivities(title[0], message[0]);
        log("Notifications List : $obj");
        throw Exception('Notification message retrieved successfully');
      } else {
        throw Exception(
            'Unexpected NotifIcation success error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  showNotificationRecentActivities(firstTitle, firstMessage) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // const IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    // );
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high channel',
      'Very important notification!!',
      description: 'the first notification',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin.show(
      1,
      firstTitle,
      firstMessage,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description),
      ),
    );
  }

  Future getNotificationCount(userId) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.notificationCountEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"userId": userId});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeGetNotification;
      var _statusMessage;
      var counted;

      obj.forEach((key, value) {
        _statusCodeGetNotification = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
        counted = obj["result"]["data"];
      });
      // num? count;
      // setState(() {
      //   count = counted;
      // });

      if (_statusCodeGetNotification == 5000) {
        log('Responce Notification Counts : ${obj}');
        throw Exception('Notification message retrieved successfully');
      } else {
        throw Exception(
            'Unexpected NotifIcation success error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Notification Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //default Claim
  Future defaultClaim(userId, promotionCode) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.defaultPolicyPayEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body =
          jsonEncode({"userId": userId, "promotionCode": promotionCode});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeDefaultClaim;
      var _statusMessage;
      var buttonStatus;

      obj.forEach((key, value) {
        _statusCodeDefaultClaim = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];

        buttonStatus = obj["result"]["data"];
      });

      if (_statusCodeDefaultClaim == 5000) {
        throw Exception('Promotion Code successfully');
      } else {
        throw Exception(
            'Unexpected Promotion Code error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //policy Details Modal
  Future getPolicyDetails(userId) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.policyDetailsEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        // "userId": userId,
        "userId": userId
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      //Policy Details
      late String nextPayment = '';
      late String paymentPeriod;
      late String policyNumber;
      late num paymentAmount;
      late num sumInsured;

      late num statusCodePolicyDetails;

      obj.forEach((key, value) {
        statusCodePolicyDetails = obj["result"]["code"];
        paymentAmount = obj["result"]["data"]["paymentAmount"];
        paymentPeriod = obj["result"]["data"]["paymentPeriod"];
        policyNumber = obj["result"]["data"]["policyNumber"];
        sumInsured = obj["result"]["data"]["sumInsured"];
      });

      if (statusCodePolicyDetails == 5000) {
        log("Policy Details : $obj");
        throw Exception('Policy Details Displayed successfully');
      } else {
        throw Exception(
            'Unexpected Policy Details Displayed  error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //policy Details Modal
  Future getProfile(userId) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.fetchProfileEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        // "userId": userId,
        "userId": userId,
        "documentName": "profile"
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeGetProfile;
      var _profilePic;

      obj.forEach((key, value) {
        _statusCodeGetProfile = obj["result"]["code"];
        _profilePic = obj["result"]["data"]["url"];
      });

      // setState(() {
      //   profilePic = _profilePic;
      // });

      // log('pic : $profilePic');

      if (_statusCodeGetProfile == 5000) {
        await LocalStorage().storeProfilePicture(_profilePic);

        throw Exception('Get Profile successfully');
      } else {
        throw Exception(
            'Unexpected Get Profile error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //Up to date payment status Payment
  Future uptodatePayment(
    userId,
  ) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.uptoDatePaymentEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        // "userId": userId,
        "userId": userId,
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      print('Uptodate Responce Body: ${response.body}');

      var _statusCodeUpToDatePayment;
      var _uptoDatePayment;
      var _claimApplicationActive;
      var _paymentAmount;
      var _qualifiesForCompensation;

      obj.forEach((key, value) {
        _statusCodeUpToDatePayment = obj["result"]["code"];

        // var uptodatedPaymentData = obj["result"];
        // // log('Up to date data : $uptodatedPaymentData');
        _uptoDatePayment = obj["result"]["data"]["uptoDatePayment"];
        _claimApplicationActive =
            obj["result"]["data"]["claimApplicationActive"];
        _paymentAmount = obj["result"]["data"]["paymentAmount"];
        _qualifiesForCompensation =
            obj["result"]["data"]["qualifiesForCompensation"];
      });

      // String? claimApplicationActive;
      // num? paymentAmountUptoDate;
      // String? qualifiesForCompensation;
      // String? uptoDatePayment;

      // setState(() {
      //   uptoDatePayment = _uptoDatePayment;
      //   claimApplicationActive = _claimApplicationActive;
      //   paymentAmountUptoDate = _paymentAmount;
      //   qualifiesForCompensation = _qualifiesForCompensation;
      // });

      log('Upt to date Payment: ${_uptoDatePayment}');
      log('Claim Application Active: ${_claimApplicationActive}');
      log('Payment Amount: ${_paymentAmount}');
      log('Qualifies For Compentsation: ${_qualifiesForCompensation}');

      if (_statusCodeUpToDatePayment == 5000) {
        log("UptoDate Data : $obj");
        throw Exception('UP TO DATE successfully');
      } else {
        throw Exception(
            'Unexpected UP TO DATE error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  //MPESA Payment
  Future<List<MpesaPaymentModal>?> mpesaPayment(
    amount,
    userId,
    phoneNo,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.mpesaPaymentEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "amount": (amount).toString(),
        "userId": userId,
        "phoneNumber": phoneNo
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      log('Make Payment Data: ${response.body}');

      var _statusCodeMpesaPayment;
      var _statusMessage;

      obj.forEach((key, value) {
        _statusCodeMpesaPayment = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
      });

      if (_statusCodeMpesaPayment == 5000) {
        await LocalStorage().storeMakePaymentsCode(_statusCodeMpesaPayment);
        throw Exception('Coverage Payment successful');
      } else {
        throw Exception(
            'Unexpected Coverage Payment error occured! Status code ${response.statusCode}');
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
      var _statusMessage;

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
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.notificationMarkAsReadEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body =
          jsonEncode({"userId": userId, "notificationId": notificationId});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeDefaultClaim;
      var _statusMessage;

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
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.notificationMarkAllEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"userId": userId});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeDefaultClaim;
      var _statusMessage;

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
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.notificationCountEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"userId": userId});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeDefaultClaim;
      var _statusMessage;

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
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.generatePromoEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"userId": userId});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeDefaultClaim;
      var _statusMessage;

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


  Future<List<UploadFileModal>?> pickerFiles(userId, documentName, file) async {
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              ApiConstants.baseUrl + ApiConstants.uploadDocumentEndpoint));

      // open a bytestream
      var stream = http.ByteStream(DelegatingStream.typed(file.openRead()));
      // get file length
      var length = await file.length();

      // multipart that takes file
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: basename(file.path));

      request.fields.addAll(
          {"userId": json.encode(userId), "documentName": documentName});
      // request.fields["documentName"] = documentName;
      // request.fields["userId"] = userId.toString();

      // add file to multipart
      request.files.add(multipartFile);

      var response = await request.send();
      var responced = await http.Response.fromStream(response);

      final responseData = json.decode(responced.body);

      print('rESPONCE bODY : $responseData');

      // log('The Request Payload : ${request.files}');
    } on PlatformException catch (e) {
      // log('Unsupported operation' + e.toString());
    } catch (e) {
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
