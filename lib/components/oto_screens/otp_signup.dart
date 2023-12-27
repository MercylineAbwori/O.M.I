import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:one_million_app/components/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/components/signin/login_screen.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/registration_model.dart';
import 'package:one_million_app/core/model/registration_otp_verify.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:http/http.dart' as http;

class OtpSignPage extends StatefulWidget {
  final String name;
  final String email;
  final String date;
  final String phoneNo;
  final String gender;
  final String pin;
  final String Confirm;
  final String promotionCode;

  const OtpSignPage(
      {super.key,
      required this.name,
      required this.email,
      required this.date,
      required this.phoneNo,
      required this.gender,
      required this.pin,
      required this.Confirm,
      required this.promotionCode,});

  @override
  State<OtpSignPage> createState() => _OtpSignState();
}


class _OtpSignState extends State<OtpSignPage> {

  bool _isButtonDisabled = false;
  String _buttonText = 'Verify';
  bool isLoading = false;

  String? phoneNo;

late String _statusMessage = '';
num? _statusCode;

late String _statusMessageResult = '';

late num userId;
late String otp;
late String _msisdn;

late String promotionCode = '';

TextEditingController otpController = TextEditingController();
//OTP
  TextEditingController valueOneController = TextEditingController();
  TextEditingController valueTwoController = TextEditingController();
  TextEditingController valueThreeController = TextEditingController();
  TextEditingController valueFourController = TextEditingController();
  TextEditingController valueFiveController = TextEditingController();
  TextEditingController valueSixController = TextEditingController();

String? _otpErrorText;

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

    var obj = jsonDecode(response.body);

    obj.forEach((key, value) {
      _statusCode = obj["result"]["code"];
      _statusMessage = obj["statusMessage"];
      userId = obj["result"]["data"]["userId"];
      _msisdn = obj["result"]["data"]["msisdn"];
      promotionCode = obj["result"]["data"]["promotionCode"];
    });

    if (response.statusCode == 5000) {
      await sendOTP(_msisdn);
    } else {
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
        otp = obj["result"]["data"]["otp"];
      });

      if (_statusCode == 5000) {
        // log("Body : ${obj}");
        // log("OTP: ${_otp}");
        // await sendOTPVerify(_userId, _otp);
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
      _statusMessageResult = obj["result"]["message"];
    });

    final snackBar = SnackBar(
      content: Text(_statusMessageResult),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (_statusCodeOTP == 5000) {
      throw Exception('OTP verified successfully');
    } else {
      final snackBar = SnackBar(
        content: Text('Ann Error has occured, please check your OTP number'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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


  Future<void> _submitForm() async {
    if (!_isButtonDisabled) {
      setState(() {
        _isButtonDisabled = true;
        _buttonText = 'Loading...';
      }); // Perform the action that the button triggers here

      Future.delayed(const Duration(seconds: 5), () async {
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

        await sendOTPVerify(userId, otp);
        await addUsers(widget.name, widget.email, widget.phoneNo, widget.date,
            widget.gender, widget.pin, widget.Confirm);
        // await sendOTPVerify(
        //     widget.userId, otpController.text);

        if (_statusMessage == "Request processed Successfully") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginScreen();
              },
            ),
          );
        }

        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            isLoading = false;
          });
        });

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

    valueOneController.text = otp[0];
        valueTwoController.text = otp[1];
        valueThreeController.text = otp[2];
        valueFourController.text = otp[3];
        valueFiveController.text = otp[4];
        valueSixController.text = otp[5];
    
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
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
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
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          // shape:
                          //     MaterialStateProperty.all<RoundedRectangleBorder>(
                          //   RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(24.0),
                          //   ),
                          // ),
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
                  // await sendOTP(){
                  //   widget.phoneNo;
                  // };
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
