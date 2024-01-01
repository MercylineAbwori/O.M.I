import 'dart:convert';
import 'dart:math';
import 'package:badges/badges.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:one_million_app/components/coverage/calculator_page.dart';
import 'package:one_million_app/components/coverage/coverarage_make_payments.dart';
import 'package:one_million_app/components/coverage/widget/scrollable_widget.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/coverage_selection_model.dart';
import 'package:one_million_app/core/model/policy_details.dart';
import 'package:one_million_app/core/model/uptodate_payment_status.dart';

import 'package:one_million_app/shared/constants.dart';
import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;

class CoverageTablePage extends StatefulWidget {
  final num userId;
  final String userName;
  final String phone;
  final String email;
  final List<dynamic> tableData;

  num? sumInsured;

  final List<String> title;
  final List<String> message;
  final List<String> readStatus;
  final List<num> notificationListId;

  // //Other Data
  // final num? addStampDuty;
  final num? annualPremium;
  final num? basicPremium;
  final num? dailyPremium;
  final num? monthlyPremium;
  final num? totalPremium;
  final num? weeklyPremium;

  final num count;

  CoverageTablePage(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.phone,
      required this.email,
      required this.tableData,
      required this.annualPremium,
      required this.basicPremium,
      required this.dailyPremium,
      required this.monthlyPremium,
      required this.totalPremium,
      required this.weeklyPremium,
      required this.message,
      required this.readStatus,
      required this.title,
      required this.sumInsured,
      required this.notificationListId,
      required this.count})
      : super(key: key);

  @override
  State<CoverageTablePage> createState() => _CoverageTableState();
}

class _CoverageTableState extends State<CoverageTablePage> {
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

  //POST SELECTION
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

      var _statusCodeSubscription;

      obj.forEach((key, value) {
        _statusCodeSubscription = obj["result"]["code"];
        _statusMessage = obj["result"]["message"];
      });

      if (_statusCodeSubscription == 5000) {
        throw Exception('Subscribed successfully');
      } else {
        throw Exception(
            'Unexpected Subscribed error occured! Status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      // log(e.toString());
    }
  }

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

      obj.forEach((key, value) {
        _statusCodeUpToDatePayment = obj["result"]["code"];
        _statusMessage = obj["statusMessage"];

        // var uptodatedPaymentData = obj["result"];
        // // log('Up to date data : $uptodatedPaymentData');
        uptoDatePayment = obj["result"]["data"]["uptoDatePayment"];
        claimApplicationActive =
            obj["result"]["data"]["claimApplicationActive"];
        paymentAmount = obj["result"]["data"]["paymentAmount"];
        qualifiesForCompensation =
            obj["result"]["data"]["qualifiesForCompensation"];
      });

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

  @override
  void initState() {
    super.initState();

    setState(() {
      uptodatePayment(widget.userId);
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
            // notification icon
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
                                        widget.notificationListId,
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
                                  notificationListId: widget.notificationListId,
                                  count: widget.count
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: (widget.tableData.isEmpty)
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
                                                          .notificationListId,
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
                  )
                : Container(
                    /** Card Widget **/
                    child: Column(children: [
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
                      Column(children: [
                        const SizedBox(height: 10),
                        Card(
                            elevation: 10,
                            shadowColor: Colors.black,
                            child: ScrollableWidget(
                                child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  buildDataTable(),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ))),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 10,
                          shadowColor: Colors.black,
                          child: Center(
                            child: GridView.count(
                              primary: false,
                              padding: const EdgeInsets.all(20),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              childAspectRatio: ((200 / 200)),
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: TextButton(
                                    onPressed: () async {
                                      await postCoverageSelection(
                                          widget.userId,
                                          widget.sumInsured,
                                          'Annualy',
                                          widget.annualPremium);

                                      if (_statusMessage ==
                                          "Request processed Successfully") {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return MakePayments(
                                              userId: widget.userId,
                                              premiumSelected:
                                                  widget.annualPremium!,
                                            );
                                          },
                                        ));
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Icon(Icons.money,
                                                    size: 24,
                                                    color: kPrimaryColor),
                                                padding:
                                                    const EdgeInsets.all(12),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Annual Premium',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(12),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Container(
                                                child: Text(
                                                  'Ksh ${(widget.annualPremium).toString()}',
                                                  style: TextStyle(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: TextButton(
                                    onPressed: () async {
                                      await postCoverageSelection(
                                          widget.userId,
                                          widget.sumInsured,
                                          'Monthly',
                                          widget.monthlyPremium);

                                      if (_statusMessage ==
                                          "Request processed Successfully") {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return MakePayments(
                                              userId: widget.userId,
                                              premiumSelected:
                                                  widget.monthlyPremium!,
                                            );
                                          },
                                        ));
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Icon(Icons.money,
                                                    size: 24,
                                                    color: kPrimaryColor),
                                                padding:
                                                    const EdgeInsets.all(12),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Monthly Premium',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(12),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Container(
                                                child: Text(
                                                  'Ksh ${(widget.monthlyPremium).toString()}',
                                                  style: TextStyle(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: TextButton(
                                    onPressed: () async {
                                      await postCoverageSelection(
                                          widget.userId,
                                          widget.sumInsured,
                                          'Weekly',
                                          widget.weeklyPremium);

                                      if (_statusMessage ==
                                          "Request processed Successfully") {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return MakePayments(
                                              userId: widget.userId,
                                              premiumSelected:
                                                  widget.weeklyPremium!,
                                            );
                                          },
                                        ));
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Icon(Icons.money,
                                                    size: 24,
                                                    color: kPrimaryColor),
                                                padding:
                                                    const EdgeInsets.all(12),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Weekly Premium',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(12),
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              Container(
                                                child: Text(
                                                  'Ksh ${(widget.weeklyPremium).toString()}',
                                                  style: TextStyle(
                                                      color: kPrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: TextButton(
                                    onPressed: () async {
                                      await postCoverageSelection(
                                          widget.userId,
                                          widget.sumInsured,
                                          'Daily',
                                          widget.dailyPremium);

                                      if (_statusMessage ==
                                          "Request processed Successfully") {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return MakePayments(
                                              userId: widget.userId,
                                              premiumSelected:
                                                  widget.dailyPremium!,
                                            );
                                          },
                                        ));
                                      }
                                    },
                                    child: Card(
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Icon(Icons.money,
                                                      size: 24,
                                                      color: kPrimaryColor),
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Daily Premium',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Container(
                                                  child: Text(
                                                    'Ksh ${(widget.dailyPremium).toString()}',
                                                    style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ])
                    ]
                        //Card
                        ), //Center
                  )),
        floatingActionButton: (!widget.tableData.isEmpty)
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
                                  notificationIdList: widget.notificationListId,
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
                    Text((data["packageName"]).toString()),
                  ),
                  DataCell(
                    Text((data["sumInsured"]).toString()),
                  )
                ]))
            .toList());
  }

  // Function to get the sum insured for a specific package
  int getSumInsured(List benefits, String packageName) {
    for (var benefit in benefits) {
      if (benefit['name'] == packageName) {
        print('Just Checking: ${benefit['sumInsured']}');
        return benefit['sumInsured'];
      }
    }
    return 0; // Default value if not found
  }
}
