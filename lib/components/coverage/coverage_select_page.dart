import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_million_app/components/coverage/coverage_screen_page.dart';
import 'package:one_million_app/components/coverage/coverage_select_subscription.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/calculator_model.dart';
import 'package:one_million_app/shared/constants.dart';

class PremiumSelect extends StatefulWidget {
  final num userId;
  final List<String> itemSelected;
  const PremiumSelect({Key? key, required this.itemSelected, required this.userId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PremiumSelectState();
}

class _PremiumSelectState extends State<PremiumSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];
  String? _currentValue;
  String? _amountPayed;

  final myController = TextEditingController();

  late String _statusMessage;
  num? _statusCode;

  NumberFormat Format = NumberFormat.decimalPattern('en_us');

// // This function is triggered when a checkbox is checked or unchecked
//   void _itemChange(String itemValue, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         _selectedItems.add(itemValue);
//       } else {
//         _selectedItems.remove(itemValue);
//       }
//     });
//   }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() async {
    if (myController.text.isNotEmpty) {
      _currentValue = myController.text;
    }

    await calculatePremium(_currentValue);

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

    // // Navigator.pop(context, _selectedItems);
    //   Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) =>  CoveragePage(userId: widget.userId, itemSelected: [], suminsured: _currentValue!, amountPayed: 0,)),
    // );
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

      print('Responce Status Code : ${response.statusCode}');
      print('Responce Body : ${response.body}');

      var obj = jsonDecode(response.body);

      obj.forEach((key, value) {
        _statusCode = obj["statusCode"];
        _statusMessage = obj["statusMessage"];
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
                          groupValue: _currentValue,
                          value: item,
                          title: Text('Ksh ${Format.format(int.parse(item))}'),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (isvalue) {
                            setState(() {
                              debugPrint('VAL = $isvalue');
                              _currentValue = isvalue;
                            });
                          },
                        ))
                    .toList(),
              ),

              // ListView.builder(
              //   scrollDirection: Axis.vertical,
              //   shrinkWrap: true,
              //   // children: widget.itemSelected
              //   //     .map((item) => RadioListTile<String>(
              //   //           groupValue: _currentTimeValue,
              //   //           value: item,
              //   //           title: Text('Ksh ${item}'),
              //   //           controlAffinity: ListTileControlAffinity.leading,
              //   //           onChanged: (isvalue) {
              //   //             setState(() {
              //   //             debugPrint('VAL = $isvalue');
              //   //             _currentTimeValue = isvalue;
              //   //               });
              //   //           },
              //   //         ))
              //   //     .toList(),
              // ),

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
                onPressed: _cancel,
                child: const Text('Cancel'),
              ),
              SizedBox(width: 20),
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
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 0),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: kPrimaryColor, width: 0),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ));
  }
}
