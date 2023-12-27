import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/components/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/components/oto_screens/otp_signup.dart';
import 'package:one_million_app/components/signin/login_screen.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/regisration_otp_model.dart';
import 'package:one_million_app/core/model/registration_model.dart';
import 'package:one_million_app/core/model/registration_otp_verify.dart';
import 'package:one_million_app/core/model/user_model.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

//constants
const buttonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w900,
);

// class SignUpForm extends StatelessWidget {
//   const SignUpForm({
//     Key? key,
//   }) : super(key: key);
class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isButtonDisabled = false;
  String _buttonText = 'Sign Up';

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String? dropdownValue;
  String? FullName;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  TextEditingController pinConfirmController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController promotionCodeController = TextEditingController();

  var _country = countries.firstWhere((element) => element.code == 'KE');

  String? _fnameErrorText;
  String? _lnameErrorText;

  String? _emailErrorText;

  bool isEmailValid(String email) {
    // Basic email validation using regex
    // You can implement more complex validation if needed
    return RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  String? _dateErrorText;

  String? _phoneErrorText;

  String? _pinErrorText;

  String? _confirmPinErrorText;

  bool passwordVisiblePin = false;
  bool passwordVisibleConfirmPin = false;

  @override
  void initState() {
    super.initState();
    passwordVisiblePin = true;
    passwordVisibleConfirmPin = true;
  }

  String initialCountry = 'KE';

  

  Future<void> _submitForm() async {
    if (!_isButtonDisabled) {
      setState(() {
        _isButtonDisabled = true;
        _buttonText = 'Loading...';
      });
      // Perform the action that the button triggers here

      Future.delayed(const Duration(seconds: 5), () async {
        if (formkey.currentState!.validate()) {
          // Form is valid, proceed with your logic here
          // For this example, we will simply print the email

          FullName = '${fnameController.text} ${lnameController.text}';
          print('Name: ${FullName}');
          print('Email: ${emailController.text}');
          print('Date: ${dateOfBirthController.text}');
          print('Gender: ${dropdownValue}');
          print('Phone: ${phoneController.text}');
          print('Promo code: ${promotionCodeController.text}');
          print('Pin: ${pinController.text}');
          print('Confirm Pin: ${pinConfirmController.text}');

          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return OtpSignPage(
                name: lnameController.text,
                email: emailController.text,
                date: dateOfBirthController.text,
                phoneNo: phoneController.text,
                gender : dropdownValue!,
                pin: pinController.text,
                Confirm: pinConfirmController.text,
                promotionCode: promotionCodeController.text,
                
              );
              // return CommonUIPage(
              //     userId: _userId,
              //     name: _name!,
              //     msisdn: _msisdn,
              //     email: _email,
              //     message: message,
              //     uptoDatePaymentData: uptoDatePaymentData,
              //     promotionCode: widget.promotionCode,
              //     buttonClaimStatus: buttonStatus,
              //     nextPayment: nextPayment,
              //     paymentAmount: paymentAmount,
              //     paymentPeriod: paymentPeriod,
              //     policyNumber: policyNumber,
              //     sumInsured: sumInsured,
              //     tableData: [],
              //     rowsBenefits: [],
              //     rowsSumIsured: [],
              //     claimListData: claimlistData,
              //     profilePic: '');
              // profilePic: profilePic);
            },
          ));
          // ignore: use_build_context_synchronously
        }
        setState(() {
          _isButtonDisabled = false;
          _buttonText = 'Sign Up';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserModal>(
      create: (context) => UserModal(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Consumer<UserModal>(
          builder: (context, modal, child) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formkey,
                  child: Column(
                    children: [

                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 15,
                                    bottom: 0),
                                child: TextFormField(
                                  controller: lnameController,
                                  decoration: InputDecoration(
                                    border: myinputborder(),
                                    labelText: 'Full Name',
                                    hintText:
                                        'Enter Full name with single space',
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(defaultPadding),
                                      child: Icon(Icons.person,
                                          color: kPrimaryColor),
                                    ),
                                    errorText: _lnameErrorText,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        _lnameErrorText = "* Required";
                                      });
                                    } else {
                                      setState(() {
                                        _lnameErrorText = null;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: myinputborder(),
                            labelText: 'Email',
                            hintText: 'Enter valid email id as abc@gmail.com',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Icon(Icons.mail, color: kPrimaryColor),
                            ),
                            errorText: _emailErrorText,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              setState(() {
                                _emailErrorText = "* Required";
                              });
                            } else if (!isEmailValid(value)) {
                              setState(() {
                                _emailErrorText = 'Invalid Email';
                              });
                            } else {
                              setState(() {
                                _emailErrorText = null;
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 15, bottom: 0),
                          child: TextFormField(
                            controller: dateOfBirthController,
                            decoration: InputDecoration(
                              border: myinputborder(),
                              labelText: 'Date of Birth',
                              hintText: 'Enter the date of birth',
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(defaultPadding),
                                child: Icon(Icons.calendar_today,
                                    color: kPrimaryColor),
                              ),
                              errorText: _dateErrorText,
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2050));

                              if (pickedDate != null) {
                                dateOfBirthController.text =
                                    DateFormat("yyyy-MM-dd HH:mm:ss")
                                        .format(pickedDate);
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                setState(() {
                                  _dateErrorText = "* Required";
                                });
                              } else {
                                setState(() {
                                  _dateErrorText = null;
                                });
                              }
                            },
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: myinputborder(),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(defaultPadding),
                                child: Icon(
                                  Icons.person_add,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            hint: const Text(
                              'Select Gender',
                              style: TextStyle(fontSize: 17),
                            ),
                            value: dropdownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            validator: (value) =>
                                value == null ? "* Required" : null,
                            items: <String>['Female', 'Male']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    Text(
                                      value,
                                    ),
                                  ],
                                ),
                              );
                            }).toList()),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        child: IntlPhoneField(
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
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        child: TextFormField(
                          controller: promotionCodeController,
                          decoration: InputDecoration(
                            border: myinputborder(),
                            labelText: 'Promocode',
                            hintText: 'Enter valid promocode',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Icon(Icons.code, color: kPrimaryColor),
                            ),
                            // errorText: _promoErrorText,
                          ),
                          validator: (value) {
                            // if (value!.isEmpty) {
                            //   setState(() {
                            //     _promoErrorText = "* Required";
                            //   });
                            // } else {
                            //   setState(() {
                            //     _promoErrorText = null;
                            //   });
                            // }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        child: TextFormField(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15, bottom: 0),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          obscureText: passwordVisiblePin,
                          controller: pinConfirmController,
                          decoration: InputDecoration(
                            border: myinputborder(),
                            labelText: 'Confirm Pin',
                            hintText: 'Repeat the pin to confirm',
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Icon(Icons.lock, color: kPrimaryColor),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisibleConfirmPin
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    passwordVisibleConfirmPin =
                                        !passwordVisibleConfirmPin;
                                  },
                                );
                              },
                            ),
                            errorText: _confirmPinErrorText,
                          ),
                          validator: (value) {
                            if (value == pinController) {
                              setState(() {
                                _confirmPinErrorText = "Does not match the Pin";
                              });
                            } else {
                              setState(() {
                                _confirmPinErrorText = null;
                              });
                            }
                          }, //Function to check validation
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: 250,
                        child: ElevatedButton(
                          onPressed: _isButtonDisabled ? null : _submitForm,
                          child: Text(
                            _buttonText,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AlreadyHaveAnAccountCheck(
                        login: false,
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const LoginScreen();
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
          },
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

Widget CustomButton(
    {required String title,
    required IconData icon,
    required VoidCallback onClick}) {
  return Container(
    width: 200,
    child: ElevatedButton(
      onPressed: onClick,
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Text(title)
        ],
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryLightColor,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
    ),
  );
}
