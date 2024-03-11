import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/components/auth/oto_screens/otp.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ForgotPasswordPhone extends StatefulWidget {
  const ForgotPasswordPhone({super.key});

  @override
  _ForgotPasswordPhoneState createState() => _ForgotPasswordPhoneState();
}

class _ForgotPasswordPhoneState extends State<ForgotPasswordPhone> {
   GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  var _country = countries.firstWhere((element) => element.code == 'KE');

  String? _phoneErrorText;

  bool passwordVisiblePin = false;
  bool passwordVisibleConfirmPin = false;

  @override
  void initState() {
    super.initState();
    passwordVisiblePin = true;
    passwordVisibleConfirmPin = true;
  }

  // late String _statusMessage;
  num? statusCode;

  Future<void> loadStatusCode() async {
    var _statusCode = await LocalStorage().getOTP();
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

  String? phoneNo;

  bool _isButtonDisabled = false;
  String _buttonText = 'Submit';
  bool isLoading = false;

  Future<void> _submitForm() async {
    if (!_isButtonDisabled) {
      setState(() {
        _isButtonDisabled = true;
        _buttonText = 'Loading...';
      }); // Perform the action that the button triggers here

      Future.delayed(const Duration(seconds: 5), () async {
        // if (formkey.currentState!.validate()) {
        // Form is valid, proceed with your logic here
        // For this example, we will simply print the email

        

        await ApiService().sendOTP(phoneNo);
        await loadStatusCode();
        await loadUserData();

        if (statusCode != null) {
            if (statusCode == 5000) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return OtpPage(
                    phone: phoneNo!,
                    userId: userId!,
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

        
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            isLoading = false;
          });
        });

        // Show a simple toast message
        // Fluttertoast.showToast(
        //   msg: _statusMessage,
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   timeInSecForIosWeb: 1,
        //   backgroundColor: Colors.grey,
        //   textColor: Colors.white,
        //   fontSize: 16.0,
        // );
        // }
        setState(() {
          _isButtonDisabled = false;
          _buttonText = 'Submit';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body: SafeArea(
        child: Form(
          key: formkey,
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
                  'Forgot Pin',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Enter your phone number",
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
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
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
                            onChanged: (phone) {
                                phoneNo = phone.completeNumber;
                                // Remove leading '0' and enforce a length of 9
                                String sanitizedNumber =
                                    phone.completeNumber.startsWith('0')
                                        ? phone.completeNumber.substring(1)
                                        : phone.completeNumber;

                                
                              },
                            initialCountryCode: 'KE',
                            validator: (value) {
                              var _countryLImit = countries.firstWhere(
                                  (element) =>
                                      element.code == value!.countryISOCode);
        
                              print(_countryLImit.maxLength);
                              if (value!.number.isEmpty) {
                                setState(() {
                                  _phoneErrorText = "* Required";
                                });
                              } else if (value.number.length >=
                                      _country.minLength &&
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
                      const SizedBox(
                        height: 22,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isButtonDisabled ? null : _submitForm,
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
                          child: Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              _buttonText,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFieldOTP({bool? first, last}) {
    return Container(
      height: 85,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.length == 0 && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
