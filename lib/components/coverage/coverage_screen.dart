import 'dart:convert';
import 'dart:developer';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_million_app/common_ui.dart';
import 'package:one_million_app/components/coverage/calculator_page.dart';
import 'package:one_million_app/components/coverage/coverage_select/coverage_select_options.dart';
import 'package:one_million_app/components/coverage/coverage_select/coverage_select_subscription.dart';
import 'package:one_million_app/components/coverage/coverarage_make_payments.dart';
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
  final List<String> title;
  final List<String> readStatus;
  final List<num> notificationIdList;

  final String uptoDatePayment;

  final String promotionCode;

  final bool buttonClaimStatus;

  final String nextPayment;
  final num paymentAmount;
  final String paymentPeriod;
  final String policyNumber;
  final num sumInsured;
  final List<dynamic> tableData;

  final List<dynamic> rowsBenefits;
  final List<dynamic> rowsSumIsured;

  //Other Data
  final num? addStampDuty;
  final num? annualPremium;
  final num? basicPremium;
  final num? dailyPremium;
  final num? monthlyPremium;
  final num? totalPremium;
  final num? weeklyPremium;

  final String claimApplicationActive;
  final String qualifiesForCompensation;

  CoveragePage(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.phone,
      required this.email,
      required this.title,
      required this.message,
      required this.readStatus,
      required this.notificationIdList,
      required this.nextPayment,
      required this.paymentAmount,
      required this.paymentPeriod,
      required this.policyNumber,
      required this.sumInsured,
      required this.tableData,
      required this.rowsBenefits,
      required this.rowsSumIsured,
      required this.buttonClaimStatus,
      required this.promotionCode,
      required this.uptoDatePayment,
      required this.claimApplicationActive,
      required this.qualifiesForCompensation,
      required this.addStampDuty,
      required this.annualPremium,
      required this.basicPremium,
      required this.dailyPremium,
      required this.monthlyPremium,
      required this.totalPremium,
      required this.weeklyPremium})
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
  num? addStampDuty;
  num? annualPremium;
  num? basicPremium;
  num? dailyPremium;
  num? monthlyPremium;
  num? totalPremium;
  num? weeklyPremium;

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

  Future<void> _showMultiSelectSubscription(BuildContext context) async {
    final List<dynamic>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        // return MakePayments(    
        //   userId: widget.userId,
        //     itemSelected: item,
        //     annualPremium: widget.annualPremium,
        //     basicPremium: widget.weeklyPremium,
        //     dailyPremium: widget.dailyPremium,
        //     monthlyPremium: widget.monthlyPremium,
        //     totalPremium: widget.totalPremium,
        //     weeklyPremium: widget.totalPremium,
        //     paymentAmount : widget.paymentAmount,
        //     sumInsured: widget.sumInsured);
        return SubscriptionSelect(
            userId: widget.userId,
            itemSelected: item,
            annualPremium: widget.annualPremium,
            basicPremium: widget.weeklyPremium,
            dailyPremium: widget.dailyPremium,
            monthlyPremium: widget.monthlyPremium,
            totalPremium: widget.totalPremium,
            weeklyPremium: widget.totalPremium,
            phone: widget.phone,
            sumInsured: widget.sumInsured,
            paymentAmount: widget.paymentAmount,);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    claimApplicationActive = widget.claimApplicationActive;
    paymentAmount = widget.paymentAmount;
    qualifiesForCompensation = widget.qualifiesForCompensation;
    uptoDatePayment = widget.uptoDatePayment;

    print('Next Payment ${widget.nextPayment}');
    print('${widget.paymentAmount}');
    print('${widget.paymentPeriod}');
    print('${widget.policyNumber}');
    print('${widget.sumInsured}');
    print('${widget.claimApplicationActive}');
    print('${widget.qualifiesForCompensation}');
    print('${widget.uptoDatePayment}');
    print('${widget.buttonClaimStatus}');
    print('${widget.promotionCode}');


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
                        return NotificationPage(
                            userId: widget.userId,
                            readStatus: widget.readStatus,
                            title: widget.title,
                            message: widget.message);
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: (widget.tableData.isEmpty)?
        
        Container(
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
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
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
                                    (widget.sumInsured)
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.normal,
                                        fontStyle:
                                            FontStyle.italic),
                                  )
                                ],
                              ),
                              const SizedBox(height: 5),
                              
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                  color: (widget.uptoDatePayment ==
                                          'payment up to date')
                                      ? Colors.green
                                      : Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Text(widget.uptoDatePayment),
                                    ),
                                  )),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Click here to pay'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),

              

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
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => CalculatorPage(
                                          userId: widget.userId,
                                            userName: widget.userName,
                                            phone: widget.phone,
                                            email: widget.email,
                                            message: widget.message,
                                            title: widget.title,
                                            readStatus: widget.readStatus,
                                            notificationIdList: widget.notificationIdList,
                                            nextPayment: widget.nextPayment,
                                            paymentAmount: widget.paymentAmount,
                                            paymentPeriod: widget.paymentPeriod,
                                            policyNumber: widget.policyNumber,
                                            sumInsured: widget.sumInsured,
                                            claimApplicationActive: widget.claimApplicationActive,
                                            qualifiesForCompensation: widget.qualifiesForCompensation,
                                            uptoDatePayment: widget.uptoDatePayment,
                                            buttonClaimStatus: widget.buttonClaimStatus,
                                            promotionCode: widget.promotionCode,

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
        ):
        Container(
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
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
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
                                    (widget.sumInsured)
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
                              
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Card(
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                  color: (widget.uptoDatePayment ==
                                          'payment up to date')
                                      ? Colors.green
                                      : Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                      child: Text(widget.uptoDatePayment),
                                    ),
                                  )),
                              ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Click here to pay'))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),

              

              const SizedBox(height: 20),
              Column(
                      children: [
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
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
                                                  (widget.sumInsured)
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
                                          ],
                                        ),
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
                                child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  buildDataTable(),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Annual Premium: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  (widget.annualPremium)
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
                                                  'Basic Premium: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  (widget.basicPremium)
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
                                                  'Daily Premium: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  (widget.dailyPremium)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Text(
                                                  'Monthly Premium: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  (widget.monthlyPremium)
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
                                                  'Weekly Premium: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  (widget.weeklyPremium)
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
                                                  'Total Premium: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  (widget.totalPremium)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FontStyle.italic),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ))),
                      ],
                    ),
            ],
          ), //Card
        ),
      ), //Center

      
      floatingActionButton: (!widget.tableData.isEmpty)?
      
      SpeedDial(icon: Icons.add, children: [
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CalculatorPage(
                          userId: widget.userId,
                            userName: widget.userName,
                            phone: widget.phone,
                            email: widget.email,
                            message: widget.message,
                            title: widget.title,
                            readStatus: widget.readStatus,
                            notificationIdList: widget.notificationIdList,
                            nextPayment: widget.nextPayment,
                            paymentAmount: widget.paymentAmount,
                            paymentPeriod: widget.paymentPeriod,
                            policyNumber: widget.policyNumber,
                            sumInsured: widget.sumInsured,
                            claimApplicationActive: widget.claimApplicationActive,
                            qualifiesForCompensation: widget.qualifiesForCompensation,
                            uptoDatePayment: widget.uptoDatePayment,
                            buttonClaimStatus: widget.buttonClaimStatus,
                            promotionCode: widget.promotionCode,

                )));
          },
        ),
      ]):
      null
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
