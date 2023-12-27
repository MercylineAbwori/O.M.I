import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:one_million_app/components/beneficiary/add_beneficiary_screen.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/components/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/components/profile/profile.dart';
import 'package:one_million_app/components/upload_files/upload_files.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/initiate_claim.dart';
import 'package:one_million_app/core/model/uptodate_payment_status.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String userName;
  final num userId;
  final String phone;
  final String email;
  final List<String> title;
  final List<String> message;
  final List<String> readStatus;
  final String uptoDatePayment;
  final String promotionCode;
  final bool buttonClaimStatus;
  final List<num> notificationIdList;
  final String claimApplicationActive;
 final String qualifiesForCompensation;

 final List<dynamic> claimListData;
 final String profilePic;

 final String nextPayment;
  final String paymentPeriod;
  final String policyNumber;
  final num sumInsured;
  final num paymentAmount;

  HomePage(
      {super.key,
      required this.userId,
      required this.userName,
      required this.phone,
      required this.email,
      required this.title,
      required this.message,
      required this.readStatus,
      required this.notificationIdList,
      required this.uptoDatePayment,
      required this.claimApplicationActive,
      required this.qualifiesForCompensation,
      required this.promotionCode,
      required this.buttonClaimStatus,
      required this.claimListData,
      required this.nextPayment,
      required this.paymentAmount,
      required this.paymentPeriod,
      required this.policyNumber,
      required this.profilePic,
      required this.sumInsured});

  @override
  State<HomePage> createState() => _HomePageState();
}

