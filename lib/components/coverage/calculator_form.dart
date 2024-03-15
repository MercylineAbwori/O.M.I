import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:one_million_app/components/coverage/coverage_quotation_screem.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/calculator_model.dart';


class CalculatorPage extends ConsumerStatefulWidget {
  
  final num userId;
  final String userName;
  final String phone;
  final String email;
  // final List<String> title;
  // final List<String> message;
  // final List<String> readStatus;
  // final List<num> notificationIdList;
  // final num count;
  const CalculatorPage(
      {super.key,
      required this.userId,
      required this.userName,
      required this.phone,
      required this.email,
      // required this.message,
      // required this.readStatus,
      // required this.title,
      // required this.notificationIdList,
      // required this.count
      });

  
  @override
  ConsumerState<CalculatorPage> createState() {
    return _CalculatorPageState();
  }
}

class _CalculatorPageState extends ConsumerState<CalculatorPage> {
  bool _isButtonDisabled = false;
  String _buttonText = 'Login';

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  num dependants = 0;
  TextEditingController otherSumInsured = TextEditingController();

  final item = [
    '250000',
    '500000',
    '750000',
    '1000000',
  ];

  final packages = [
    "Artificial Appliances",
    "Funeral Expenses",
    "Medical Expenses",
    "Temporary Total Disability",
    "Permanent Total Disability",
    "Death"
  ];

  List<dynamic> selectedPackages = [];

  String? _sumInsuredErrorText;

  String? _currentSumInsuredValue = "";

  NumberFormat Format = NumberFormat.decimalPattern('en_us');

  void validateSumInsured(String value) {
    if (value.isEmpty) {
      _sumInsuredErrorText = "* Required";
    } else if (int.parse(value) < 250000) {
      _sumInsuredErrorText =
          "* The entered Sum Insured can not be less than Ksh 250,000";
    } else if (int.parse(value) > 1000000) {
      _sumInsuredErrorText =
          "* THe entered Sum Insured can not be more than Ksh 1,000,000";
    } else
      return null;
  }

  final List<String> _selectedItems = [];

  // This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  bool _enabledOtherSUmInsured = true;

