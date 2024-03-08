import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:badges/badges.dart' as badges;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_million_app/shared/constants.dart';

class Home extends ConsumerStatefulWidget {


  const Home({
    super.key,
  });



  @override
  ConsumerState<Home> createState() {
    return _SalesSummaryListState();
  }

}

class _SalesSummaryListState extends ConsumerState<Home> {

  @override
  void initState() {
    super.initState();
    
  }
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Text("Dtata")
    );
  }

  

}

// Helper class
class Utils {
  static String getFormattedDateSimple(int time) {
    DateFormat newFormat = DateFormat("MMMM dd yyyy");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleMonthAddDate(int time) {
    DateFormat newFormat = DateFormat("MMMM dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleMonthAddDateLess(int time) {
    DateFormat newFormat = DateFormat("MMM dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleFilter(int time) {
    DateFormat newFormat = DateFormat("yyyy-MM-dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }

  static String getFormattedDateSimpleToday(int time) {
    DateFormat newFormat = DateFormat("dd MMMM");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}
