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
import 'package:one_million_app/core/model/login_model.dart';
import 'package:one_million_app/core/model/regisration_otp_model.dart';
import 'package:one_million_app/core/model/registration_model.dart';
import 'package:one_million_app/core/model/registration_otp_verify.dart';
import 'package:one_million_app/shared/constants.dart';



class LoginPage extends StatefulWidget {
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

  late num _userId;
  late num _otp;
  late String _msisdn;


  Future<List<UserLoginModal>?> PostLogin(
      phoneNo,
      pinontroller,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "msisdn": phoneNo,
        "pin": pinontroller,
      });

      final response = await http.post(url, headers: headers, body: body);


      // print('Responce Status Code : ${response.statusCode}');
      // print('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);
        
        obj.forEach((key, value){
          _statusCode = obj["statusCode"];
          _statusMessage = obj["statusMessage"];
        });


      if (response.statusCode == 200) {
        await sendOTP(_msisdn);
      } else {
        throw Exception('Unexpected error occured!');
      }


        
  
      
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
    }
  }
   Future<List<UserRegistrationModal>?> sendOTP(
    _msisdn
  ) async {
    try {

      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.sendOTPEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "msisdn": _msisdn,
      });

      final response = await http.post(url, headers: headers, body: body);

      
      var obj = jsonDecode(response.body);
        
        obj.forEach((key, value){
          _statusCode = obj["statusCode"];
          _statusMessage = obj["statusMessage"];
          _otp = obj["result"]["data"]["otpId"];
        });

      // // print('Responce Status Code : ' + response.statusCode);

      if (response.statusCode == 200) {
        
       await sendOTPVerify(_userId,_otp); 
      } else {
        throw Exception('Unexpected error occured!');
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
    _userId,_otp
  ) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.sendOTPEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": _userId,
        "otp": _otp,
      });

      final response = await http.post(url, headers: headers, body: body);

      print('Responce Status Code : ${response.statusCode}');
      print('Responce Body : ${response.body}');


      if (response.statusCode == 200) {
        throw Exception('OTP verified successfully');
      } else {
        throw Exception('Unexpected error occured!');
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
                      color: phoneNode.hasFocus
                          ? kPrimaryColor
                          : Colors.grey),
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
                      color:  pinNode.hasFocus ? kPrimaryColor : Colors.grey  
                    ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock, color: kPrimaryColor,),
                  ),
                  border: myinputborder(),
                  enabledBorder: myinputborder(),
                  focusedBorder: myfocusborder(),
                ),
                validator: RequiredValidator(
                      errorText: "Required *",
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              //   child: TextFormField(
              //     textInputAction: TextInputAction.done,
              //     obscureText: true,
              //     cursorColor: kPrimaryColor,
              //     decoration: InputDecoration(
              //       hintText: "Your password",
              //       prefixIcon: Padding(
              //         padding: const EdgeInsets.all(defaultPadding),
              //         child: Icon(Icons.lock),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: defaultPadding),
              Hero(
                tag: "login_btn",
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    fixedSize: const Size(200, 40)
                  ),
                  
                  onPressed: () async {
                                  
                    await PostLogin(
                            phoneNo,
                            pinontroller.text,
                      );

                    (_statusCode == 5000)
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return  CommonUIPage();
                              },
                            ),
                          )

                          
                        : Navigator.pop(context);
                    setState(
                      () {},
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
                  child: Text(
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

  OutlineInputBorder myinputborder(){ //return type is OutlineInputBorder
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.black, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }

  OutlineInputBorder myfocusborder(){
    return const OutlineInputBorder(
        borderSide: BorderSide(
            color: kPrimaryColor, width: 0),
            borderRadius: BorderRadius.all(
            Radius.circular(8),
          )
        );
  }
}
