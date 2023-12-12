import 'dart:convert';
import 'dart:developer';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_million_app/common_ui.dart';
import 'package:one_million_app/core/model/coverage_model.dart';
import 'package:one_million_app/components/coverage/widget/scrollable_widget.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/components/profile/profile.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/calculator_model.dart';

import 'package:one_million_app/shared/constants.dart';

class CoveragePage extends StatefulWidget {
  final num userId;
  final String userName;
  final String phone;
  final String email;
  final List<String> message;

  final String nextPayment;
  final num paymentAmount;
  final String paymentPeriod;
  final String policyNumber;
  final num sumInsured;

  const CoveragePage(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.phone,
      required this.email,
      required this.message,
      required this.nextPayment,
      required this.paymentAmount,
      required this.paymentPeriod,
      required this.policyNumber,
      required this.sumInsured
      })
      : super(key: key);

  @override
  State<CoveragePage> createState() => _CoverageState();
}

class _CoverageState extends State<CoveragePage> {
  List<String> _coverages = ['Benefits', 'Sum Insured'];
  List<String> _selectedItems = [];
  List<dynamic> _selectedItemsValues = [];
  int? sortColumnIndex;
  bool isAscending = false;

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  String? dropdownValue;

  late String _statusMessage;
  num? _statusCode;

  //For SumIsuredSelect
  String? _currentSumInsuredValue;

//for subscrition
  String? _currentSubcriptionValue;

//premiumSelected

  num? _premiumSelected;

  //Other Data
  num? addStampDuty;
  num? annualPremium;
  num? basicPremium;
  num? dailyPremium;
  num? monthlyPremium;
  num? totalPremium;
  num? weeklyPremium;

  //Tableo
  //data rom back end
  List<Coverage> tabledata = [];
  //Rows from Backend
  List<String> rowsBenefits = [];
  List<String> rowsSumIsured = [];
  //Rows from back

  //Notification messaGE
  late List<String> message = [];

  final item = [
    '250000',
    '500000',
    '1000000',
    '2000000',
  ];

  final List<String> itemSubscription = [
    'Annualy',
    'Monthly',
    'Weekly',
    'Daily',
  ];

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
        addStampDuty = obj["result"]["data"]["addStampDuty"];
        annualPremium = obj["result"]["data"]["annualPremium"];
        basicPremium = obj["result"]["data"]["basicPremium"];
        dailyPremium = obj["result"]["data"]["dailyPremium"];
        monthlyPremium = obj["result"]["data"]["monthlyPremium"];
        totalPremium = obj["result"]["data"]["totalPremium"];
        weeklyPremium = obj["result"]["data"]["weeklyPremium"];
        var objs = obj["result"]["data"];

        for (var item in objs) {
          tabledata = item["benefits"];
        }

        if (_currentSubcriptionValue == 'Annualy') {
          var objs = obj["result"]["data"];

          for (var item in objs) {
            _premiumSelected = item["annualPremium"];
          }
        } else if (_currentSubcriptionValue == 'Mounthly') {
          var objs = obj["result"]["data"];

          for (var item in objs) {
            _premiumSelected = item["monthlyPremium"];
          }
        } else if (_currentSubcriptionValue == 'Weekly') {
          var objs = obj["result"]["data"];

          for (var item in objs) {
            _premiumSelected = item["weeklyPremium"];
          }
        } else if (_currentSubcriptionValue == 'Daily') {
          var objs = obj["result"]["data"];

          for (var item in objs) {
            _premiumSelected = item["dailyPremium"];
          }
        }
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

