import 'package:flutter/material.dart';
import 'package:one_million_app/shared/constants.dart';

class PremiumSelect extends StatefulWidget {
  final List<dynamic> itemSelected;
  const PremiumSelect({Key? key, required this.itemSelected}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PremiumSelectState();
}

class _PremiumSelectState extends State<PremiumSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];

  final myController = TextEditingController();

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
    _selectedItems.add(myController.text);
    Navigator.pop(context, _selectedItems);
    //   Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const CoveragePage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: const Text('Select Coverage Options'),
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
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
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
