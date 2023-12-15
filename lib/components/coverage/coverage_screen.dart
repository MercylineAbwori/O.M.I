import 'dart:convert';
import 'dart:developer';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_million_app/common_ui.dart';
import 'package:one_million_app/components/coverage/coverage_select/coverage_select_options.dart';
import 'package:one_million_app/components/coverage/coverage_select/coverage_select_subscription.dart';
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

  final String uptoDatePaymentData;

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
      required this.sumInsured,
      required this.tableData,
      required this.rowsBenefits,
      required this.rowsSumIsured,
      required this.buttonClaimStatus,
      required this.promotionCode,
      required this.uptoDatePaymentData,
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
    '1000000',
    '2000000',
  ];

  final List<String> itemSubscription = [
    'Annualy',
    'Monthly',
    'Weekly',
    'Daily',
  ];

  Future<void> _showMultiSelect(BuildContext context) async {
    final List<dynamic>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PremiumSelect(
          itemSelected: item,
          userId: widget.userId,
          userName: widget.userName,
          phone: widget.phone,
          email: widget.email,
          message: widget.message,
          nextPayment: widget.nextPayment,
          paymentAmount: widget.paymentAmount,
          paymentPeriod: widget.paymentPeriod,
          policyNumber: widget.policyNumber,
          sumInsured: widget.sumInsured,
          uptoDatePaymentData: widget.uptoDatePaymentData,
          buttonClaimStatus: widget.buttonClaimStatus,
          promotionCode: widget.promotionCode,
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

  Future<void> _showMultiSelectSubscription(BuildContext context) async {
    final List<dynamic>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SubscriptionSelect(
          userId: widget.userId,
          itemSelected: item,
          annualPremium: widget.annualPremium,
      basicPremium:widget.weeklyPremium,
      dailyPremium: widget.dailyPremium,
      monthlyPremium: widget.monthlyPremium,
      totalPremium: widget.totalPremium,
      weeklyPremium: widget.totalPremium,
      phone: widget.phone,
      sumInsured: widget.sumInsured);
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
              icon: const Icon(Icons.arrow_back,
              color: Colors.black,
              size: 20,),
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
              (widget.tableData.isEmpty)
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
                                    setState(
                                      () {
                                        print('After show ${widget.tableData}');
                                      },
                                    );
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
    print(widget.tableData);
    return DataTable(
        // Datatable widget that have the property columns and rows.
        columns: const [
          // Set the name of the column
          DataColumn(
            label: Text('Benefits',
            style: TextStyle(color: kPrimaryColor),),
          ),
          DataColumn(
            label: Text('Sum Insured',
            style: TextStyle(color: kPrimaryColor),),
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
