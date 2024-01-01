import 'dart:convert';
import 'dart:developer';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:one_million_app/components/coverage/calculator_page.dart';
import 'package:one_million_app/components/coverage/coverarage_make_payments.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/policy_details.dart';
import 'package:one_million_app/core/model/uptodate_payment_status.dart';

import 'package:one_million_app/shared/constants.dart';

import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;

class CoveragePage extends StatefulWidget {
  final num userId;
  final String userName;
  final String phone;
  final String email;
  final List<String> title;
  final List<String> message;
  final List<String> readStatus;
  final List<dynamic> tableData;
  final List<num> notificationIdList;

  final num count;

  CoveragePage(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.phone,
      required this.email,
      required this.tableData,
      required this.message,
      required this.title,
      required this.readStatus,
      required this.notificationIdList,
      required this.count})
      : super(key: key);

  @override
  State<CoveragePage> createState() => _CoverageState();
}

class _CoverageState extends State<CoveragePage> {
  List<String> _coverages = ['Benefits', 'Sum Insured'];
  List<dynamic> _selectedItems = [];
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
  // num? addStampDuty;
  // num? annualPremium;
  // num? basicPremium;
  // num? dailyPremium;
  // num? monthlyPremium;
  // num? totalPremium;
  // num? weeklyPremium;

  //Rows from back

  //Notification messaGE
  late List<String> message = [];

  final item = [
    '250000',
    '500000',
    '750000',
    '1000000',
  ];

  final List<String> itemSubscription = [
    'Annualy',
    'Monthly',
    'Weekly',
    'Daily',
  ];

  String? claimApplicationActive;
  num? paymentAmount;
  String? qualifiesForCompensation;
  String? uptoDatePayment;

  // Future<void> _showMultiSelectSubscription(BuildContext context) async {
  //   final List<dynamic>? results = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return MakePayments(
  //       //   userId: widget.userId,
  //       //     itemSelected: item,
  //       //     annualPremium: widget.annualPremium,
  //       //     basicPremium: widget.weeklyPremium,
  //       //     dailyPremium: widget.dailyPremium,
  //       //     monthlyPremium: widget.monthlyPremium,
  //       //     totalPremium: widget.totalPremium,
  //       //     weeklyPremium: widget.totalPremium,
  //       //     paymentAmount : widget.paymentAmount,
  //       //     sumInsured: widget.sumInsured);
  //       return SubscriptionSelect(
  //         userId: widget.userId,
  //         // itemSelected: item
  //         // annualPremium: widget.annualPremium,
  //         // basicPremium: widget.weeklyPremium,
  //         // dailyPremium: widget.dailyPremium,
  //         // monthlyPremium: widget.monthlyPremium,
  //         // totalPremium: widget.totalPremium,
  //         // weeklyPremium: widget.totalPremium,
  //         // phone: widget.phone,
  //         // sumInsured: widget.sumInsured,
  //         // paymentAmount: widget.paymentAmount,
  //       );
  //     },
  //   );

  //   // Update UI
  //   if (results != null) {
  //     setState(() {
  //       _selectedItems = results;
  //     });
  //   }
  // }

