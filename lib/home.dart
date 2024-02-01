import 'dart:convert';
import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:one_million_app/components/beneficiary/add_beneficiary_screen.dart';
import 'package:one_million_app/components/coverage/coverarage_make_payments.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/components/onbording_screens/already_have_an_account_acheck.dart';
import 'package:one_million_app/components/profile/profile.dart';
import 'package:one_million_app/components/upload_files/upload_files.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/default_claim.dart';
import 'package:one_million_app/core/model/initiate_claim.dart';
import 'package:one_million_app/core/model/uptodate_payment_status.dart';
import 'package:one_million_app/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  final String userName;
  final num userId;
  final String phone;
  final String email;
  final List<String> title;
  final List<String> message;
  final List<String> readStatus;
  final List<num> notificationIdList;

  final String promotionCode;
  final bool buttonClaimStatus;

  final String claimApplicationActive;
  final num paymentAmountUptoDate;
  final String qualifiesForCompensation;
  final String uptoDatePayment;

  final List<dynamic> claimListData;
  final String profilePic;

  final String nextPayment;
  final String paymentPeriod;
  final String policyNumber;
  final num sumInsured;
  final num paymentAmount;
  final num statusCodePolicyDetails;
  final num count;

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
      required this.paymentAmountUptoDate,
      required this.promotionCode,
      required this.buttonClaimStatus,
      required this.claimListData,
      required this.nextPayment,
      required this.paymentAmount,
      required this.paymentPeriod,
      required this.policyNumber,
      required this.profilePic,
      required this.sumInsured,
      required this.statusCodePolicyDetails,
      required this.count});

  @override
  State<HomePage> createState() => _HomePageState();
}

//policy Details Modal

class _HomePageState extends State<HomePage> {

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  int selectedPageIndex = 0;

  int _currentIndex = 0;
  final List _children = [];

  int count = 0;

  bool? checkboxValue = false;
  bool? checkedValue = false;

  // This function is triggered when a checkbox is checked or unchecked
  Future<void> _itemChange(num notificationId) async {
    await ApiService().sendMarkAsRead(widget.userId, notificationId);
    setState(() {});
  }

  // This function is triggered when a checkbox is checked or unchecked
  Future<void> _itemChangeMarkAll() async {
    await ApiService().sendMarkAsAll(widget.userId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    setState(() {});
  }

  late bool _showCartBadge;
  Color color = Colors.red;
  @override
  Widget build(BuildContext context) {
    // print('Uptodate : ${uptoDatePayment}');
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, actions: <Widget>[
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
                                notificationListId: widget.notificationIdList,
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
                              notificationListId: widget.notificationIdList,
                              count: widget.count,
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        )
      ]

          // actions: <Widget>[
          //   // notification icon
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: IconButton(
          //       iconSize: 30,
          //       icon: const Icon(
          //         Icons.notifications,
          //         color: kPrimaryColor,
          //       ),
          //       // the method which is called
          //       // when button is pressed
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) {
          //               return NotificationPage(
          //                 userId: widget.userId,
          //                 readStatus: widget.readStatus,
          //                 title: widget.title,
          //                 message: widget.message,
          //                 notificationListId: widget.notificationIdList,
          //               );
          //             },
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ],
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
                              (widget.uptoDatePayment != null &&
                                      widget.uptoDatePayment.trim() != "")
                                  ? TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return MakePayments(
                                                userId: widget.userId,
                                                premiumSelected:
                                                    widget.paymentAmount,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Card(
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
                                        ),
                                      ),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return MakePayments(
                                                userId: widget.userId,
                                                premiumSelected:
                                                    widget.paymentAmount,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 5,
                                        shadowColor: Colors.black,
                                        color: Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(
                                            child: Text('Not Covered'),
                                          ),
                                        ),
                                      ),
                                    )
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
                      child: GridView.count(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    childAspectRatio: (280 / 280),
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return MakePayments(
                                    userId: widget.userId,
                                    premiumSelected: widget.paymentAmount,
                                  );
                                },
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: kPrimaryColor,
                                child: Icon(
                                  Icons.payment,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Center(
                                child: Text(
                                  'Pay',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return BeneficiaryScreen(
                                      userId: widget.userId,
                                      name: widget.userName,
                                      msisdn: widget.phone,
                                      email: widget.email,
                                      promotionCode: widget.promotionCode,
                                      notificationIdList:
                                          widget.notificationIdList,
                                      buttonClaimStatus:
                                          widget.buttonClaimStatus,
                                      nextPayment: widget.nextPayment,
                                      paymentAmount: widget.paymentAmount,
                                      paymentPeriod: widget.paymentPeriod,
                                      policyNumber: widget.policyNumber,
                                      sumInsured: widget.sumInsured,
                                      statusCodePolicyDetails:
                                          widget.statusCodePolicyDetails,
                                      tableData: [],
                                      rowsBenefits: [],
                                      rowsSumIsured: [],
                                      claimListData: widget.claimListData,
                                      profilePic: widget.profilePic,
                                      readStatus: widget.readStatus,
                                      message: widget.message,
                                      title: widget.title,
                                      count: widget.count,
                                      claimApplicationActive:
                                          widget.claimApplicationActive,
                                      paymentAmountUptoDate:
                                          widget.paymentAmountUptoDate,
                                      qualifiesForCompensation:
                                          widget.qualifiesForCompensation,
                                      uptoDatePayment: widget.uptoDatePayment);
                                },
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: kPrimaryColor,
                                child: Icon(
                                  Icons.people,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Center(
                                child: Text(
                                  'Dependants',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return UploadFiles(userId: widget.userId);
                                },
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: kPrimaryColor,
                                child: Icon(
                                  Icons.file_download,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Center(
                                child: Text(
                                  'Documents',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: TextButton(
                          onPressed: () async {
                            await ApiService().generatePromo(widget.userId);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: kPrimaryColor,
                                child: Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Center(
                                child: Text(
                                  'Share',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: (widget.buttonClaimStatus == false)
                            ? TextButton(
                                onPressed: null,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: kPrimaryColor,
                                      child: Icon(
                                        Icons.folder,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Center(
                                      child: Text(
                                        'Default Claims',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : TextButton(
                                onPressed: () async {
                                  await ApiService().claimDefault(
                                      widget.userId, widget.promotionCode);
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: kPrimaryColor,
                                      child: Icon(
                                        Icons.folder,
                                        color: kPrimaryColor,
                                        size: 35,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: Text(
                                        'Default Claims',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  )
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
                                notificationListId: widget.notificationIdList,
                                count: widget.count,
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
                                    SizedBox(
                                      height: 10,
                                    ),
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
                                            child: ListTile(
                                              leading:
                                                  Icon(Icons.notifications),
                                              title: Text(
                                                widget.title[index],
                                                style:
                                                    (widget.readStatus[index] ==
                                                            'Unread')
                                                        ? TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )
                                                        : TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                              ),
                                              subtitle: Text(
                                                widget.message[index],
                                                style:
                                                    (widget.readStatus[index] ==
                                                            'Unread')
                                                        ? TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )
                                                        : TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                              ),
                                              onTap: () async {
                                                await ApiService().sendMarkAsRead(
                                                    widget.userId,
                                                    widget.notificationIdList[
                                                        index]);
                                              },
                                            ));
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
