import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:one_million_app/components/coverage/coverage_select_page.dart';
import 'package:one_million_app/components/coverage/coverage_select_subscription.dart';
import 'package:one_million_app/components/coverage/data/coverage_data.dart';
import 'package:one_million_app/components/coverage/model/coverage_model.dart';
import 'package:one_million_app/components/coverage/widget/scrollable_widget.dart';
import 'package:one_million_app/components/notification/notification.dart';
import 'package:one_million_app/components/profile/profile.dart';
import 'package:one_million_app/core/constant_urls.dart';
import 'package:one_million_app/core/model/notification_model.dart';
import 'package:one_million_app/shared/constants.dart';
class CoveragePage extends StatefulWidget {
  final num userId;
  final String userName;
  final String phone;
  final String email;
  const CoveragePage({Key? key,
  required this.userId,
  required this.userName,
    required this.phone,
    required this.email,}) : super(key: key);


  @override
  State<CoveragePage> createState() => _CoverageState();
}

class _CoverageState extends State<CoveragePage> {
  List<String> _coverages = ['Benefits', 'Sum Insured', 'Remaining Balance'];
  List<String> _selectedItems = [];
  List<String> _selectedItemsSubscription = [];
  List<dynamic> _selectedItemsValues = [];
  int? sortColumnIndex;
  bool isAscending = false;

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  String? dropdownValue;

  late String _statusMessage;
    num? _statusCode;

    late List<String> message =[];

  void _showMultiSelect(BuildContext context) async {
    final List<String> item = [
      '250,000',
      '500,000',
      '100,000',
      '2,000,000',
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return PremiumSelect(itemSelected: item);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }

    print(_selectedItems);

    print(_selectedItemsValues);
  }

  void _showMultiSelectSubscription(BuildContext context) async {
    final List<String> itemSubscription = [
      'Annualy',
      'Monthly',
      'Weekly',
      'Daily',
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SubscriptionSelect(itemSelected: itemSubscription);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItemsSubscription = results;
      });
    }
    print(_selectedItemsSubscription);
  }

  Future<List<NotificationModal>?> getNotification(userId) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.notificationEndpoint);
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        "userId": userId
      });

      final response = await http.post(url, headers: headers, body: body);

      print('Responce Status Code : ${response.statusCode}');
      print('Responce Body : ${response.body}');

      // var obj = jsonDecode(response.body);

      // obj.forEach((key, value) {
      //   _statusCode = obj["statusCode"];
      //   _statusMessage = obj["statusMessage"];
      //   _userId = obj["result"]["data"]["UserDetails"]["userId"];
      //   _name = obj["result"]["data"]["UserDetails"]["name"];
      //   _email = obj["result"]["data"]["UserDetails"]["email"];
      //   _msisdn = obj["result"]["data"]["UserDetails"]["msisdn"];
      // });

      if (response.statusCode == 200) {
        print('checking');
      } else {
        throw Exception('Unexpected Login error occured!');
      }
    } catch (e) {
      print("Error: $e");
      if (e is http.ClientException) {
        print("Response Body: ${e.message}");
      }
      log(e.toString());
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
              icon: Ink.image(
                image: const AssetImage('assets/icons/profile_icons/profile.jpg'),
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
              onPressed: () async {
                    await getNotification(
                      message
                    );

                    (_statusCode == 5000)
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return NotificationPage(message: message);
                              },
                            ),
                          )
                        : Navigator.pop(context);
                    setState(
                      () {},
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

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
            ),
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
              (allCoverages.isEmpty)
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
                                      fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
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
                      Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        CarouselSlider(
                          items: [
                            //1st Image of Slider
                            Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: kPrimaryWhiteColor,
                                ),
                                child: Image.asset(
                                  'assets/images/adverts/slide_one.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: kPrimaryWhiteColor,
                                ),
                                child: Image.asset(
                                  'assets/images/adverts/slide_two.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: kPrimaryWhiteColor,
                                ),
                                child: Image.asset(
                                  'assets/images/adverts/slide_three.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: kPrimaryWhiteColor,
                                ),
                                child: Image.asset(
                                  'assets/images/adverts/slide_four.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: kPrimaryWhiteColor,
                                ),
                                child: Image.asset(
                                  'assets/images/adverts/slide_five.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Card(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: kPrimaryWhiteColor,
                                ),
                                child: Image.asset(
                                  'assets/images/adverts/slide_six.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                          ],
          
                          //Slider Container properties
                          options: CarouselOptions(
                              height: 200,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              aspectRatio: 16 / 9,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enableInfiniteScroll: true,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              viewportFraction: 0.8,
                              onPageChanged: (index, reason) {}),
                        ),
                        // DotsIndicator(
                        //   dotsCount: contents.length,
                        //   position: _current.toInt(),
                        //   decorator: DotsDecorator(
                        //     shape: const Border(),
                        //     activeShape:
                        //         RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(35.0),),
                        //         color: kPrimaryColor,
                        //     size: Size(10, 10),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
        
              const SizedBox(height: 10),
                      Card(
                          elevation: 10,
                          shadowColor: Colors.black,
                          color: kPrimaryWhiteColor,
                          child: ScrollableWidget(child: buildDataTable())),
                    ],
                  ),
            ],
          ), //Card
        ),
      ), //Center
     
  
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMultiSelectSubscription(context);
        },
        child: const Icon(Icons.subscriptions),
         
      ),
    );
  }

  DataTable buildDataTable() {
    final List<String> columns = new List.from(_coverages)
      ..addAll(_selectedItems);

    return DataTable(
        columns: _createColumns(columns), rows: _createRows(allCoverages));
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
        final cellbenefits = [coverage.benefits, coverage.sumInsured, coverage.balance];
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

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 0),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: kPrimaryColor, width: 0),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ));
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

      
}
