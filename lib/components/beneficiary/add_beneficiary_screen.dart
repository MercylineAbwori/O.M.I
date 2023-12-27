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
import 'package:one_million_app/core/model/more_beneficiary-model.dart';
import 'package:one_million_app/core/model/regisration_otp_model.dart';
import 'package:one_million_app/core/model/registration_model.dart';
import 'package:one_million_app/core/model/registration_otp_verify.dart';
import 'package:one_million_app/core/model/user_model.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

//constants
const buttonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.w900,
);

class BeneficiaryScreen extends StatefulWidget {
  final num userId;
  final String name;
  final String msisdn;
  final String email;

  final List<String> title;
  final List<String> message;
  final List<String> readStatus;
  final List<num> notificationIdList;

  final String uptoDatePayment;
 final String claimApplicationActive;
 final String qualifiesForCompensation;
  final num paymentAmount;
  

  final String promotionCode;

  final bool buttonClaimStatus;

  //Policy Details

  final String nextPayment;
  final String paymentPeriod;
  final String policyNumber;
  final num sumInsured;

  final List<dynamic> tableData;

  final List<dynamic> rowsBenefits;
  final List<dynamic> rowsSumIsured;

  final List<dynamic> claimListData;

  final String profilePic;
  const BeneficiaryScreen({
    super.key,
    required this.userId,
    required this.name,
      required this.msisdn,
      required this.email,
      required this.title,
      required this.message,
      required this.notificationIdList,
      required this.readStatus,
      required this.uptoDatePayment,
      required this.claimApplicationActive,
      required this.qualifiesForCompensation,
      required this.promotionCode,
      required this.buttonClaimStatus,
      required this.nextPayment,
      required this.paymentAmount,
      required this.paymentPeriod,
      required this.policyNumber,
      required this.sumInsured,
      required this.tableData,
      required this.rowsBenefits,
      required this.rowsSumIsured,
      required this.claimListData,
      required this.profilePic
  });

  @override
  _BeneficiaryScreenState createState() => _BeneficiaryScreenState();
}

class _BeneficiaryScreenState extends State<BeneficiaryScreen> {
  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  TextEditingController beneficiaryNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  String initialCountry = 'KE';

  FocusNode beneficiaryNameNode = FocusNode();
  FocusNode dateOfBirthNode = FocusNode();

  String? dropdownValue;

  late String _statusMessage;
  num? _statusCode;

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  String? _lnameErrorText;
  String? _dateErrorText;

  Future<List<BeneficiaryModal>?> addBeneficiary(
    beneficiaryNameController,
    dateOfBirthController,
    dropdownValue,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.beneficiaryEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "beneficiaryName": beneficiaryNameController,
        "memberId": widget.userId,
        "gender": dropdownValue,
        "dateOfBirth": dateOfBirthController
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCode;

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
      });

      if (response.statusCode == 5000) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Beneficiary added successfully',
            confirmBtnText: 'Done',
            cancelBtnText: 'Add more Beneficiary',
            onConfirmBtnTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CommonUIPage(
                          userId: widget.userId,
                          name: widget.name,
                          msisdn: widget.msisdn,
                          email: widget.email,
                          readStatus: widget.readStatus,
                          title: widget.title,
                          message: widget.message,
                          notificationIdList: widget.notificationIdList,
                          uptoDatePayment: widget.uptoDatePayment,
                          qualifiesForCompensation: widget.qualifiesForCompensation,
                          claimApplicationActive: widget.claimApplicationActive,
                          promotionCode: widget.promotionCode,
                          buttonClaimStatus: widget.buttonClaimStatus,
                          nextPayment: widget.nextPayment,
                          paymentAmount: widget.paymentAmount,
                          paymentPeriod: widget.paymentPeriod,
                          policyNumber: widget.policyNumber,
                          sumInsured: widget.sumInsured,
                          tableData: [],
                          rowsBenefits: [],
                          rowsSumIsured: [],
                          claimListData: widget.claimListData,
                          profilePic: widget.profilePic);
                    },
                  ),
                );

            },
            onCancelBtnTap: () async {

            });

        //   cancelBtnText: 'Add more Beneficiary',
        //   cancelBtnText: ,
        // );
      } else {
        throw Exception(
            'Unexpected Beneficiary added error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }
  Future<List<AddMoreBeneficiaryModal>?> addMoreBeneficiary(
    
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.beneficiaryLimitEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": widget.userId,
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCode;

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
      });

      if (response.statusCode == 5000) {
        QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Beneficiary added successfully',
            confirmBtnText: 'Done',
            cancelBtnText: 'Add more Beneficiary',
            onConfirmBtnTap: () async {

            },
            onCancelBtnTap: () async {
              
            });

        //   cancelBtnText: 'Add more Beneficiary',
        //   cancelBtnText: ,
        // );
      } else {
        throw Exception(
            'Unexpected Beneficiary added error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  bool _isButtonDisabled = false;
  String _buttonText = 'Submit';

  bool _isButtonDisabledAddMore = false;
  String _buttonTextAddMore = 'Charge';

  Future<void> _submitForm() async {
    if (!_isButtonDisabled) {
      setState(() {
        _isButtonDisabled = true;
        _buttonText = 'Loading...';
      });
      // Perform the action that the button triggers here

      Future.delayed(const Duration(seconds: 5), () async {
        if (basicFormKey.currentState!.validate()) {
          // Form is valid, proceed with your logic here
          // For this example, we will simply print the email

          await addBeneficiary(
            beneficiaryNameController.text,
            dateOfBirthController.text,
            dropdownValue,
          );
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
        }
        setState(() {
          _isButtonDisabled = false;
          _buttonText = 'Submit';
        });
      });
    }
  }

  Future<void> _submitFormAddMore() async {
    if (!_isButtonDisabledAddMore) {
      setState(() {
        _isButtonDisabledAddMore = true;
        _buttonTextAddMore = 'Loading...';
      });
      // Perform the action that the button triggers here

      Future.delayed(const Duration(seconds: 5), () async {
        if (basicFormKey.currentState!.validate()) {
          // Form is valid, proceed with your logic here
          // For this example, we will simply print the email

          await addMoreBeneficiary(
          );
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
        }
        setState(() {
          _isButtonDisabledAddMore = false;
          _buttonTextAddMore = 'Charge';
        });
      });
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
                            EdgeInsets.symmetric(horizontal: 20),
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
                    padding: const EdgeInsets.all(1.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 15, bottom: 0),
                            child: TextFormField(
                              controller: beneficiaryNameController,
                              decoration: InputDecoration(
                                border: myinputborder(),
                                labelText: 'Beneficiary Name',
                                hintText: 'Enter Full name with single space',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(defaultPadding),
                                  child:
                                      Icon(Icons.person, color: kPrimaryColor),
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

                  const SizedBox(
                    width: 20,
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
                      )),
                  const SizedBox(
                    width: 20,
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
                  const SizedBox(
                    width: 20,
                  ),

                  SizedBox(
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: _isButtonDisabled ? null : _submitForm,
                      child: Text(
                        _buttonText,
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          fixedSize: const Size(200, 40)),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: 40.0,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text('If you agree with the charges then proceed by clicking below'))
                          ],
                        ),
                        ElevatedButton(
                          onPressed: _isButtonDisabledAddMore ? null : _submitFormAddMore,
                          child: Text(
                            _buttonTextAddMore,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              fixedSize: const Size(200, 40)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
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
