
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one_million_app/common_ui_pages.dart';
import 'package:one_million_app/components/auth/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class OtpLoginPage extends StatefulWidget {
  final num userId;
  final String name;
  final String email;
  final String phoneNo;

  const OtpLoginPage(
      {super.key,
      required this.userId,
      required this.name,
      required this.email,
      required this.phoneNo,});

  @override
  State<OtpLoginPage> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // late String _statusMessage;
  num? statusVerifyOTPCode;

  Future<void> loadStatusCode() async {
    var _statusCode = await LocalStorage().getVerifyCode();
    if (_statusCode != null) {
      setState(() {
        statusVerifyOTPCode = _statusCode;
        log('Status OTP Code : $statusVerifyOTPCode');
      });
    }
  }
  //OTP
  TextEditingController valueOneController = TextEditingController();
  TextEditingController valueTwoController = TextEditingController();
  TextEditingController valueThreeController = TextEditingController();
  TextEditingController valueFourController = TextEditingController();
  TextEditingController valueFiveController = TextEditingController();
  TextEditingController valueSixController = TextEditingController();

  TextEditingController otpController = TextEditingController();


  num? userId;
  String? name;
  String? email;
  String? phone_no;
  String? profilePic;

  loadUserData() async {
    var _userId = await LocalStorage().getUserRegNo();
    var _name = await LocalStorage().getUserName();
    var _email = await LocalStorage().getEmail();
    var _phone_no = await LocalStorage().getPhoneNo();
    var _profilePic = await LocalStorage().getProfilePicture();
    if (_userId != null) {
      setState(() {
        userId = _userId;
        name = _name;
        email = _email;
        phone_no = _phone_no;
        profilePic = _profilePic;
      });
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


        await ApiService().sendOTPVerify(widget.userId, otp);

        await loadStatusCode();

        if (statusVerifyOTPCode != null) {
            if (statusVerifyOTPCode == 5000) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return CommonUIPage(
                    userId: widget.userId,
                    name: widget.name,
                    email: widget.email,
                    phoneNo: widget.phoneNo,
                  );
                }
              ));
            }
          } else {
            QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: "Something went wrong, try again ..",
                confirmBtnText: 'Correct',
                onConfirmBtnTap: () async {
                  Navigator.pop(context);
                });
            Navigator.pop(context);
        }

        // if (statusVerifyOTPCode == 5000) {
          // await getNotification(
          //   widget.userId,
          // );

          // await getNotificationCount(
          //   widget.userId,
          // );

          // await defaultClaim(widget.userId, widget.promotionCode);

          // await getPolicyDetails(
          //   widget.userId,
          // );

          // await getProfile(
          //   widget.userId,
          // );

          // await listClaim(
          //   widget.userId,
          // );

          // Navigator.push(context, MaterialPageRoute(
          //   builder: (context) {
          //     return CommonUIPage(
          //         userId: widget.userId,
          //         name: widget.name,
          //         msisdn: widget.phoneNo,
          //         email: widget.email,
          //         readStatus: readStatus,
          //         title: title,
          //         message: message,
          //         notificationIdList: notificationIdList,
          //         promotionCode: widget.promotionCode,
          //         buttonClaimStatus: buttonStatus,
          //         nextPayment: nextPayment,
          //         paymentAmount: paymentAmountUptoDate!,
          //         paymentPeriod: paymentPeriod,
          //         policyNumber: policyNumber,
          //         sumInsured: sumInsured,
          //         statusCodePolicyDetails: statusCodePolicyDetails,
          //         claimApplicationActive: claimApplicationActive!,
          //         paymentAmountUptoDate: paymentAmountUptoDate!,
          //         qualifiesForCompensation: qualifiesForCompensation!,
          //         uptoDatePayment: uptoDatePayment!,
          //         count: count!,
          //         tableData: [],
          //         rowsBenefits: [],
          //         rowsSumIsured: [],
          //         claimListData: claimlistData,
          //         profilePic: profilePic);
          //     // profilePic: profilePic);
          //   },
          // ));
        // }

        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            isLoading = false;
          });
        });

       
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
      ApiService().uptodatePayment(widget.userId);
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
                                fontSize: 16, color: kPrimaryWhiteColor),
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
                  await ApiService().sendOTP(widget.phoneNo);
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