  Future<void> _submitForm(
      String SumInsured, num dependants, List<String> Packages) async {
    print('Sum INsured : ${SumInsured}');
    print('Depandants : ${dependants}');
    print('Packages: ${Packages}');
    if (formkey.currentState!.validate()) {
      //   // Form is valid, proceed with your logic here
      //   // For this example, we will simply print the email

      if (Packages != []) {
        await calculatePremium(SumInsured, dependants, Packages);

        if (_statusCode == 5000) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CoverageTable(
                      userId: widget.userId,
                      userName: widget.userName,
                      phone: widget.phone,
                      email: widget.email,
                      tableData: tableData,
                      annualPremium: annualPremium,
                      basicPremium: annualPremium,
                      dailyPremium: dailyPremium,
                      monthlyPremium: monthlyPremium,
                      totalPremium: totalPremium,
                      weeklyPremium: weeklyPremium,
                      // title: widget.message,
                      // message: widget.message,
                      // readStatus: widget.message,
                      sumInsured: int.parse(SumInsured),
                      // notificationListId: widget.notificationIdList,
                      // count: widget.count,
                    )),
          );
        }
      }
    }
  }

  num? _premiumSelected;

  //data rom back end
  // List<dynamic> tabledata = [];

  //Other Data
  num? addStampDuty;
  num? annualPremium;
  num? basicPremium;
  num? dailyPremium;
  num? monthlyPremium;
  num? totalPremium;
  num? weeklyPremium;
  num? sumInsured;

  late String _statusMessage;
  num? _statusCode;

  List<Map<String, dynamic>> tableData = [];

  Future<List<CalculatorModal>?> calculatePremium(
      suminsured, dependants, packages) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.calculatorEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "sumInsured": int.parse(suminsured),
        "dependants": dependants.toInt(),
        "packages": packages,
      });

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Status Code : ${response.statusCode}');
      log('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
        addStampDuty = obj["result"]["data"]["addStampDuty"];
        annualPremium = obj["result"]["data"]["annualPremium"];
        basicPremium = obj["result"]["data"]["basicPremium"];
        dailyPremium = obj["result"]["data"]["dailyPremium"];
        monthlyPremium = obj["result"]["data"]["monthlyPremium"];
        totalPremium = obj["result"]["data"]["totalPremium"];
        weeklyPremium = obj["result"]["data"]["weeklyPremium"];
        var tableBenefits = obj["result"]["data"]['benefits'];
        sumInsured = obj["result"]["data"]['sumInsured'];
        // Extracting "packages" array from the JSON response
        var pgs = obj['result']['data']['packages'];

        // log('Packages: ${pgs}');
        // log('Table Benefits: ${tableBenefits}');

        tableData.clear();
        for (String package in packages) {
          // Find the corresponding benefit for the package
          var packageBenefit = tableBenefits.firstWhere(
            (benefit) => benefit['name'] == package,
            orElse: () => null,
          );

          if (packageBenefit != null) {
            tableData.add({
              'packageName': package,
              'sumInsured': packageBenefit['sumInsured']?.toInt() ?? 0,
            });
          }
        }

        for (Map<String, dynamic> row in tableData) {
          print(
              'packageName: ${row['packageName']}, sumInsured: ${row['sumInsured']}');
        }

        // log('Table ${tableData}');

        // // Iterate through packages
        // for (String package in packages) {
        //   // Find the corresponding benefit for the package
        //   var packageBenefit = tableBenefits.firstWhere(
        //     (benefit) => benefit['name'] == package,
        //     orElse: () => null,
        //   );

        //   log('Package Benefits : ${packageBenefit}');

        //   // If the benefit is found, add a row to the table
        //   if (packageBenefit != null) {
        //     tabledata.add({
        //       'packageName': package,
        //       'sumInsured': packageBenefit["sumInsured"],
        //     });
        //   }
        // }

        // for (Map<String, dynamic> row in tabledata) {
        //   print(
        //       'packageName: ${row['packageName']}, sumInsured: ${row['sumInsured']}');
        // }

        // for (var packageName in packages) {
        //   var benefits = obj['result']['data']['benefits'];
        //   tabledata = obj(benefits, packageName);

        //   print('Package: $packageName, Sum Insured: $sumInsured');

        //   log('${tabledata}');
        // }

        // var getData = tabledata.map((e) => e['name']).toList();

        // rowsBenefits.add(benefits);
        // rowsSumIsured.add(sumInsured);

        // print('Table Row Benefits Data: ${rowsBenefits}');

        // print('Table Row SumInsured Data: ${rowsBenefits}');

        // print('Table Data: ${tabledata}');
      });
      if (_statusCode == 5000) {
        throw Exception('Calculator successfully');
      } else {
        throw Exception(
            'Unexpected Calculator error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    otherSumInsured.text = _currentSumInsuredValue!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Card(
        child: SingleChildScrollView(
          child: Form(
            // autovalidate: true, //check for validation while typing
            key: formkey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),

                //Select Sum Insured
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Text(
                        'Choose or type Sum Insured',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: ListBody(
                    mainAxis: Axis.vertical,
                    children: item
                        .map((item) => RadioListTile<String>(
                              groupValue: _currentSumInsuredValue,
                              value: item,
                              title:
                                  Text('Ksh ${Format.format(int.parse(item))}'),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (isvalue) {
                                setState(() {
                                  // debugPrint('VAL = $isvalue');
                                  _currentSumInsuredValue = isvalue;
                                  otherSumInsured.text = isvalue!;
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                //Other Sum Insured
                Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                    child: TextFormField(
                      controller: otherSumInsured,
                      decoration: InputDecoration(
                        border: myinputborder(),
                        labelText: 'Other Sum Insured',
                        hintText: 'Sum Insured',
                        errorText: _sumInsuredErrorText,
                      ),
                      onTap: () {},
                      validator: (value) => _sumInsuredErrorText,
                      onChanged: validateSumInsured,
                    )),

                const SizedBox(
                  height: 20,
                ),

                //Dependants
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        'Dependants',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Note that 2 dependants is free, more than 2 will incur charges',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: InputQty(
                    maxVal: 100,
                    initVal: 0,
                    decoration: const QtyDecorationProps(
                        isBordered: false,
                        // minusBtn: ,
                        //   plusBtn: ,

                        borderShape: BorderShapeBtn.circle,
                        width: 40),
                    onQtyChanged: (val) {
                      dependants = val;
                      print(val);
                    },
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                //Packages

                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        'Packages',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'You can choose any package below',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: ListBody(
                    children: packages
                        .map((item) => CheckboxListTile(
                              value: _selectedItems.contains(item),
                              title: Text(item),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (isChecked) =>
                                  _itemChange(item, isChecked!),
                            ))
                        .toList(),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      _submitForm(
                        otherSumInsured.text,
                        dependants!,
                        _selectedItems,
                      );
                    },
                    child: Text('Done'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
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
