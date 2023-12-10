import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/coverage_selection_model.dart';
import 'package:one_million_app/shared/constants.dart';

class SubscriptionSelect extends StatefulWidget {
  final num userId;
  final String suminsured;
  final num amountPayed;
  final List<dynamic> itemSelected;
  const SubscriptionSelect({Key? key, required this.itemSelected, required this.userId, required this.amountPayed, required this.suminsured})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubscriptionSelectState();
}

class _SubscriptionSelectState extends State<SubscriptionSelect> {
  // this variable holds the selected items
  List<String> _selectedItems = [];
  String? dropdownValue;

  String? _currentValue;

  late String _statusMessage;
  num? _statusCode;

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

  void _showMultiPaymentSelect(BuildContext context) async {
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
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            fixedSize: const Size(200, 40)),
                        onPressed: () async{
                          await postCoverageSelection(
                              widget.userId,
                              widget.suminsured,
                              _currentValue,
                              widget.amountPayed,
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
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ])),
            ),
          ),
        );
      },
    );
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

  // this function is called when the Submit button is tapped
  void _submit() {
    // // Navigator.pop(context, _selectedItems);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) =>  PaymentHomePage()),
    // );

    print(_currentValue);
    _showMultiPaymentSelect(context);
  }

  Future<List<coverageSelectionModal>?> postCoverageSelection(
    userId,
    sumInsured,
    paymentPeriod,
    paymentAmount,
  ) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.coverageSelectionEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": userId,
        "sumInsured": sumInsured,
        "paymentPeriod": paymentPeriod,
        "paymentAmount": paymentAmount,
      });

      final response = await http.post(url, headers: headers, body: body);

      // print('Responce Status Code : ${response.statusCode}');
      // print('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      obj.forEach((key, value) {
        _statusCode = obj["statusCode"];
        _statusMessage = obj["statusMessage"];
      });

      if (response.statusCode == 200) {
        print("Subscribed successfully");
      } else {
        throw Exception('Unexpected Login error occured!');
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
        child: Text('Select Subscription'),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: 700,
          child: Column(
            children: [
              // ListBody(
              //   children: widget.itemSelected
              //       .map((item) => CheckboxListTile(
              //             value: _selectedItems.contains(item),
              //             title: Text(item),
              //             controlAffinity: ListTileControlAffinity.leading,
              //             onChanged: (isChecked) =>
              //                 _itemChange(item, isChecked!),
              //           ))
              //       .toList(),
              // ),
              ListBody(
                mainAxis: Axis.vertical,
                children: widget.itemSelected
                    .map((item) => RadioListTile<String>(
                          groupValue: _currentValue,
                          value: item,
                          title: Text('${item}'),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (isvalue) {
                            setState(() {
                              _currentValue = isvalue;
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
                onPressed: _cancel,
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    fixedSize: const Size(100, 40)),
                onPressed: _submit,
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
