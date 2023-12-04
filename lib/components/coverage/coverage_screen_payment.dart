import 'package:flutter/material.dart';
import 'package:one_million_app/shared/constants.dart';
class PaymentSelect extends StatefulWidget {
  final List<dynamic> itemSelected;
  const PaymentSelect({Key? key, required this.itemSelected}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentSelectState();
}

class _PaymentSelectState extends State<PaymentSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

  String? dropdownValue;

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

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    // Navigator.pop(context, _selectedItems);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            
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
                              child: const Icon(Icons
                                  .arrow_back) // the arrow back icon
                              ),
                        ),
                        title: const Center(
                            child: Text(
                                "Select  payment") // Your desired title
                            )),
                    Padding(
                      padding: const EdgeInsets.all(40),
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
                          validator: (value) => value == null
                              ? 'field required'
                              : null,
                          items: <String>['MPESA', 'Bank']
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
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
                          fixedSize: const Size(200, 40)
                        ),
                        onPressed: () {
                          // (dropdownValue == "MPESA")
                          //     ? Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 const MpesaHomePage()),
                          //       )
                          //     : Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) =>
                          //                 const BankHomePage()),
                          //       );
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ]
                )
              ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: const Text('Select Subscription'),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: 700,
          child: Column(
            children: [
              ListBody(
                children: widget.itemSelected
                    .map((item) => CheckboxListTile(
                          value: _selectedItems.contains(item),
                          title: Text(item),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (isChecked) =>
                              _itemChange(item, isChecked!),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                fixedSize: const Size(100, 40)
              ),
              onPressed: _cancel,
              child: const Text('Cancel'),
            ),
            SizedBox(width: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                fixedSize: const Size(100, 40)
              ),
              onPressed: _submit,
              child: const Text('Submit'),
            ),
          ],
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
