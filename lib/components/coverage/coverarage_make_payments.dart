import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/components/coverage/coverage_screen.dart';
import 'package:one_million_app/components/oto_screens/otp.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/coverage_model.dart';
import 'package:one_million_app/core/model/mpesa_model.dart';
import 'package:one_million_app/core/model/registration_model.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class MakePayments extends StatefulWidget {
  final num userId;
  final num premiumSelected;
  //Other Data
  // final num? annualPremium;
  // final num? basicPremium;
  // final num? dailyPremium;
  // final num? monthlyPremium;
  // final num? totalPremium;
  // final num? weeklyPremium;
  // final num sumInsured;
  // final num paymentAmount;
  // final String currentSubcriptionValue;
  const MakePayments({
    super.key,
    required this.userId,
    required this.premiumSelected,
    // required this.annualPremium,
    // required this.basicPremium,
    // required this.dailyPremium,
    // required this.monthlyPremium,
    // required this.totalPremium,
    // required this.weeklyPremium,
    // required this.sumInsured,
    // required this.paymentAmount,
    // required this.currentSubcriptionValue
  });

  @override
  _MakePaymentsState createState() => _MakePaymentsState();
}

class _MakePaymentsState extends State<MakePayments> {
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

  late String _statusMessage;
  num? _statusCode;
  late String? _otp;

  bool _isButtonDisabled = false;
  String _buttonText = 'Pay';
  bool isLoading = false;

  late String phoneNo;

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
      final body = jsonEncode(
        
          {"amount": (amount).toString(), "userId": userId, "phoneNumber": phoneNo});

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      log('Make Payment Data: ${response.body}');

      var _statusCodeMpesaPayment;

      obj.forEach((key, value) {
        _statusCodeMpesaPayment = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
      });

      if (_statusCodeMpesaPayment == 5000) {
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

        log('AMount : ${widget.premiumSelected.toInt()}');
        log('UserId : ${widget.userId}');
        log('Phone Number : ${phoneNo}');

        await mpesaPayment(
            widget.premiumSelected.toInt(), widget.userId, phoneNo);

        if (_statusMessage == "Request processed Successfully") {
          QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: _statusMessage,
              confirmBtnText: 'Done',
              cancelBtnText: 'Cancel',
              onConfirmBtnTap: () async {
                Navigator.pop(context);
              },
              onCancelBtnTap: () async {
                Navigator.pop(context);
              });
        } else {
          QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: _statusMessage,
              confirmBtnText: 'Done',
              cancelBtnText: 'Cancel',
              onConfirmBtnTap: () async {
                Navigator.pop(context);
              },
              onCancelBtnTap: () async {
                Navigator.pop(context);
              });
          Navigator.pop(context);
        }

        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            isLoading = false;
          });
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
          _buttonText = 'Pay';
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
                  'assets/logos/slide_four.png',
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Make Payments',
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
                          onChanged: (phone) {
                            phoneNo = phone.completeNumber;
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
