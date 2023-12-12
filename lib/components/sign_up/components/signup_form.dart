import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/components/onbording_screens/already_have_an_account_acheck.dart';
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
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController passwordontroller = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController promotionCodeController = TextEditingController();

  String initialCountry = 'KE';

  FocusNode nameNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode genderNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode passwordConfirmNode = FocusNode();
  FocusNode dateOfBirthNode = FocusNode();
  FocusNode promotionCodeNode = FocusNode();

  String? dropdownValue;

  String? phoneNo;

  late String _statusMessage;
  num? _statusCode;

  late num _userId;
  late num _otp;
  late String _msisdn;

  late String promotionCode;

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
        _statusCode = obj["statusCode"];
        _statusMessage = obj["statusMessage"];
        _userId = obj["result"]["data"]["userId"];
        _msisdn = obj["result"]["data"]["msisdn"];
        promotionCode = obj["result"]["data"]["promotionCode"];
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
        _statusCode = obj["statusCode"];
        _statusMessage = obj["statusMessage"];
        _otp = obj["result"]["data"]["otpId"];
      });

      // // print('Responce Status Code : ' + response.statusCode);

      if (response.statusCode == 200) {
        await sendOTPVerify(_userId, _otp);
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
      _userId, _otp) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.sendOTPEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": _userId,
        "otp": _otp,
      });

      final response = await http.post(url, headers: headers, body: body);

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
    return ChangeNotifierProvider<UserModal>(
      create: (context) => UserModal(),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Consumer<UserModal>(
          builder: (context, modal, child) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: basicFormKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          cursorColor: kPrimaryColor,
                          controller: nameController,
                          focusNode: nameNode,
                          onSaved: (name) {},
                          decoration: InputDecoration(
                            labelText: "Your Name",
                            labelStyle: TextStyle(
                                color: nameNode.hasFocus
                                    ? kPrimaryColor
                                    : Colors.grey),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(defaultPadding),
                              child: Icon(Icons.person, color: kPrimaryColor),
                            ),
                            border: myinputborder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                          ),
                          validator: RequiredValidator(
                            errorText: "Required *",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            cursorColor: kPrimaryColor,
                            controller: emailController,
                            focusNode: emailNode,
                            onSaved: (email) {},
                            decoration: InputDecoration(
                              labelText: "Your email",
                              labelStyle: TextStyle(
                                  color: emailNode.hasFocus
                                      ? kPrimaryColor
                                      : Colors.grey),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(defaultPadding),
                                child: Icon(Icons.mail, color: kPrimaryColor),
                              ),
                              border: myinputborder(),
                              enabledBorder: myinputborder(),
                              focusedBorder: myfocusborder(),
                            ),
                            validator: MultiValidator([
                              RequiredValidator(
                                errorText: "Required *",
                              ),
                              EmailValidator(
                                errorText: "Not Valid Email",
                              ),
                            ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: IntlPhoneField(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: TextFormField(
                          focusNode: dateOfBirthNode,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            border: myinputborder(),
                            enabledBorder: myinputborder(),
                            focusedBorder: myfocusborder(),
                          ),
                          controller: dateOfBirthController,
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
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            hint: const Text(
                              'Gender',
                              style: TextStyle(fontSize: 17),
                            ),
                            value: dropdownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'field required' : null,
                            items: <String>['female', 'male']
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
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: Column(
                          children: [
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              cursorColor: kPrimaryColor,
                              controller: passwordontroller,
                              focusNode: passwordNode,
                              decoration: InputDecoration(
                                labelText: "Your password",
                                labelStyle: TextStyle(
                                    color: passwordNode.hasFocus
                                        ? kPrimaryColor
                                        : Colors.grey),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(Icons.lock, color: kPrimaryColor),
                                ),
                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),
                              ),
                              validator: MinLengthValidator(
                                6,
                                errorText: "Min 6 characters required",
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              cursorColor: kPrimaryColor,
                              controller: passwordConfirmController,
                              focusNode: passwordConfirmNode,
                              decoration: InputDecoration(
                                labelText: "Confirm password",
                                labelStyle: TextStyle(
                                    color: passwordConfirmNode.hasFocus
                                        ? kPrimaryColor
                                        : Colors.grey),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child: Icon(Icons.lock, color: kPrimaryColor),
                                ),
                                border: myinputborder(),
                                enabledBorder: myinputborder(),
                                focusedBorder: myfocusborder(),
                              ),
                              // validator: MinLengthValidator(
                              //   6, errorText: "Min 6 characters required",
                              // ),
                              // validator: (value) {
                              //   if (passwordontroller !=
                              //       passwordConfirmController) {
                              //     return 'The password does not match';
                              //   }
                              //   MinLengthValidator(
                              //     6,
                              //     errorText: "Min 6 characters required",
                              //   );
                              // },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: defaultPadding / 2,
                      ),
                      SizedBox(
                        height: 40.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              fixedSize: const Size(200, 40)),
                          onPressed: () async {
                            await addUsers(
                                nameController.text,
                                emailController.text,
                                phoneNo,
                                dateOfBirthController.text,
                                dropdownValue,
                                passwordConfirmController.text,
                                passwordontroller.text);

                            (_statusCode == 5000)
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LoginScreen(promotionCode: promotionCode);
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

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            cursorColor: kPrimaryColor,
                            controller: promotionCodeController,
                            focusNode: promotionCodeNode,
                            onSaved: (email) {},
                            decoration: InputDecoration(
                              labelText: "Your Promo Code",
                              labelStyle: TextStyle(
                                  color: emailNode.hasFocus
                                      ? kPrimaryColor
                                      : Colors.grey),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.all(defaultPadding),
                                child: Icon(Icons.mail, color: kPrimaryColor),
                              ),
                              border: myinputborder(),
                              enabledBorder: myinputborder(),
                              focusedBorder: myfocusborder(),
                            ),
                          
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AlreadyHaveAnAccountCheck(
                        login: false,
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginScreen(promotionCode: promotionCode,);
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
