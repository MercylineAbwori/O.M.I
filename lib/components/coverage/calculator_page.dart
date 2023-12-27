import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:one_million_app/components/coverage/coverage_screen.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/calculator_model.dart';

class CalculatorPage extends StatefulWidget {

  final num userId;

  final String uptoDatePayment;

  final String promotionCode;

  final bool buttonClaimStatus;

  final String nextPayment;
  final num paymentAmount;
  final String paymentPeriod;
  final String policyNumber;
  final num sumInsured;

  final String claimApplicationActive;
 final String qualifiesForCompensation;
 final String userName;
  final String phone;
  final String email;
  final List<String> title;
  final List<String> message;
  final List<String> readStatus;
  final List<num> notificationIdList;
  const CalculatorPage({super.key,
  required this.userId,
      required this.userName,
      required this.phone,
      required this.email,
      required this.message,
      required this.title,
      required this.notificationIdList,
      required this.readStatus,
      required this.nextPayment,
      required this.paymentAmount,
      required this.paymentPeriod,
      required this.policyNumber,
      required this.sumInsured,
      required this.buttonClaimStatus,
      required this.promotionCode,
      required this.claimApplicationActive,
      required this.qualifiesForCompensation,
      required this.uptoDatePayment
  });

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
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

  String? _sumInsuredErrorText;

  String? _currentSumInsuredValue = "";

  NumberFormat Format = NumberFormat.decimalPattern('en_us');

  void validateSumInsured(String value) {
    _currentSumInsuredValue = otherSumInsured.text;

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

      // _submitForm(_currentSumInsuredValue!, dependants!, _selectedItems);
    });
  }

  bool _enabledOtherSUmInsured = true;

  Future<void> _submitForm(
      String SumInsured, num dependants, List<String> Packages) async {
    print('Sum INsured : ${SumInsured}');
    print('Depandants : ${dependants}');
    print('Packages: ${Packages}');
    // if (formkey.currentState!.validate()) {
    //   // Form is valid, proceed with your logic here
    //   // For this example, we will simply print the email
    // }
    if (Packages != []) {
      await calculatePremium(SumInsured, dependants, Packages);
    }
  }

  num? _premiumSelected;

  //data rom back end
  List<dynamic> tabledata = [];

  List<dynamic> rowsBenefits = [];
  List<dynamic> rowsSumIsured = [];

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

  Future<List<CalculatorModal>?> calculatePremium(
      suminsured, dependants, packages) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.calculatorEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "sumInsured": suminsured,
        "dependants": dependants,
        "packages": packages,
      });

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Status Code : ${response.statusCode}');
      log('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      obj.forEach((key, value) {
        _statusCode = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];
        addStampDuty = obj["result"]["data"]["addStampDuty"];
        annualPremium = obj["result"]["data"]["annualPremium"];
        basicPremium = obj["result"]["data"]["basicPremium"];
        dailyPremium = obj["result"]["data"]["dailyPremium"];
        monthlyPremium = obj["result"]["data"]["monthlyPremium"];
        totalPremium = obj["result"]["data"]["totalPremium"];
        weeklyPremium = obj["result"]["data"]["weeklyPremium"];
        tabledata = obj["result"]["data"]["benefits"];

        var benefits = tabledata.map((e) => e['name']).toList();
        var sumInsured = tabledata.map((e) => e['sumInsured']).toList();

        // rowsBenefits.add(benefits);
        // rowsSumIsured.add(sumInsured);

        for (var item in benefits) {
          rowsBenefits.add(item);
        }

        for (var items in sumInsured) {
          rowsSumIsured.add(items);
        }

        // print('Table Row Benefits Data: ${rowsBenefits}');

        // print('Table Row SumInsured Data: ${rowsBenefits}');

        // print('Table Data: ${tabledata}');

        print('Table Data: ${tabledata}');
      });
      if (response.statusCode == 5000) {
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

    _submitForm(_currentSumInsuredValue!, dependants, _selectedItems);
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

                                  _submitForm(
                                    _currentSumInsuredValue!,
                                    dependants!,
                                    _selectedItems,
                                  );
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
                        errorText: otherSumInsured.text,
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
                      _submitForm(
                        _currentSumInsuredValue!,
                        dependants!,
                        _selectedItems,
                      );
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
                  
                  onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CoveragePage(
                            userId: widget.userId,
                            userName: widget.userName,
                            phone: widget.phone,
                            email: widget.email,
                            title: widget.title,
                            message: widget.message,
                            readStatus: widget.readStatus,
                            notificationIdList: widget.notificationIdList,
                            nextPayment: widget.nextPayment,
                            paymentAmount: widget.paymentAmount,
                            paymentPeriod: widget.paymentPeriod,
                            policyNumber: widget.policyNumber,
                            sumInsured: int.parse(_currentSumInsuredValue!),
                            claimApplicationActive: widget.claimApplicationActive,
                            qualifiesForCompensation: widget.claimApplicationActive,
                            buttonClaimStatus: widget.buttonClaimStatus,
                            promotionCode: widget.promotionCode,
                            tableData: tabledata,
                            rowsBenefits: rowsBenefits,
                            rowsSumIsured: rowsSumIsured,
                            addStampDuty: addStampDuty,
                            annualPremium: annualPremium,
                            basicPremium: basicPremium,
                            dailyPremium: dailyPremium,
                            monthlyPremium: monthlyPremium,
                            totalPremium: totalPremium,
                            weeklyPremium: weeklyPremium,
                            uptoDatePayment: widget.paymentPeriod,)),
                  );
                  },
                  child: Text(
                    'Done'
                  ),
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
