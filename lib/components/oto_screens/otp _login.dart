import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one_million_app/common_ui.dart';
import 'package:one_million_app/components/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/core/constant_service.dart';
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
import 'package:http/http.dart' as http;

class OtpLoginPage extends StatefulWidget {
  final num userId;
  final String name;
  final String email;
  final List<String> message;
  final String promotionCode;

  final String phoneNo;
  final String pin;
  final String otp;

  const OtpLoginPage(
      {super.key,
      required this.userId,
      required this.name,
      required this.email,
      required this.message,
      required this.promotionCode,
      required this.phoneNo,
      required this.pin,
      required this.otp});

  @override
  State<OtpLoginPage> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String _statusMessage;
  num? statusVerifyOTPCode;

  //User Details
  late String _email;
  late String _msisdn;
  String? _name;

  late List<String> message = [];
  late List<String> title = [];
  late List<String> readStatus = [];
  late List<num> notificationIdList = [];

  late List<dynamic> claimlistData = [];

  late bool buttonStatus;

  late String profilePic;

  //OTP
  TextEditingController valueOneController = TextEditingController();
  TextEditingController valueTwoController = TextEditingController();
  TextEditingController valueThreeController = TextEditingController();
  TextEditingController valueFourController = TextEditingController();
  TextEditingController valueFiveController = TextEditingController();
  TextEditingController valueSixController = TextEditingController();

  TextEditingController otpController = TextEditingController();

  String? _otpErrorText;

  late String _statusMessageother = '';
  num? _statusCodeother;
  late String otp;

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

      log('Another banger: ${response.body}');

      obj.forEach((key, value) {
        _statusCodeother = obj["result"]["code"];
        _statusMessageother = obj["result"]["message"];
        otp = obj["result"]["data"]["otp"];
      });

