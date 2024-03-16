import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:one_million_app/core/constant_service.dart';
import 'package:one_million_app/core/local_storage.dart';
import 'package:one_million_app/core/services/models/claim_lists_model.dart';
import 'package:one_million_app/core/services/models/notification_model.dart';
import 'package:one_million_app/core/services/models/uptodate_model.dart';
import 'package:one_million_app/core/services/providers/claim_list_providers.dart';
import 'package:one_million_app/core/services/providers/notification_provider.dart';
import 'package:one_million_app/core/services/providers/uptodate_providers.dart';
import 'package:one_million_app/shared/constants.dart';

class ClaimList extends ConsumerStatefulWidget {
  const ClaimList({super.key});

  @override
  ConsumerState<ClaimList> createState() {
    return _ClaimListState();
  }
}

class _ClaimListState extends ConsumerState<ClaimList> {
  List<claimListItem> _data = [];
  var _isLoading = true;
  String? error;

  List<upToDateListItem> _dataUpToDate = [];
  var _isLoadingUpToDate = true;
  String? errorUpToDate;

  num _selectedIndex = 0;

  num? userId;
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  Future<void> loadUserData() async {
    // var _userId = await LocalStorage().getUserRegNo();
    var _userId = 1;
    if (_userId != null) {
      setState(() {
        userId = _userId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // // Reload shops
    ref.read(claimListProvider.notifier).fetchClaims();

    // // Reload shops
    ref.read(upToDateListProvider.notifier).fetchUpToDate();

    // _selectedIndex = widget.selectedIndex!;
  }

  // This function is triggered when a checkbox is checked or unchecked
  Future<void> _itemChangeMarkAll() async {
    await ApiService().sendMarkAsAll(userId);
    setState(() {});
  }

  bool isChecked = false;

  late claimListModel availableData;
  late upToDateListModel availableUpToDate;

  String? claimApplicationActive;
  num? paymentAmountUptoDate;
  String? qualifiesForCompensation;
  String? uptoDatePayment;

  @override
  Widget build(BuildContext context) {
    availableData = ref.watch(claimListProvider);
    availableUpToDate = ref.watch(upToDateListProvider);

    setState(() {
      _data = availableData.claim_data;
      _isLoading = availableData.isLoading;

      _dataUpToDate = availableUpToDate.uptodate_data;
      _isLoadingUpToDate = availableUpToDate.isLoading;

      for (var i = 0; i < _dataUpToDate.length; i++) {
        claimApplicationActive = _dataUpToDate[i].claimApplicationActive;
        paymentAmountUptoDate = _dataUpToDate[i].paymentAmount;
        qualifiesForCompensation = _dataUpToDate[i].qualifiesForCompensation;
        uptoDatePayment = _dataUpToDate[i].uptoDatePayment;
      }
    });

    Widget content = const Center(
      child: Text('No data yet',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
    );
    Widget contentUptoDate = const Center(
      child: Text('No data yet',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
    );

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_isLoadingUpToDate) {
      contentUptoDate = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      content = Center(
        child: Text(error!),
      );
    }

    if (error != null) {
      contentUptoDate = Center(
        child: Text(error!),
      );
    }

    if (_data.isNotEmpty) {
      content = Column(
        children: [
          Container(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: _data.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.white,
                  borderOnForeground: true,
                  elevation: 6,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          // child: Icon(icons[index])
                          child: Icon(_data[index].processingStatus == 'death'
                              ? Icons.dangerous
                              : _data[index].processingStatus ==
                                      'permanent disability'
                                  ? Icons.wheelchair_pickup_outlined
                                  : _data[index].processingStatus ==
                                          'temporary disability'
                                      ? Icons.personal_injury
                                      : _data[index].processingStatus ==
                                              'artificial appliances'
                                          ? Icons.emoji_flags
                                          : _data[index].processingStatus ==
                                                  'funeral expences'
                                              ? Icons.money_off
                                              : Icons
                                                  .medical_information_outlined),
                        ),
                        title: Text(_data[index].claimType),
                        subtitle: Text(
                            formatter
                                .format(DateTime.parse(_data[index].updatedAt)),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            )),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _data[index].claimType == 'pending'
                                  ? 'Pending'
                                  : _data[index].claimType == 'in review'
                                      ? 'In Review'
                                      : _data[index].claimType == 'completed'
                                          ? 'Completed'
                                          : 'Failed',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: _data[index].claimType == 'failed'
                                    ? Colors.red
                                    : _data[index].claimType == 'pending'
                                        ? Colors.yellowAccent
                                        : _data[index].claimType == 'in Review'
                                            ? Colors.blue
                                            : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Divider(
              thickness: 1,
              color: Color.fromARGB(255, 204, 204, 204),
            ),
          ),
        ],
      );
    }else{
      content = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shadowColor: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
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
                  'You have no claim',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  // style: GoogleFonts.bebasNeue(fontSize: 72),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Use the CREATE A CLAIM button to create a new form',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  // style: GoogleFonts.bebasNeue(fontSize: 72),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      fixedSize: const Size(200, 40)),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) {
                    //       return ClaimForm(
                    //         userId: widget.userId,
                    //         claimApplicationActive:
                    //             widget.claimApplicationActive,
                    //         paymentAmount: widget.paymentAmountUptoDate,
                    //         qualifiesForCompensation:
                    //             widget.qualifiesForCompensation,
                    //         uptoDatePayment: widget.uptoDatePayment,
                    //       );
                    //     },
                    //   ),
                    // );
                    // _showDia// log();
                  },
                  child: Text(
                    "Create a new Claim".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    }

    if (_dataUpToDate.isNotEmpty) {
      contentUptoDate = (claimApplicationActive !=
                  "You will be eligiable to apply for claims after 60 days of registartion") &&
              (qualifiesForCompensation ==
                  "Your payment is not upto date ,you are not eligiable for claim application")
          ? FloatingActionButton(
              onPressed: () {
                (qualifiesForCompensation ==
                        "Your payment is not upto date ,you are not eligiable for claim application")
                    ? Fluttertoast.showToast(
                        msg: claimApplicationActive!,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      )
                    : Fluttertoast.showToast(
                        msg: qualifiesForCompensation!,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) {
                //       return ClaimForm(
                //         userId: widget.userId,
                //         claimApplicationActive: widget.claimApplicationActive,
                //         paymentAmount: widget.paymentAmountUptoDate,
                //         qualifiesForCompensation:
                //             widget.qualifiesForCompensation,
                //         uptoDatePayment: widget.uptoDatePayment,
                //       );
                //     },
                //   ),
                // );
              },
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () {
                (qualifiesForCompensation ==
                        "Your payment is not upto date ,you are not eligiable for claim application")
                    ? Fluttertoast.showToast(
                        msg: claimApplicationActive!,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      )
                    : Fluttertoast.showToast(
                        msg: qualifiesForCompensation!,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
              },
              child: const Icon(Icons.add),
            );
    }

    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 25),
                    // welcome home
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: const Text(
                            "Claims",
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

                    content
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: contentUptoDate);
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