  //Up to date payment status Payment
  Future<List<UptodatePaymentStatusModal>?> uptodatePayment(
    userId,
  ) async {
    try {
      var url = Uri.parse(
          ApiConstants.baseUrl + ApiConstants.uptoDatePaymentEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        // "userId": userId,
        "userId": userId,
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      var _statusCodeUpToDatePayment;
      var _uptoDatePayment;
      var _claimApplicationActive;
      var _paymentAmount;
      var _qualifiesForCompensation;

      obj.forEach((key, value) {
        _statusCodeUpToDatePayment = obj["result"]["code"];

        // var uptodatedPaymentData = obj["result"];
        // // log('Up to date data : $uptodatedPaymentData');
        _uptoDatePayment = obj["result"]["data"]["uptoDatePayment"];
        _claimApplicationActive =
            obj["result"]["data"]["claimApplicationActive"];
        _paymentAmount = obj["result"]["data"]["paymentAmount"];
        _qualifiesForCompensation =
            obj["result"]["data"]["qualifiesForCompensation"];
      });

      setState(() {
        uptoDatePayment = _uptoDatePayment;
        claimApplicationActive = _claimApplicationActive;
        paymentAmount = _paymentAmount;
        qualifiesForCompensation = _qualifiesForCompensation;
      });

      log('Upt to date Payment: ${uptoDatePayment}');
      log('Claim Application Active: ${claimApplicationActive}');
      log('Payment Amount: ${paymentAmount}');
      log('Qualifies For Compentsation: ${qualifiesForCompensation}');

      if (_statusCodeUpToDatePayment == 5000) {
        throw Exception('UP TO DATE successfully');
      } else {
        throw Exception(
            'Unexpected UP TO DATE error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }
  // Policy Details

  String? nextPayment;
  String? paymentPeriod;
  String? policyNumber;
  num? sumInsured;

  num statusCodePolicyDetails = 0;

  //policy Details Modal
  Future<List<PolicyDetailsModal>?> getPolicyDetails(userId) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.policyDetailsEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        // "userId": userId,
        "userId": userId
      });

      final response = await http.post(url, headers: headers, body: body);

      var obj = jsonDecode(response.body);

      log('Responce: ${response.body}');

      obj.forEach((key, value) {
        statusCodePolicyDetails = obj["result"]["code"];

        paymentAmount = obj["result"]["data"]["paymentAmount"];
        paymentPeriod = obj["result"]["data"]["paymentPeriod"];
        policyNumber = obj["result"]["data"]["policyNumber"];
        sumInsured = obj["result"]["data"]["sumInsured"];
      });

      if (statusCodePolicyDetails == 5000) {
        throw Exception('Policy Details Displayed successfully');
      } else {
        throw Exception(
            'Unexpected Policy Details Displayed  error occured! Status code ${response.statusCode}');
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

    setState(() {
      uptodatePayment(widget.userId);
      getPolicyDetails(widget.userId);
    });
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
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20,
                  ),
                  // the method which is called
                  // when button is pressed
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: (widget.count != 0)
                      ? badges.Badge(
                          position: BadgePosition.topEnd(top: 0, end: 3),
                          badgeContent: Text(
                            (widget.count).toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.message,
                              color: kPrimaryColor,
                              size: 30,
                            ),
                            // the method which is called
                            // when button is pressed
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return NotificationPage(
                                      userId: widget.userId,
                                      readStatus: widget.readStatus,
                                      title: widget.title,
                                      message: widget.message,
                                      notificationListId:
                                          widget.notificationIdList,
                                      count: widget.count,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.message,
                            color: kPrimaryColor,
                            size: 30,
                          ),
                          // the method which is called
                          // when button is pressed
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NotificationPage(
                                    userId: widget.userId,
                                    readStatus: widget.readStatus,
                                    title: widget.title,
                                    message: widget.message,
                                    notificationListId:
                                        widget.notificationIdList,
                                    count: widget.count,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
              )
            ]),
        body: SingleChildScrollView(
            child: (statusCodePolicyDetails == 5000)
                ? Container(
                    /** Card Widget **/
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        // welcome home
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding),
                              child: const Text(
                                "Coverage Quotation",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Divider(
                            thickness: 1,
                            color: Color.fromARGB(255, 204, 204, 204),
                          ),
                        ),

                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Payment Amount: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              (paymentAmount).toString(),
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
                                              'Payment Period: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              paymentPeriod!,
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
                                              'Policy Number: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              policyNumber!,
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
                                              'Sum Insured: ',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              (sumInsured).toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle: FontStyle.italic),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MakePayments(
                                                          userId: widget.userId,
                                                          premiumSelected:
                                                              paymentAmount!,
                                                        )));
                                          },
                                          child: Card(
                                              elevation: 5,
                                              shadowColor: Colors.black,
                                              color: (uptoDatePayment ==
                                                      'payment up to date')
                                                  ? Colors.green
                                                  : Colors.red,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Center(
                                                  child: Text(uptoDatePayment!),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ), //Card
                  )
                : Container(
                    /** Card Widget **/
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        // welcome home
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding),
                              child: const Text(
                                "Coverage Quotation",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.0),
                          child: Divider(
                            thickness: 1,
                            color: Color.fromARGB(255, 204, 204, 204),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Padding(
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
                                        // _showMultiSelect(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CalculatorPage(
                                                      userId: widget.userId,
                                                      userName: widget.userName,
                                                      phone: widget.phone,
                                                      email: widget.email,
                                                      title: widget.title,
                                                      message: widget.message,
                                                      readStatus:
                                                          widget.readStatus,
                                                      notificationIdList: widget
                                                          .notificationIdList,
                                                      count: widget.count,
                                                    )));
                                      },
                                      child: Text(
                                        "Select Coverage Options".toUpperCase(),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ), //Card
                  )), //Center

        floatingActionButton: (statusCodePolicyDetails == 5000)
            ? SpeedDial(icon: Icons.add, children: [
                // SpeedDialChild(
                //   child: const Icon(Icons.subscriptions),
                //   label: 'Subscribe',
                //   onTap: () {
                //     _showMultiSelectSubscription(context);
                //   },
                // ),
                SpeedDialChild(
                  child: const Icon(Icons.select_all),
                  label: 'Coverage Options',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CalculatorPage(
                                  userId: widget.userId,
                                  userName: widget.userName,
                                  phone: widget.phone,
                                  email: widget.email,
                                  title: widget.title,
                                  message: widget.message,
                                  readStatus: widget.readStatus,
                                  notificationIdList: widget.notificationIdList,
                                  count: widget.count,
                                )));
                  },
                ),
              ])
            : null);
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
    print(widget.tableData);
    return DataTable(
        // Datatable widget that have the property columns and rows.
        columns: const [
          // Set the name of the column
          DataColumn(
            label: Text(
              'Benefits',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
          DataColumn(
            label: Text(
              'Sum Insured',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ],
        rows: widget.tableData
            .map((data) => DataRow(cells: [
                  DataCell(
                    Text((data["name"]).toString()),
                  ),
                  DataCell(
                    Text((data["sumInsured"]).toString()),
                  )
                ]))
            .toList());
  }
}
