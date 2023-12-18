import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:one_million_app/common_ui.dart';
import 'package:one_million_app/components/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/components/signin/login_screen.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/beneficiary_model.dart';
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

class BeneficiaryScreen extends StatefulWidget {
  const BeneficiaryScreen({Key? key}) : super(key: key);

  @override
  _BeneficiaryScreenState createState() => _BeneficiaryScreenState();
}

class _BeneficiaryScreenState extends State<BeneficiaryScreen> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  TextEditingController beneficiaryNameController = TextEditingController();
  TextEditingController memeberIdController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  String initialCountry = 'KE';

  FocusNode beneficiaryNameNode = FocusNode();
  FocusNode memeberIdNode = FocusNode();
  FocusNode dateOfBirthNode = FocusNode();

  String? dropdownValue;

  late String _statusMessage;
  num? _statusCode;

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  Future<List<BeneficiaryModal>?> addBeneficiary(
    beneficiaryNameController,
    memeberIdController,
    dateOfBirthController,
    dropdownValue,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.registrationEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "beneficiaryName": beneficiaryNameController,
        "memeberId": memeberIdController,
        "gender": dropdownValue,
        "dateOfBirth": dateOfBirthController
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      obj.forEach((key, value) {
        _statusCode = obj["statusCode"];
        _statusMessage = obj["statusMessage"];
      });

      if (response.statusCode == 5000) {
        throw Exception('Beneficiary added successfully');
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              iconSize: 100,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 20,
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Card(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: basicFormKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // welcome home
                  Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: horizontalPadding),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Add Beneficiary",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),

                  const SizedBox(height: 10),

                  //Divider

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Divider(
                      thickness: 1,
                      color: Color.fromARGB(255, 204, 204, 204),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      controller: beneficiaryNameController,
                      focusNode: beneficiaryNameNode,
                      decoration: InputDecoration(
                        labelText: "Beneficiary Name",
                        labelStyle: TextStyle(
                            color: beneficiaryNameNode.hasFocus
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

                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      controller: memeberIdController,
                      focusNode: memeberIdNode,
                      decoration: InputDecoration(
                        labelText: "Member ID",
                        labelStyle: TextStyle(
                            color: memeberIdNode.hasFocus
                                ? kPrimaryColor
                                : Colors.grey),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child:
                              Icon(Icons.card_membership, color: kPrimaryColor),
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

                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
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
                    padding:
                        const EdgeInsets.symmetric(vertical: defaultPadding),
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

                  SizedBox(
                    height: 40.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          fixedSize: const Size(200, 40)),
                      onPressed: () async {
                        await addBeneficiary(
                          beneficiaryNameController.text,
                          memeberIdController.text,
                          dateOfBirthController.text,
                          dropdownValue,
                        );

                        // (_statusCode == 5000)
                        //     ?
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) {
                        //             return CommonUIPage();
                        //           },
                        //         ),
                        //       )

                        //     :
                        Navigator.pop(context);

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
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: defaultPadding / 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
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
