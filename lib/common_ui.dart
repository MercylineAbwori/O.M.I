import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:one_million_app/components/claims/claims_home_page_screen.dart';
import 'package:one_million_app/components/coverage/coverage_screen.dart';
import 'package:one_million_app/components/profile/profile.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/claim_list_model.dart';
import 'package:one_million_app/core/model/policy_details.dart';
import 'package:one_million_app/home.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:http/http.dart' as http;

class CommonUIPage extends StatefulWidget {
  final num userId;
  final String name;
  final String msisdn;
  final String email;

  final List<String> message;

  final String uptoDatePaymentData;

  final String promotionCode;

  final bool buttonClaimStatus;

  //Policy Details

  final String nextPayment;
  final num paymentAmount;
  final String paymentPeriod;
  final String policyNumber;
  final num sumInsured;

  final List<dynamic> tableData;

  final List<dynamic> rowsBenefits;
  final List<dynamic> rowsSumIsured;

  final List<dynamic> claimListData;

  final String profilePic;

  CommonUIPage(
      {Key? key,
      required this.userId,
      required this.name,
      required this.msisdn,
      required this.email,
      required this.message,
      required this.uptoDatePaymentData,
      required this.promotionCode,
      required this.buttonClaimStatus,
      required this.nextPayment,
      required this.paymentAmount,
      required this.paymentPeriod,
      required this.policyNumber,
      required this.sumInsured,
      required this.tableData,
      required this.rowsBenefits,
      required this.rowsSumIsured,
      required this.claimListData,
      required this.profilePic})
      : super(key: key);
  @override
  _CommonUIPageState createState() => _CommonUIPageState();
}

class _CommonUIPageState extends State<CommonUIPage> {
  int _selectedIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomePage(
            userName: widget.name,
            userId: widget.userId,
            phone: widget.msisdn,
            email: widget.email,
            message: widget.message,
            uptoDatePaymentData: widget.uptoDatePaymentData,
            promotionCode: widget.promotionCode,
            buttonClaimStatus: widget.buttonClaimStatus);
      case 1:
        return CoveragePage(
            userName: widget.name,
            userId: widget.userId,
            phone: widget.msisdn,
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
            tableData: [],
            rowsBenefits: [],
            rowsSumIsured: [],
            addStampDuty: 0,
            annualPremium: 0,
            basicPremium: 0,
            dailyPremium: 0,
            monthlyPremium: 0,
            totalPremium: 0,
            weeklyPremium: 0);
      case 2:
        return ClaimHomePage(
            userName: widget.name,
            userId: widget.userId,
            phone: widget.msisdn,
            email: widget.email,
            message: widget.message,
            claimListData: widget.claimListData);
      case 3:
        return ProfileScreen(
            userName: widget.name,
            userId: widget.userId,
            phone: widget.msisdn,
            email: widget.email,
            message: widget.message,
            profilePic: widget.profilePic);

      default:
        HomePage(
            userName: widget.name,
            userId: widget.userId,
            phone: widget.msisdn,
            email: widget.email,
            message: widget.message,
            uptoDatePaymentData: widget.uptoDatePaymentData,
            promotionCode: widget.promotionCode,
            buttonClaimStatus: widget.buttonClaimStatus);
    }
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
    // if(_selectedIndex == 1){
    //   await getPolicyDetails(widget.userId);
    // }else if(_selectedIndex == 2){
    //   await getClaimList(widget.userId);
    // }
    // await getPolicyDetails(widget.userId);
    // await getClaimList(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _getDrawerItemWidget(_selectedIndex),
        ),
        bottomNavigationBar: TitledBottomNavigationBar(
            // Use this to update the Bar giving a position

            currentIndex: _selectedIndex,
            // selectedItemColor: kPrimaryWhiteColor,
            onTap: _onItemTapped,
            items: [
              TitledNavigationBarItem(
                  title: Text('Home'), icon: Icon(Icons.home)),
              TitledNavigationBarItem(
                  title: Text('Coverage'), icon: Icon(Icons.business)),
              TitledNavigationBarItem(
                  title: Text('Claim'), icon: Icon(Icons.payment)),
              TitledNavigationBarItem(
                  title: Text('Profile'), icon: Icon(Icons.person))
            ]));
  }
}