//policy Details Modal

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  final titles = ["List 1", "List 2", "List 3", "List 4", "List 5"];
  final subtitles = [
    "Here is list 1 subtitle",
    "Here is list 2 subtitle",
    "Here is list 3 subtitle",
    "Here is list 4 subtitle",
    "Here is list 5 subtitle",
  ];

  int selectedPageIndex = 0;

  int _currentIndex = 0;
  final List _children = [];

  int count = 0;

  bool? checkboxValue = false;
  bool? checkedValue = false;

  // This function is triggered when a checkbox is checked or unchecked
  Future<void> _itemChange(num notificationId) async {
    await ApiService().sendMarkAsRead(widget.userId, notificationId);
    setState(() {
      
      
    });
  }
  // This function is triggered when a checkbox is checked or unchecked
  Future<void> _itemChangeMarkAll() async {
    await ApiService().sendMarkAsAll(widget.userId);
    setState(() {
      
      
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: Container(
        //   child: Padding(
        //     padding: const EdgeInsets.all(4.0),
        //     child: IconButton(
        //       iconSize: 100,
        //       icon: Ink.image(
        //         image:
        //             const AssetImage('assets/icons/profile_icons/profile.jpg'),
        //       ),
        //       // the method which is called
        //       // when button is pressed
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) {
        //               return ProfileScreen(
        //                 userName: widget.userName,
        //                 userId: widget.userId,
        //                 phone: widget.phone,
        //                 email: widget.email,
        //                 message: widget.message,
        //               );
        //             },
        //           ),
        //         );
        //         setState(
        //           () {
        //             count++;
        //           },
        //         );
        //       },
        //     ),
        //   ),
        // ),
        actions: <Widget>[
          // notification icon
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              iconSize: 30,
              icon: const Icon(
                Icons.notifications,
                color: kPrimaryColor,
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
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // welcome home
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello " + widget.userName,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Happy to see you back! ',
                              // style: GoogleFonts.bebasNeue(fontSize: 72),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Center(
                        child: Container(
                          child: Column(
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
                                    child: Expanded(
                                      child: Center(
                                        child: Text(widget.uptoDatePayment),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //Divider

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Divider(
                  thickness: 1,
                  color: Color.fromARGB(255, 204, 204, 204),
                ),
              ),

              const SizedBox(height: 20),

              //Home title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  "Quick Actions",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  shadowColor: Colors.black,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              //Add Beneficiary
                              Container(
                                width: 175,
                                height: 100,
                                padding: EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryLightColor,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return BeneficiaryScreen(
                                            userId : widget.userId,
                                            name: widget.userName,
                                            msisdn: widget.phone,
                                            email: widget.email,
                                            readStatus: widget.readStatus,
                                            title: widget.title,
                                            message: widget.message,
                                            notificationIdList: widget.notificationIdList,
                                            uptoDatePayment: widget.uptoDatePayment,
                                            qualifiesForCompensation: widget.qualifiesForCompensation,
                                            claimApplicationActive: widget.claimApplicationActive,
                                            promotionCode: widget.promotionCode,
                                            buttonClaimStatus: widget.buttonClaimStatus,
                                            tableData: [],
                                            rowsBenefits: [],
                                            rowsSumIsured: [],
                                            claimListData: widget.claimListData,
                                            profilePic: widget.profilePic,
                                            nextPayment: widget.nextPayment,
                                            paymentAmount: widget.paymentAmount,
                                            paymentPeriod: widget.paymentPeriod,
                                            policyNumber: widget.policyNumber,
                                            sumInsured: widget.sumInsured,
                                          );
                                        },
                                      ),
                                    );
                                    setState(
                                      () {
                                        count++;
                                      },
                                    );
                                  },
                                  child: Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 5),
                                          // Image.asset(
                                          //   'assets/icons/home_icons/claims.png',
                                          //   width: 40,
                                          //   height: 40,
                                          //   fit: BoxFit.cover,
                                          // ),
                                          Icon(Icons.people, 
                                          color: kPrimaryColor,
                                          size: 40,),
                                          const SizedBox(height: 5),
                                          const Text(
                                            'Add Beneficiary',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                            // style: GoogleFonts.bebasNeue(fontSize: 72),
                                          ),
                                          const SizedBox(height: 5),
                                        ]),
                                  ),
                                ),
                              ),
                              //Upload Documents
                              Container(
                                width: 175,
                                height: 100,
                                padding: EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryLightColor,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return UploadFiles(
                                              userId: widget.userId);
                                        },
                                      ),
                                    );
                                    setState(
                                      () {
                                        count++;
                                      },
                                    );
                                  },
                                  child: Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 5),
                                          // Image.asset(
                                          //   'assets/icons/home_icons/reporting.png',
                                          //   width: 40,
                                          //   height: 40,
                                          //   fit: BoxFit.cover,
                                          // ),
                                          Icon(Icons.file_download, 
                                          color: kPrimaryColor,
                                          size: 40,),
                                          const SizedBox(height: 5),
                                          const Text(
                                            'Upload Documents',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                            // style: GoogleFonts.bebasNeue(fontSize: 72),
                                          ),
                                          const SizedBox(height: 5),
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              //Share Promo Code
                              Container(
                                width: 175,
                                height: 100,
                                padding: EdgeInsets.all(10.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryLightColor,
                                  ),
                                  onPressed: () async {
                                    await ApiService().shareApp();
                                    setState(
                                      () {
                                        count++;
                                      },
                                    );
                                  },
                                  child: Center(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 5),
                                          // Image.asset(
                                          //   'assets/icons/home_icons/payment.png',
                                          //   width: 40,
                                          //   height: 40,
                                          //   fit: BoxFit.cover,
                                          // ),
                                          Icon(Icons.share_sharp, 
                                          color: kPrimaryColor,
                                          size: 40,),
                                          const SizedBox(height: 5),
                                          const Text(
                                            'Overdue Bonus',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black),
                                            // style: GoogleFonts.bebasNeue(fontSize: 72),
                                          ),
                                          const SizedBox(height: 5),
                                        ]),
                                  ),
                                ),
                              ),
                              //Default Claim
                              Container(
                                width: 175,
                                height: 100,
                                padding: EdgeInsets.all(10.0),
                                child: (widget.buttonClaimStatus == false)
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimaryLightColor,
                                        ),
                                        onPressed: null,
                                        child: Center(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 5),
                                                // Image.asset(
                                                //   'assets/icons/home_icons/coverage.png',
                                                //   width: 40,
                                                //   height: 40,
                                                //   fit: BoxFit.cover,
                                                // ),
                                                Icon(Icons.folder, 
                                                color: kPrimaryColor,
                                                  size: 40,),
                                                const SizedBox(height: 5),
                                                const Text(
                                                  'Default Claims',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                  // style: GoogleFonts.bebasNeue(fontSize: 72),
                                                ),
                                                const SizedBox(height: 5),
                                              ]),
                                        ),
                                      )
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kPrimaryLightColor,
                                        ),
                                        onPressed: () async {
                                          await ApiService().claimDefault(
                                              widget.userId,
                                              widget.promotionCode);
                                        },
                                        child: Center(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 5),
                                                Image.asset(
                                                  'assets/icons/home_icons/payment.png',
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                ),
                                                const SizedBox(height: 5),
                                                const Text(
                                                  'Default Claims',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                  // style: GoogleFonts.bebasNeue(fontSize: 72),
                                                ),
                                                const SizedBox(height: 5),
                                              ]),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Recent Activities",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                    ViewAll(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return NotificationPage(
                                userId: widget.userId,
                                readStatus: widget.readStatus,
                                title: widget.title,
                                message: widget.message,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Container(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (widget.message.isEmpty)
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 5,
                                  shadowColor: Colors.black,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(40.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.info,
                                            size: 100,
                                            color: kPrimaryColor,
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            'You have no activities',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                            // style: GoogleFonts.bebasNeue(fontSize: 72),
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                child: Column(
                                  children: [
                                    CheckboxListTile(
                                      title: Text("Mark All"), //    <-- label
                                      value: (widget.readStatus.contains('Unread'))
                                                    ? checkedValue = false
                                                    : checkedValue = true,
                                      onChanged: (newValue) => _itemChangeMarkAll(),
                                    ),
                                    SizedBox(height: 10,),
                                    ListView.separated(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(8),
                                      itemCount: 5,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          color: Colors.white,
                                          borderOnForeground: true,
                                          elevation: 6,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              CheckboxListTile(
                                                value: (widget.readStatus[index] ==
                                                        'Read')
                                                    ? checkboxValue = true
                                                    : checkboxValue = false,
                                                onChanged: (isChecked) =>
                                                  _itemChange(widget.notificationIdList[index]),
                                                
                                                secondary:
                                                    const Icon(Icons.notifications),
                                                title: Text(widget.title[index]),
                                                subtitle:
                                                    Text(widget.message[index]),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              const Divider(),
                                    ),
                                  ],
                                ),
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
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