      if (_statusCodeother == 5000) {
        // log("Body : ${obj}");
        // log("OTP: ${_otp}");
        // await sendOTPVerify(_userId, _otp);
        _isButtonDisabled = false;
        _buttonText = 'Sign Up';
      } else {
        _isButtonDisabled = false;
        _buttonText = 'Sign Up';
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

      var _statusCodeVerifyOTP;

      obj.forEach((key, value) {
        _statusCodeVerifyOTP = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
      });

      setState(() {
        statusVerifyOTPCode = _statusCodeVerifyOTP;
      });

      // final snackBar = SnackBar(
      //   content: Text(_statusMessage),
      //   action: SnackBarAction(
      //     label: 'Undo',
      //     onPressed: () {
      //       // Some code to undo the change.
      //     },
      //   ),
      // );

      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

      if (statusVerifyOTPCode == 5000) {
        throw Exception('OTP verified successfully');
      } else {
        // final snackBar = SnackBar(
        //   content: Text('Ann Error has occured, please check your OTP number'),
        //   action: SnackBarAction(
        //     label: 'Undo',
        //     onPressed: () {
        //       // Some code to undo the change.
        //     },
        //   ),
        // );

        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

      if (_statusCodeOTPVerify == 5000) {
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

  Future<List<NotificationModal>?> getNotification(userId) async {
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

      if (_statusCodeGetNotification == 5000) {
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

  num? count;
  Future<List<NotificationModal>?> getNotificationCount(userId) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.notificationCountEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({"userId": userId});

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Status Code : ${response.statusCode}');

      var obj = jsonDecode(response.body);

      var _statusCodeGetNotification;
      var counted;

      obj.forEach((key, value) {
        _statusCodeGetNotification = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
        counted = obj["result"]["data"];
      });

      setState(() {
        count = counted;
      });

      if (_statusCodeGetNotification == 5000) {
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

  //Policy Details
  late String nextPayment = '';
  late String paymentPeriod;
  late String policyNumber;
  late num paymentAmount;
  late num sumInsured;

  late num statusCodePolicyDetails;

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

      log('Policy Details: ${response.body}');

      obj.forEach((key, value) {
        statusCodePolicyDetails = obj["result"]["code"];
        paymentAmount = obj["result"]["data"]["paymentAmount"];
        paymentPeriod = obj["result"]["data"]["paymentPeriod"];
        policyNumber = obj["result"]["data"]["policyNumber"];
        sumInsured = obj["result"]["data"]["sumInsured"];
      });

      if (statusCodePolicyDetails == 5000) {
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

      var obj = jsonDecode(response.body);

      var _statusCodeGetProfile;
      var _profilePic;

      obj.forEach((key, value) {
        _statusCodeGetProfile = obj["result"]["code"];
        _profilePic = obj["result"]["data"]["url"];
      });

      setState(() {
        profilePic = _profilePic;
      });

      log('pic : $profilePic');

      if (_statusCodeGetProfile == 5000) {
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

  String? claimApplicationActive;
  num? paymentAmountUptoDate;
  String? qualifiesForCompensation;
  String? uptoDatePayment;

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

      setState(() {
        uptoDatePayment = _uptoDatePayment;
        claimApplicationActive = _claimApplicationActive;
        paymentAmountUptoDate = _paymentAmount;
        qualifiesForCompensation = _qualifiesForCompensation;
      });

      log('Upt to date Payment: ${uptoDatePayment}');
      log('Claim Application Active: ${claimApplicationActive}');
      log('Payment Amount: ${paymentAmountUptoDate}');
      log('Qualifies For Compentsation: ${qualifiesForCompensation}');

      if (_statusCodeUpToDatePayment == 5000) {
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

  bool _isButtonDisabled = false;
  String _buttonText = 'Verify';
  bool isLoading = false;

  Future<void> _submitForm() async {
    if (!_isButtonDisabled) {
      setState(() {
        _isButtonDisabled = true;
        _buttonText = 'Loading...';
      }); // Perform the action that the button triggers here

      Future.delayed(const Duration(seconds: 10), () async {
        // if (formKey.currentState!.validate()) {
        // Form is valid, proceed with your logic here
        // For this example, we will simply print the email

        // print(int.parse(widget.otp[0]));
        // print(int.parse(widget.otp[1]));
        // print(int.parse(widget.otp[2]));
        // print(int.parse(widget.otp[3]));
        // print(int.parse(widget.otp[4]));
        // print(int.parse(widget.otp[5]));

        var otp = valueOneController.text +
            '' +
            valueTwoController.text +
            '' +
            valueThreeController.text +
            '' +
            valueFourController.text +
            '' +
            valueFiveController.text +
            '' +
            valueSixController.text;

        log('oTP: ${otp}');

        // print(valueOneController.text);
        // print(valueTwoController.text);
        // print(valueThreeController.text);
        // print(valueFourController.text);
        // print(valueFiveController.text);
        // print(valueSixController.text);

        await sendOTPVerify(widget.userId, otp);

        if (statusVerifyOTPCode == 5000) {
          await getNotification(
            widget.userId,
          );

          await getNotificationCount(
            widget.userId,
          );

          await defaultClaim(widget.userId, widget.promotionCode);

          await getPolicyDetails(
            widget.userId,
          );

          await getProfile(
            widget.userId,
          );

          await listClaim(
            widget.userId,
          );

          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return CommonUIPage(
                  userId: widget.userId,
                  name: widget.name,
                  msisdn: widget.phoneNo,
                  email: widget.email,
                  readStatus: readStatus,
                  title: title,
                  message: message,
                  notificationIdList: notificationIdList,
                  promotionCode: widget.promotionCode,
                  buttonClaimStatus: buttonStatus,
                  nextPayment: nextPayment,
                  paymentAmount: paymentAmount,
                  paymentPeriod: paymentPeriod,
                  policyNumber: policyNumber,
                  sumInsured: sumInsured,
                  statusCodePolicyDetails: statusCodePolicyDetails,
                  claimApplicationActive: claimApplicationActive!,
                  paymentAmountUptoDate: paymentAmountUptoDate!,
                  qualifiesForCompensation: qualifiesForCompensation!,
                  uptoDatePayment: uptoDatePayment!,
                  count: count!,
                  tableData: [],
                  rowsBenefits: [],
                  rowsSumIsured: [],
                  claimListData: claimlistData,
                  profilePic: profilePic);
              // profilePic: profilePic);
            },
          ));
        }

        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            isLoading = false;
          });
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
        // }
        setState(() {
          _isButtonDisabled = false;
          _buttonText = 'Verify';
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      uptodatePayment(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 32,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/logos/slide_five.png',
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Verification',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your OTP code number",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 28,
              ),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // TODO
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _textFieldOTPOne(first: true, last: false),
                        _textFieldOTPTwo(first: false, last: false),
                        _textFieldOTPThree(first: false, last: false),
                        _textFieldOTPFour(first: false, last: false),
                        _textFieldOTPFive(first: false, last: false),
                        _textFieldOTPSix(first: false, last: true),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        
                        onPressed: _isButtonDisabled ? null : _submitForm,
                        child: Padding(
                          padding: EdgeInsets.all(14.0),
                          child: Text(
                            _buttonText,
                            style: TextStyle(
                              fontSize: 16,
                            color: kPrimaryWhiteColor
                            
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const Text(
                "Didn't you receive any code?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 18,
              ),
              ResendCode(
                press: () async {
                  await sendOTP(widget.phoneNo);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTPOne({bool? first, last}) {
    return Container(
      height: 85,
      width: 45,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          controller: valueOneController,
          onChanged: (value) {
            // valueOneController = _otp;
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            // log('Value: ${value}');
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: kPrimaryColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTPTwo({bool? first, last}) {
    return Container(
      height: 85,
      width: 45,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          controller: valueTwoController,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            // log('Value: ${value}');
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: kPrimaryColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTPThree({bool? first, last}) {
    return Container(
      height: 85,
      width: 45,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          controller: valueThreeController,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            // log('Value: ${value}');
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: kPrimaryColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTPFour({bool? first, last}) {
    return Container(
      height: 85,
      width: 45,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          controller: valueFourController,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            // log('Value: ${value}');
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: kPrimaryColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTPFive({bool? first, last}) {
    return Container(
      height: 85,
      width: 45,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          controller: valueFiveController,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            // log('Value: ${value}');
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: kPrimaryColor),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTPSix({bool? first, last}) {
    return Container(
      height: 85,
      width: 45,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          controller: valueSixController,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
            // log('Value: ${value}');
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: kPrimaryColor),
                borderRadius: BorderRadius.circular(12)),
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
}
