import 'dart:convert';
import 'dart:developer';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:one_million_app/components/coverage/calculator_form.dart';
import 'package:one_million_app/components/coverage/coverage_make_payments.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/core/services/models/policy_details_model.dart';
import 'package:one_million_app/core/services/models/uptodate_model.dart';
import 'package:one_million_app/core/services/providers/policy_details_providers.dart';
import 'package:one_million_app/core/services/providers/uptodate_providers.dart';

import 'package:one_million_app/shared/constants.dart';

import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoveragePage extends ConsumerStatefulWidget {
  final num userId;
  final String userName;
  final String phone;
  final String email;
  // final List<String> title;
  // final List<String> message;
  // final List<String> readStatus;
  final List<dynamic> tableData;
  // final List<num> notificationIdList;

  // final num count;

  // final String claimApplicationActive;
  // final num paymentAmountUptoDate;
  // final String qualifiesForCompensation;
  // final String uptoDatePayment;

  // final String nextPayment;
  // final String paymentPeriod;
  // final String policyNumber;
  // late num paymentAmount;
  // final num sumInsured;
  // final num statusCodePolicyDetails;

  CoveragePage({
    Key? key,
    required this.userId,
    required this.userName,
    required this.phone,
    required this.email,
    required this.tableData,
    // required this.message,
    // required this.title,
    // required this.readStatus,
    // required this.notificationIdList,
    // required this.count,
    // required this.claimApplicationActive,
    // required this.paymentAmountUptoDate,
    // required this.qualifiesForCompensation,
    // required this.uptoDatePayment,
    // required this.nextPayment,
    // required this.paymentAmount,
    // required this.paymentPeriod,
    // required this.policyNumber,
    // required this.sumInsured,
    // required this.statusCodePolicyDetails,
  }) : super(key: key);

  @override
  ConsumerState<CoveragePage> createState() => _CoverageState();
}

class _CoverageState extends ConsumerState<CoveragePage> {
  List<upToDateListItem> _dataUpToDate = [];
  var _isLoadingUpToDate = true;
  String? errorUpToDate;

  List<policyDetailsItem> _dataPolicyDetails = [];
  var _isLoadingPolicyDetails = true;
  String? errorPolicyDetails;

  List<String> _coverages = ['Benefits', 'Sum Insured'];
  List<dynamic> _selectedItems = [];
  List<dynamic> _selectedItemsValues = [];
  int? sortColumnIndex;
  bool isAscending = false;

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  String? dropdownValue;

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

  num? statusCodePolicyDetails;

  Future<void> loadUserData() async {
    var _code = await LocalStorage().getPolicyDetailsCode();
    if (_code != null) {
      setState(() {
        statusCodePolicyDetails = _code;

        log("Status policy number $statusCodePolicyDetails");
      });
    }
  }

  // Policy Details

  @override
  void initState() {
    super.initState();

    // // Reload shops
    ref.read(upToDateListProvider.notifier).fetchUpToDate();

    // // Reload shops
    ref.read(policyDetailsListProvider.notifier).fetchPolicyDetails();
  }

  late upToDateListModel availableUpToDate;
  late policyDetailsModel availablePolicyDetails;

  String? claimApplicationActive;
  num? paymentAmountUptoDate;
  String? qualifiesForCompensation;
  String? uptoDatePayment;

  //Policy Details
  late String nextPayment = '';
  late String paymentPeriod;
  late String policyNumber;
  late num paymentAmount;
  late num sumInsured;

  @override
  Widget build(BuildContext context) {
    availableUpToDate = ref.watch(upToDateListProvider);
    availablePolicyDetails = ref.watch(policyDetailsListProvider);

    setState(() {
      _dataUpToDate = availableUpToDate.uptodate_data;
      _isLoadingUpToDate = availableUpToDate.isLoading;

      _dataPolicyDetails = availablePolicyDetails.policy_details_data;
      _isLoadingPolicyDetails = availablePolicyDetails.isLoading;

      for (var i = 0; i < _dataUpToDate.length; i++) {
        claimApplicationActive = _dataUpToDate[i].claimApplicationActive;
        paymentAmountUptoDate = _dataUpToDate[i].paymentAmount;
        qualifiesForCompensation = _dataUpToDate[i].qualifiesForCompensation;
        uptoDatePayment = _dataUpToDate[i].uptoDatePayment;
      }

      for (var i = 0; i < _dataPolicyDetails.length; i++) {
        policyNumber = _dataPolicyDetails[i].policyNumber;
        nextPayment = '';
        paymentPeriod = _dataPolicyDetails[i].paymentPeriod;
        paymentAmount = _dataPolicyDetails[i].paymentAmount;
        sumInsured = _dataPolicyDetails[i].sumInsured;
      }

      loadUserData();
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
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
                                              (paymentAmountUptoDate)
                                                  .toString(),
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
                                              paymentPeriod,
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
                                                              paymentAmountUptoDate!,
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
                                                      // title: widget.title,
                                                      // message: widget.message,
                                                      // readStatus:
                                                      //     widget.readStatus,
                                                      // notificationIdList: widget
                                                      //     .notificationIdList,
                                                      // count: widget.count,
                                                    )));
                                      },
                                      child: Text(
                                        "Select Coverage Options".toUpperCase(),
                                        style: TextStyle(color: Colors.white),
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
                                  // title: widget.title,
                                  // message: widget.message,
                                  // readStatus: widget.readStatus,
                                  // notificationIdList: widget.notificationIdList,
                                  // count: widget.count,
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