  void _showMultiSelect(BuildContext context) async {
    final myController = TextEditingController();

    NumberFormat Format = NumberFormat.decimalPattern('en_us');

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    children: item
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
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  void _showMultiSelectSubscription(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
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
                    children: itemSubscription
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
                    onPressed: _showMultiPaymentSelect(context),
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  _showMultiPaymentSelect(BuildContext context) async {
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
                                    _currentSumInsuredValue,
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
                                    _currentSumInsuredValue,
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
  void initState() {
    super.initState();
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
              icon: Ink.image(
                image:
                    const AssetImage('assets/icons/profile_icons/profile.jpg'),
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfileScreen(
                        userName: widget.userName,
                        userId: widget.userId,
                        phone: widget.phone,
                        email: widget.email,
                        message: widget.message,
                      );
                    },
                  ),
                );
                setState(
                  () {},
                );
              },
            ),
          ),
        ),
        actions: <Widget>[
          // notification icon
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                iconSize: 30,
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                // the method which is called
                // when button is pressed
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return NotificationPage(message: widget.message);
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          /** Card Widget **/
          child: Column(
            children: [
              const SizedBox(height: 25),
              // welcome home
              Row(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding),
                    child: const Text(
                      "Coverage",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),
              ),

              const SizedBox(height: 20),
              (tabledata.isEmpty)
                  ? Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.info,
                                  size: 100,
                                  color: kPrimaryColor,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'You have not covered',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  // style: GoogleFonts.bebasNeue(fontSize: 72),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Before subscription, you must select one our four options or either other between Ksh 250,000 to Ksh 1,000,000 by clicking on SELECT COVERAGE OPTIONS button. You can the proceed to subcribe using the SUBSCRIBE Button',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  // style: GoogleFonts.bebasNeue(fontSize: 72),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      fixedSize: const Size(300, 40)),
                                  onPressed: () {
                                    _showMultiSelect(context);
                                  },
                                  child: Text(
                                    "Select Coverage Options".toUpperCase(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'please subscribe below',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                  // style: GoogleFonts.bebasNeue(fontSize: 72),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                      fixedSize: const Size(200, 40)),
                                  onPressed: () {
                                    _showMultiSelect(context);
                                  },
                                  child: Text(
                                    "Subscribe".toUpperCase(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        // Container(
                        //   child: SingleChildScrollView(
                        //     child: Column(
                        //       children: [
                        //         const SizedBox(height: 10),
                        //         CarouselSlider(
                        //           items: [
                        //             //1st Image of Slider
                        //             Card(
                        //               child: Container(
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(12.0),
                        //                   color: kPrimaryWhiteColor,
                        //                 ),
                        //                 child: Image.asset(
                        //                   'assets/images/adverts/slide_one.jpg',
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //             ),
                        //             Card(
                        //               child: Container(
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(12.0),
                        //                   color: kPrimaryWhiteColor,
                        //                 ),
                        //                 child: Image.asset(
                        //                   'assets/images/adverts/slide_two.jpg',
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //             ),
                        //             Card(
                        //               child: Container(
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(12.0),
                        //                   color: kPrimaryWhiteColor,
                        //                 ),
                        //                 child: Image.asset(
                        //                   'assets/images/adverts/slide_three.jpg',
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //             ),
                        //             Card(
                        //               child: Container(
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(12.0),
                        //                   color: kPrimaryWhiteColor,
                        //                 ),
                        //                 child: Image.asset(
                        //                   'assets/images/adverts/slide_four.jpg',
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //             ),
                        //             Card(
                        //               child: Container(
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(12.0),
                        //                   color: kPrimaryWhiteColor,
                        //                 ),
                        //                 child: Image.asset(
                        //                   'assets/images/adverts/slide_five.jpg',
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //             ),
                        //             Card(
                        //               child: Container(
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(12.0),
                        //                   color: kPrimaryWhiteColor,
                        //                 ),
                        //                 child: Image.asset(
                        //                   'assets/images/adverts/slide_six.jpg',
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //             ),
                        //           ],

                        //           //Slider Container properties
                        //           options: CarouselOptions(
                        //               height: 200,
                        //               enlargeCenterPage: true,
                        //               autoPlay: true,
                        //               aspectRatio: 16 / 9,
                        //               autoPlayCurve: Curves.fastOutSlowIn,
                        //               enableInfiniteScroll: true,
                        //               autoPlayAnimationDuration:
                        //                   Duration(milliseconds: 800),
                        //               viewportFraction: 0.8,
                        //               onPageChanged: (index, reason) {}),
                        //         ),
                        //         // DotsIndicator(
                        //         //   dotsCount: contents.length,
                        //         //   position: _current.toInt(),
                        //         //   decorator: DotsDecorator(
                        //         //     shape: const Border(),
                        //         //     activeShape:
                        //         //         RoundedRectangleBorder(
                        //         //           borderRadius: BorderRadius.circular(35.0),),
                        //         //         color: kPrimaryColor,
                        //         //     size: Size(10, 10),
                        //         //   ),
                        //         // )
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        color: kPrimaryWhiteColor,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Next Payment: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                widget.nextPayment,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Payment Amount: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                (widget.paymentAmount)
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Payment Period: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                widget.paymentPeriod,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Policy Number: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                widget.policyNumber,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Sum Insured: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                (widget.sumInsured).toString(),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Card(
                            elevation: 10,
                            shadowColor: Colors.black,
                            color: kPrimaryWhiteColor,
                            child: ScrollableWidget(
                                child: Column(
                              children: [
                                buildDataTable(),
                                const SizedBox(height: 20),
                                Column(
                                  children: [
                                    Column(
                                      children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Annual Premium: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                (annualPremium).toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontStyle: FontStyle.italic),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Basic Premium: ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                (basicPremium).toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.normal,
                                                    fontStyle: FontStyle.italic),
                                              )
                                            ],
                                          ),
                                          
                                      ],
                                    ),
                                    const SizedBox(
                                            height: 10,
                                          ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Daily Premium: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              (dailyPremium).toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle: FontStyle.italic),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Monthly Premium: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              (monthlyPremium).toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle: FontStyle.italic),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Weekly Premium: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              (weeklyPremium).toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle: FontStyle.italic),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Total Premium: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              (totalPremium).toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle: FontStyle.italic),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                )
                              ],
                            ))),
                      ],
                    ),
            ],
          ), //Card
        ),
      ), //Center

      floatingActionButton: SpeedDial(icon: Icons.add, children: [
        SpeedDialChild(
          child: const Icon(Icons.subscriptions),
          label: 'Subscribe',
          onTap: () {
            _showMultiSelectSubscription(context);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.select_all),
          label: 'Coverage Options',
          onTap: () {
            _showMultiSelect(context);
          },
        ),
      ]),
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

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  DataTable buildDataTable() {
    final List<String> columns = new List.from(_coverages)
      ..addAll(_selectedItems);

    return DataTable(
        columns: _createColumns(columns), rows: _createRows(tabledata));
    // return DataTable(columns: _createColumns(), rows: _createRows());
  }

  List<DataColumn> _createColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();
  List<DataRow> _createRows(List<Coverage> coverage) =>
      coverage.map((Coverage coverage) {
        final cellbenefits = [coverage.name, coverage.sumInsured];
        final cells = new List.from(cellbenefits)..addAll(_selectedItemsValues);

        return DataRow(
          cells: getCells(cellbenefits),
        );
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();
  void onSort(int columnIndex, bool ascending) {
    // if (columnIndex == 0) {
    //   coverage.sort((coverage1, coverage2) =>
    //       compareString(ascending, coverage1.benefits, coverage2.benefits));
    // } else if (columnIndex == 1) {
    //   coverage.sort((coverage1, coverage2) =>
    //       compareString(ascending, '${coverage1.optionsOne}', '${coverage2.optionsOne}'));
    // }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }
}
