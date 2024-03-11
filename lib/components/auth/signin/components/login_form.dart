import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/components/auth/forgot_password_phone.dart';
import 'package:one_million_app/components/auth/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/components/auth/oto_screens/otp%20_login.dart';
import 'package:one_million_app/components/auth/sign_up/signup_screen.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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

  var _country = countries.firstWhere((element) => element.code == 'KE');

  bool isLoading = false;

  String? phoneNo;

  String? _phoneErrorText;

  String? _pinErrorText;

  num? statusCode;

  Future<void> loadStatusCode() async {
    var _statusCode = await LocalStorage().getLoginCode();
    if (_statusCode != null) {
      setState(() {
        statusCode = _statusCode;
        log('Status OTP Code : $statusCode');
      });
    }
  }

  num? userId;
  String? name;
  String? email;
  String? phone_no;

  Future<void> loadUserData() async {
    var _userId = await LocalStorage().getUserRegNo();
    var _name = await LocalStorage().getUserName();
    var _email = await LocalStorage().getEmail();
    var _phone_no = await LocalStorage().getPhoneNo();
    if (_userId != null) {
      setState(() {
        userId = _userId;
        name = _name;
        email = _email;
        phone_no = _phone_no;
        log('Status OTP Code : $statusCode');
      });
    }
  }

  bool passwordVisiblePin = false;
  bool passwordVisibleConfirmPin = false;

  @override
  void initState() {
    super.initState();
    passwordVisiblePin = true;
    passwordVisibleConfirmPin = true;
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

          await ApiService().postLogin(phoneNo, pinController.text);

          log('Phone: ${phoneNo}');
          log('Pin: ${pinController.text}');

          await loadStatusCode();
          await loadUserData();

          if (userId != null) {
            if (statusCode == 5000) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return OtpLoginPage(
                      userId: userId!,
                      name: name!,
                      email: email!,
                      phoneNo: phone_no!,
                    );
                  },
                ),
              );
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
