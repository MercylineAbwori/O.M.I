import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/common_ui.dart';
import 'package:one_million_app/components/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/components/sign_up/signup_screen.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/claim_list_model.dart';
import 'package:one_million_app/core/model/default_claim.dart';
import 'package:one_million_app/core/model/fetch_document.model.dart';
import 'package:one_million_app/core/model/login_model.dart';
import 'package:one_million_app/core/model/notification_model.dart';
import 'package:one_million_app/core/model/policy_details.dart';
import 'package:one_million_app/core/model/registration_model.dart';
import 'package:one_million_app/core/model/registration_otp_verify.dart';
import 'package:one_million_app/core/model/uptodate_payment_status.dart';
import 'package:one_million_app/shared/constants.dart';

class LoginPage extends StatefulWidget {
  final String promotionCode;

  const LoginPage({Key? key, required this.promotionCode}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinontroller = TextEditingController();

  String initialCountry = 'KE';

  FocusNode phoneNode = new FocusNode();
  FocusNode pinNode = new FocusNode();

  String? phoneNo;

  late String _statusMessage;
  num? _statusCode;

  //User Details
  late String _email;
  late String _msisdn;
  String? _name;

  late num _userId;

  late num _otp;

  late List<String> message = [];

  late List<dynamic> claimlistData = [];

  late String uptoDatePaymentData;

  late bool buttonStatus;

  late String profilePic;

  //Policy Details

  late String nextPayment;
  late num paymentAmount;
  late String paymentPeriod;
  late String policyNumber;
  late num sumInsured;

  bool isLoading = false;

  Future<List<UserLoginModal>?> PostLogin(
    phoneNo,
    pinontroller,
  ) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "msisdn": phoneNo,
        "pin": pinontroller,
      });

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Status Code : ${response.statusCode}');
      // print('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
        _userId = obj["result"]["data"]["UserDetails"]["userId"];
        _name = obj["result"]["data"]["UserDetails"]["name"];
        _email = obj["result"]["data"]["UserDetails"]["email"];
        _msisdn = obj["result"]["data"]["UserDetails"]["msisdn"];
      });

      log('THe responce : ${response.body}');

      if (response.statusCode == 5000) {
          await sendOTP(_msisdn);
          log('Login Sucesss the code is ${_statusCode}');
        
      } else {
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
      log(e.toString());
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
          log('failed the code is otp verify ${_statusCodeOTP}');
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
      log(e.toString());
    }
  }

  Future<List<ClaimListModal>?> listClaim(_userId) async {
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

      obj.forEach((key, value) {
        _statusCodeOTPVerify = obj["result"]["code"];
        claimlistData = obj["result"]["data"];
        // _claimlistData = obj["result"]["data"]["claimFormEntity"];
      });

      if (response.statusCode == 5000) {
        if (_statusCodeOTPVerify == 5000) {
          throw Exception('OTP verified successfully');
        } else {
          log('failed the code is list ${_statusCodeOTPVerify}');
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
      log(e.toString());
    }
  }

  Future<List<NotificationModal>?> getNotification(userId) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.notificationEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"userId": userId});

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Status Code : ${response.statusCode}');
      // print('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      var _statusCodeGetNotification;

      obj.forEach((key, value) {
        _statusCodeGetNotification = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];

        var objs = obj["result"]["data"];

        for (var item in objs) {
          message.add(item["message"]);
        }
      });

      if (response.statusCode == 5000) {
        if (_statusCodeGetNotification == 5000) {
          throw Exception('Notification message retrieved successfully');
        } else {
          log('failed the code is noti ${_statusCodeGetNotification}');
        }
      } else {
        throw Exception(
            'Unexpected NotifIcation success error occured! Status code ${response.statusCode}');
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
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.uptoDatePaymentEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        // "userId": userId,
        "userId": userId,
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeUpToDatePayment;

      obj.forEach((key, value) {
        _statusCodeUpToDatePayment = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
        uptoDatePaymentData = obj["result"]["data"];
      });

      if (response.statusCode == 5000) {
        if (_statusCodeUpToDatePayment == 5000) {
          throw Exception('UP TO DATE successfully');
        } else {
          log('failed the code is  up to date${_statusCodeUpToDatePayment}');
        }
      } else {
        throw Exception(
            'Unexpected UP TO DATE error occured! Status code ${response.statusCode}');
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
  Future<List<defaultPolicyPayModal>?> defaultClaim(
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
        buttonStatus = obj["result"]["data"];
      });

      if (response.statusCode == 5000) {
        if (_statusCodeDefaultClaim == 5000) {
          throw Exception('Promotion Code successfully');
        } else {
          log('failed the code is promo ${_statusCodeDefaultClaim}');
        }
      } else {
        throw Exception(
            'Unexpected Promotion Code error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }

  //policy Details Modal
  Future<List<PolicyDetailsModal>?> getPolicyDetails(userId) async {
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

      var _statusCodePolicyDetails;

      obj.forEach((key, value) {
        _statusCodePolicyDetails = obj["result"]["code"];
        nextPayment = obj["result"]["data"]["nextPayment"];
        paymentAmount = obj["result"]["data"]["paymentAmount"];
        paymentPeriod = obj["result"]["data"]["paymentPeriod"];
        policyNumber = obj["result"]["data"]["policyNumber"];
        sumInsured = obj["result"]["data"]["sumInsured"];
      });

      if (response.statusCode == 5000) {
        if (_statusCodePolicyDetails == 5000) {
          throw Exception('Policy Details Displayed successfully');
        } else {
          log('failed the code is policy details ${_statusCodePolicyDetails}');
        }
      } else {
        throw Exception(
            'Unexpected Policy Details Displayed  error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }

  //policy Details Modal
  Future<List<FetchFileModal>?> getProfile(userId) async {
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

      print('Profile Responce Body: ${response.body}');

      var obj = jsonDecode(response.body);

      var _statusCodeGetProfile;

      obj.forEach((key, value) {
        _statusCodeGetProfile = obj["result"]["code"];
        profilePic = obj["result"]["data"];
      });

      if (response.statusCode == 5000) {
        if (_statusCodeGetProfile == 5000) {
          throw Exception('Get Profile successfully');
        } else {
          log('failed the code is pROFILE ${_statusCodeGetProfile}');
        }
      } else {
        throw Exception(
            'Unexpected Get Profile error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              IntlPhoneField(
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                controller: phoneController,
                onSaved: (phone) {},
                focusNode: phoneNode,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                      color: phoneNode.hasFocus ? kPrimaryColor : Colors.grey),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(
                      Icons.phone,
                      color: kPrimaryColor,
                    ),
                  ),
                  border: myinputborder(),
                  enabledBorder: myinputborder(),
                  focusedBorder: myfocusborder(),
                ),
                initialCountryCode: 'KE',
                onChanged: (phone) {
                  phoneNo = phone.completeNumber;
                  print(phoneController);
                },
                validator: (value) {
                  //allow upper and lower case alphabets and space
                  return "Enter your phone number should not start with a 0";
                },
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                textInputAction: TextInputAction.done,
                obscureText: true,
                cursorColor: kPrimaryColor,
                keyboardType: TextInputType.number,
                controller: pinontroller,
                focusNode: pinNode,
                onSaved: (pin) {},
                decoration: InputDecoration(
                  labelText: "Pin",
                  labelStyle: TextStyle(
                      color: pinNode.hasFocus ? kPrimaryColor : Colors.grey),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                  ),
                  border: myinputborder(),
                  enabledBorder: myinputborder(),
                  focusedBorder: myfocusborder(),
                ),
                validator: RequiredValidator(
                  errorText: "Required *",
                ),
              ),
              const SizedBox(height: defaultPadding),
              Hero(
                tag: "login_btn",
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      fixedSize: const Size(200, 40)),
                  onPressed: () async {
                    await PostLogin(
                      phoneNo,
                      pinontroller.text,
                    );

                    await getNotification(
                      _userId,
                    );

                    await uptodatePayment(
                      _userId,
                    );
                    await defaultClaim(_userId, widget.promotionCode);

                    await getPolicyDetails(
                      _userId,
                    );

                    await listClaim(
                      _userId,
                    );

                    (_statusCode == 5000)
                        // ignore: use_build_context_synchronously
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CommonUIPage(
                                    userId: _userId,
                                    name: _name!,
                                    msisdn: _msisdn,
                                    email: _email,
                                    message: message,
                                    uptoDatePaymentData: uptoDatePaymentData,
                                    promotionCode: widget.promotionCode,
                                    buttonClaimStatus: buttonStatus,
                                    nextPayment: nextPayment,
                                    paymentAmount: paymentAmount,
                                    paymentPeriod: paymentPeriod,
                                    policyNumber: policyNumber,
                                    sumInsured: sumInsured,
                                    tableData: [],
                                    rowsBenefits: [],
                                    rowsSumIsured: [],
                                    claimListData: claimlistData,
                                    profilePic: '');
                                // profilePic: profilePic);
                              },
                            ),
                          )
                        // ignore: use_build_context_synchronously
                        : Navigator.pop(context);
                    setState(
                      () {},
                    );

                    Future.delayed(const Duration(seconds: 3), (){ 
                        setState(() { 
                          isLoading = false; 
                        }); 
                      } 
                    ); 

                    final snackBar = SnackBar(
                      content: Text(_statusMessage),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: isLoading? const Row( 
                    mainAxisAlignment: MainAxisAlignment.center, 
                        
                    // ignore: prefer_const_literals_to_create_immutables 
                    children: [ 
                    Text('Loading...', style: TextStyle(fontSize: 20),), 
                    SizedBox(width: 10,), 
                      CircularProgressIndicator(color: Colors.white,), 
                    ], 
                  ) : 
                  Text(
                        "Log in".toUpperCase(),
                  ),
                  
                  
                ),
              ),
              const SizedBox(height: defaultPadding),
              AlreadyHaveAnAccountCheck(
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SignUpScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 0),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ));
  }

  OutlineInputBorder myfocusborder() {
    return const OutlineInputBorder(
        borderSide: BorderSide(color: kPrimaryColor, width: 0),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ));
  }
}
