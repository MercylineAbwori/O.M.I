import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/common_ui.dart';
import 'package:one_million_app/components/forgot_password_phone.dart';
import 'package:one_million_app/components/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/components/oto_screens/otp%20_login.dart';
import 'package:one_million_app/components/sign_up/signup_screen.dart';
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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isButtonDisabled = false;
  String _buttonText = 'Sign In';

  TextEditingController phoneController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  String initialCountry = 'KE';

  FocusNode phoneNode = new FocusNode();
  FocusNode pinNode = new FocusNode();

  String? phoneNo;

  String? _statusMessage;
  num? _statusCode;

  //User Details
  String? _email;
  String? _msisdn;
  String? _name;

  num? _userId;

  String? _otp;

  late List<String> message = [];

  late List<dynamic> claimlistData = [];

  late String uptoDatePaymentData = '';

  late bool buttonStatus;

  late String profilePic;

  String? _phoneErrorText;

  String? _pinErrorText;

  var _country = countries.firstWhere((element) => element.code == 'KE');

  bool isLoading = false;

  bool passwordVisiblePin = false;
  bool passwordVisibleConfirmPin = false;

  @override
  void initState() {
    super.initState();
    passwordVisiblePin = true;
    passwordVisibleConfirmPin = true;
  }

  Future<List<UserLoginModal>?> PostLogin(
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
      // print('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      var userId;

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
        userId = obj["result"]["data"]["UserDetails"]["userId"];
        _name = obj["result"]["data"]["UserDetails"]["name"];
        _email = obj["result"]["data"]["UserDetails"]["email"];
        _msisdn = obj["result"]["data"]["UserDetails"]["msisdn"];
      });

      setState(() {
        _userId = userId;
      });

      if (_statusCode == 5000) {
        _isButtonDisabled = false;
        _buttonText = 'Login';
        await sendOTP(_msisdn);
        log('Login Sucesss the code is ${_statusCode}');

        // final snackBar = SnackBar(
        //   content: Text(_statusMessage!),
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
          msg: _statusMessage!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        _isButtonDisabled = false;
        _buttonText = 'Login';
        //   final snackBar = SnackBar(
        //   content: Text("Wrong phone number or pin"),
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

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
        _otp = obj["result"]["data"]["otp"];
      });

      if (_statusCode == 5000) {
        // log("Body : ${obj}");
        // log("OTP: ${_otp}");
        // await sendOTPVerify(_userId, _otp);
        _isButtonDisabled = false;
        _buttonText = 'Login';
      } else {
        _isButtonDisabled = false;
        _buttonText = 'Login';
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

  Future<void> _submitForm() async {
    if (!_isButtonDisabled) {
      setState(() {
        _isButtonDisabled = true;
        _buttonText = 'Loading...';
      }); // Perform the action that the button triggers here

      Future.delayed(const Duration(seconds: 6), () async {
        if (formKey.currentState!.validate()) {
          // Form is valid, proceed with your logic here
          // For this example, we will simply print the email

          await PostLogin(phoneNo, pinController.text);

          print('Phone: ${phoneNo}');
          print('Pin: ${pinController.text}');

          if (_statusMessage == "Request processed Successfully") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return OtpLoginPage(
                      userId: _userId!,
                      name: _name!,
                      email: _email!,
                      message: message,
                      phoneNo: phoneController.text,
                      pin: pinController.text,
                      promotionCode: '',
                      otp: _otp!);
                },
              ),
            );
          }

          Future.delayed(const Duration(seconds: 3), () {
            setState(() {
              isLoading = false;
            });
          });
        }
        setState(() {
          _isButtonDisabled = false;
          _buttonText = 'Sign In';
        });
      });
    }
  }

  String formattedPhoneNumber = '';
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Log In',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: IntlPhoneField(
                    disableLengthCheck: true,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    cursorColor: kPrimaryColor,
                    controller: phoneController,
                    onSaved: (phone) {},
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter phone number',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(defaultPadding),
                        child: Icon(
                          Icons.phone,
                          color: kPrimaryColor,
                        ),
                      ),
                      border: myinputborder(),
                      // enabledBorder: myinputborder(),
                      // focusedBorder: myfocusborder(),
                    ),
                    initialCountryCode: 'KE',
                    onChanged: (phone) {
                      phoneNo = phone.completeNumber;
                      // Remove leading '0' and enforce a length of 9
                      String sanitizedNumber =
                          phone.completeNumber.startsWith('0')
                              ? phone.completeNumber.substring(1)
                              : phone.completeNumber;

                      if (sanitizedNumber.length == 9) {
                        setState(() {
                          formattedPhoneNumber = sanitizedNumber;
                        });
                      }
                      print(phoneController);
                    },
                    validator: (value) {
                      var _countryLImit = countries.firstWhere(
                          (element) => element.code == value!.countryISOCode);

                      print(_countryLImit.maxLength);
                      if (value!.number.isEmpty) {
                        setState(() {
                          _phoneErrorText = "* Required";
                        });
                      } else if (value.number.length >= _country.minLength &&
                          value.number.length <= _country.maxLength) {
                        setState(() {
                          // Run anything here
                        });
                      } else {
                        setState(() {
                          _phoneErrorText = null;
                        });
                      }
                    },
                    onCountryChanged: (country) => _country = country,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      FilteringTextInputFormatter.deny(RegExp('^0+')),
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      // obscureText: true,
                      obscureText: passwordVisiblePin,
                      controller: pinController,
                      decoration: InputDecoration(
                        border: myinputborder(),
                        labelText: 'Pin',
                        hintText: 'Enter secure pin',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(Icons.lock, color: kPrimaryColor),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisiblePin
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisiblePin = !passwordVisiblePin;
                              },
                            );
                          },
                        ),
                        errorText: _pinErrorText,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          setState(() {
                            _pinErrorText = "* Required";
                          });
                        }
                        // else if (value.length < 4) {
                        //   _pinErrorText = "Password should be atleast 4 characters";
                        // }
                        else if (value.length > 4) {
                          setState(() {
                            _pinErrorText =
                                "Password should not be greater than 4 characters";
                          });
                        } else {
                          setState(() {
                            _pinErrorText = null;
                          });
                        }
                      }, //Function to check validation
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ForgotPasswordCheck(
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ForgotPasswordPhone();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: defaultPadding),
              Hero(
                tag: "login_btn",
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      fixedSize: const Size(200, 40)),
                  onPressed: _isButtonDisabled ? null : _submitForm,
                  child: Text(
                    _buttonText,
                    style: TextStyle(color: kPrimaryWhiteColor),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              AlreadyHaveAnAccountCheck(
                login: true,
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
