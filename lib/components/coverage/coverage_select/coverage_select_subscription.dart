import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_million_app/components/coverage/coverarage_make_payments.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/calculator_model.dart';
import 'package:one_million_app/core/model/coverage_model.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:http/http.dart' as http;

class SubscriptionSelect extends StatefulWidget {

  final num userId;
  final String phone;
  final List<dynamic> itemSelected;
  //Other Data
  final num? annualPremium;
  final num? basicPremium;
  final num? dailyPremium;
  final num? monthlyPremium;
  final num? totalPremium;
  final num? weeklyPremium;
  final num sumInsured;
  final num paymentAmount;
  const SubscriptionSelect({Key? key, 
  required this.userId,
  required this.phone,
  required this.itemSelected,
  required this.annualPremium,
  required this.basicPremium,
  required this.dailyPremium,
  required this.monthlyPremium,
  required this.totalPremium,
  required this.weeklyPremium,
  required this.sumInsured,
  required this.paymentAmount}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubscriptionSelectState();
}

class _SubscriptionSelectState extends State<SubscriptionSelect> {
  

  
  final myController = TextEditingController();
  NumberFormat Format = NumberFormat.decimalPattern('en_us');

  //for subscrition
  String? _currentSubcriptionValue;


  //premiumSelected

  num? _premiumSelected;

  //data rom back end
  List<Coverage> tabledata = [];

 

  late String _statusMessage;
  num? _statusCode;

  String? dropdownValue;



  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    
    Navigator.pop(context);
  
  }

  _showMultiPaymentSelect(BuildContext context) async {

    if (_currentSubcriptionValue == 'Annualy') {

            _premiumSelected = widget.annualPremium;
          
        } else if (_currentSubcriptionValue == 'Mounthly') {
          
            _premiumSelected = widget.monthlyPremium;
          
        } else if (_currentSubcriptionValue == 'Weekly') {
          
            _premiumSelected = widget.weeklyPremium;
          
        } else if (_currentSubcriptionValue == 'Daily') {
          
            _premiumSelected = widget.dailyPremium;
          
        }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Container(
              width: 700,
              child: Container(
                  color: Colors.white,
                  child: Column(children: [
                    ListTile(
                        leading: Material(
                          color: Colors.transparent,
                          child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: const Icon(
                                  Icons.arrow_back) // the arrow back icon
                              ),
                        ),
                        title: const Center(
                            child: Text("Select payment") // Your desired title
                            )),
                    Padding(
                      padding: EdgeInsets.all(40),
                      child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          hint: const Text(
                            'Select  payment',
                            style: TextStyle(fontSize: 20),
                          ),
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'field required' : null,
                          items: <String>['MPESA', 'Bank']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  if (value == "MPESA") ...[
                                    Image.asset(
                                      "assets/icons/submenu_icons/mpesa.png",
                                      height: 25,
                                      width: 25,
                                    ),
                                  ] else ...[
                                    Image.asset(
                                      "assets/icons/submenu_icons/bank_transfer.png",
                                      height: 25,
                                      width: 25,
                                    ),
                                  ],
                                  Text(
                                    value,
                                  ),
                                ],
                              ),
                            );
                          }).toList()),
                    ),
                    SizedBox(
                        height: 45.0,
                        width: 200,
                        child: (dropdownValue == "MPESA")
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    fixedSize: const Size(200, 40)),
                                onPressed: () async {
                                  await ApiService().mpesaPayment(
                                      _premiumSelected,
                                      widget.userId,
                                      widget.phone);
                                  await ApiService().postCoverageSelection(
                                    widget.userId,
                                    widget.sumInsured,
                                    _currentSubcriptionValue,
                                    _premiumSelected,
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
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    fixedSize: const Size(200, 40)),
                                onPressed: () async {
                                  await ApiService().postCoverageSelection(
                                    widget.userId,
                                    widget.sumInsured,
                                    _currentSubcriptionValue,
                                    _premiumSelected,
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
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                              )),
                  ])),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
          title: const Center(
            child: Text('Select Subscription'),
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
                              groupValue: _currentSubcriptionValue,
                              value: item,
                              title: Text('${item}'),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (isvalue) {
                                setState(() {
                                  _currentSubcriptionValue = isvalue;
                                });
                              },
                            ))
                        .toList(),
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
                  const SizedBox(width: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        fixedSize: const Size(100, 40)),
                    // onPressed: _showMultiPaymentSelect(context),
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MakePayments(    
                              userId: widget.userId,
                                annualPremium: widget.annualPremium,
                                basicPremium: widget.weeklyPremium,
                                dailyPremium: widget.dailyPremium,
                                monthlyPremium: widget.monthlyPremium,
                                totalPremium: widget.totalPremium,
                                weeklyPremium: widget.totalPremium,
                                paymentAmount : widget.paymentAmount,
                                sumInsured: widget.sumInsured,
                                currentSubcriptionValue: _currentSubcriptionValue!,);
                          },
                        ),
                      );
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