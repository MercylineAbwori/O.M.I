import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_million_app/components/coverage/coverage_screen.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/calculator_model.dart';
import 'package:one_million_app/core/model/coverage_model.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:http/http.dart' as http;

class PremiumSelect extends StatefulWidget {
  final List<dynamic> itemSelected;
  const PremiumSelect({
    Key? key, 
    required this.itemSelected,
    }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PremiumSelectState();
}

class _PremiumSelectState extends State<PremiumSelect> {
  

  //For SumIsuredSelect
  String? _currentSumInsuredValue;
  final myController = TextEditingController();
  NumberFormat Format = NumberFormat.decimalPattern('en_us');


  //premiumSelected

  num? _premiumSelected;

  //data rom back end
  List<dynamic> tabledata = [];

  //Other Data
  num? addStampDuty;
  num? annualPremium;
  num? basicPremium;
  num? dailyPremium;
  num? monthlyPremium;
  num? totalPremium;
  num? weeklyPremium;

  late String _statusMessage;
  num? _statusCode;



  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    
    // // Navigator.pop(context);
    // Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoveragePage(
    //   userId: 0,
    //   userName: '',
    //   message: [],
    //   phone: '',
    //   email: '',
    //   nextPayment: nextPayment;
    //   paymentAmount : paymentAmount;
    //   paymentPeriod : paymentPeriod;
    //   policyNumber : policyNumber;
    //   sumInsured;
    //   message: [],
    //   tabledata: tabledata)));
  
  }

  Future<List<CalculatorModal>?> calculatePremium(suminsured) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.calculatorEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "sumInsured": suminsured,
      });

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Status Code : ${response.statusCode}');
      // print('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      obj.forEach((key, value) {
        _statusCode = obj["statusCode"];
        _statusMessage = obj["statusMessage"];
        addStampDuty = obj["result"]["data"]["addStampDuty"];
        annualPremium = obj["result"]["data"]["annualPremium"];
        basicPremium = obj["result"]["data"]["basicPremium"];
        dailyPremium = obj["result"]["data"]["dailyPremium"];
        monthlyPremium = obj["result"]["data"]["monthlyPremium"];
        totalPremium = obj["result"]["data"]["totalPremium"];
        weeklyPremium = obj["result"]["data"]["weeklyPremium"];
        tabledata = obj["result"]["data"]["benefits"];


        print('Table Data: ${tabledata}');

        // if (_currentSubcriptionValue == 'Annualy') {
        //   var objs = obj["result"]["data"];

        //   for (var item in objs) {
        //     _premiumSelected = item["annualPremium"];
        //   }
        // } else if (_currentSubcriptionValue == 'Mounthly') {
        //   var objs = obj["result"]["data"];

        //   for (var item in objs) {
        //     _premiumSelected = item["monthlyPremium"];
        //   }
        // } else if (_currentSubcriptionValue == 'Weekly') {
        //   var objs = obj["result"]["data"];

        //   for (var item in objs) {
        //     _premiumSelected = item["weeklyPremium"];
        //   }
        // } else if (_currentSubcriptionValue == 'Daily') {
        //   var objs = obj["result"]["data"];

        //   for (var item in objs) {
        //     _premiumSelected = item["dailyPremium"];
        //   }
        // }
      });

      if (response.statusCode == 200) {
        print("generated");
      } else {
        throw Exception('Unexpected Calculator error occured!');
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
    return AlertDialog(
          title: const Center(
            child: Text('Select Coverage Options'),
          ),
          content: SingleChildScrollView(
            child: Container(
              width: 700,
              child: Column(
                children: [
                  ListBody(
                    mainAxis: Axis.vertical,
                    children: widget.itemSelected
                        .map((item) => RadioListTile<String>(
                              groupValue: _currentSumInsuredValue,
                              value: item,
                              title:
                                  Text('Ksh ${Format.format(int.parse(item))}'),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (isvalue) {
                                setState(() {
                                  debugPrint('VAL = $isvalue');
                                  _currentSumInsuredValue = isvalue;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      controller: myController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Other Insured Amount",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: myinputborder(),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        fixedSize: const Size(100, 40)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        fixedSize: const Size(100, 40)),
                    onPressed: () async {
                      if (myController.text.isNotEmpty) {
                        _currentSumInsuredValue = myController.text;
                      }

                      await calculatePremium(_currentSumInsuredValue);
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
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