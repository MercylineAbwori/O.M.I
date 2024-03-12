import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_million_app/common_ui_pages.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/beneficiary_model.dart';
import 'package:one_million_app/core/model/more_beneficiary-model.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;

class BeneficiaryFormPage extends StatefulWidget {
  final num userId;
  final String name;
  final String email;
  final String phoneNo;

  BeneficiaryFormPage({
    super.key,
    required this.userId,
      required this.name,
      required this.email,
      required this.phoneNo,
  });

  @override
  State<BeneficiaryFormPage> createState() => _BeneficiaryFormPageState();
}

class _BeneficiaryFormPageState extends State<BeneficiaryFormPage> {

  GlobalKey<FormState> basicFormKey = GlobalKey<FormState>();

  TextEditingController beneficiaryNameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  String initialCountry = 'KE';

  FocusNode beneficiaryNameNode = FocusNode();
  FocusNode dateOfBirthNode = FocusNode();

  String? dropdownValue;

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  String? _lnameErrorText;
  String? _dateErrorText;

  late String _statusMessage;
  num? _statusCode;

  late String _statusMessageAfterCharges;
  num? _statusCodeAfterCharges;

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

      log('$obj');

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
      });

      if (_statusCode == 5000) {
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

  Future<List<AddMoreBeneficiaryModal>?> addMoreBeneficiary(userId) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.beneficiaryLimitEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": userId,
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      obj.forEach((key, value) {
        _statusCodeAfterCharges = obj["result"]["code"];
        _statusMessageAfterCharges = obj["result"]["message"];
      });

      log('Response :${response.body}');

      if (_statusCodeAfterCharges == 5000) {
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return BeneficiaryScreen(
        //       userId: widget.userId,
        //       name: widget.name,
        //       msisdn: widget.msisdn,
        //       email: widget.email,
        //       promotionCode: widget.promotionCode,
        //       notificationIdList: widget.notificationIdList,
        //       buttonClaimStatus: widget.buttonClaimStatus,
        //       nextPayment: widget.nextPayment,
        //       paymentAmount: widget.paymentAmount,
        //       paymentPeriod: widget.paymentPeriod,
        //       policyNumber: widget.policyNumber,
        //       sumInsured: widget.sumInsured,
        //       tableData: widget.tableData,
        //       rowsBenefits: widget.rowsBenefits,
        //       rowsSumIsured: widget.rowsSumIsured,
        //       claimListData: widget.claimListData,
        //       profilePic: widget.profilePic,
        //       readStatus: widget.readStatus,
        //       message: widget.message,
        //       title: widget.title,
        //       count: widget.count);
        // }));

        // //   cancelBtnText: 'Add more Beneficiary',
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
          (_statusCode == 5555)
              ? QuickAlert.show(
                  context: context,
                  type: QuickAlertType.info,
                  title: 'Proceed with charges',
                  text: _statusMessage,
                  confirmBtnText: 'Charges',
                  cancelBtnText: 'Cancel',
                  onConfirmBtnTap: () async {
                    await addMoreBeneficiary(widget.userId);

                    // (_statusCodeAfterCharges == 5000)
                    //     ? Navigator.pop(context)
                    //     : null;
                  },
                  onCancelBtnTap: () async {
                    // Navigator.pop(context);
                  })
              : QuickAlert.show(
                  context: context,
                  type: QuickAlertType.info,
                  title: 'Dependent Added successfully',
                  text: _statusMessage,
                  confirmBtnText: 'Done',
                  cancelBtnText: 'Cancel',
                  onConfirmBtnTap: () async {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CommonUIPage(
                            userId: widget.userId,
                            name: widget.name,
                            phoneNo: widget.phoneNo,
                            email: widget.email,);
                      },
                    ));
                  },
                  onCancelBtnTap: () async {
                    Navigator.pop(context);
                  });
        }
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
     body: Card(
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add Dependants",
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
                                child: Icon(Icons.person, color: kPrimaryColor),
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
                          child:
                              Icon(Icons.calendar_today, color: kPrimaryColor),
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
                      validator: (value) => value == null ? "* Required" : null,
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

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: _isButtonDisabled ? null : _submitForm,
                      child: Text(
                        _buttonText,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          fixedSize: const Size(200, 40)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
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
